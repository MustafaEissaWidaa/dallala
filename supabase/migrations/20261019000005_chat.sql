-- Dallala — conversations and messages (realtime).

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings (id) on delete cascade,
  buyer_id uuid not null references public.profiles (id) on delete cascade,
  seller_id uuid not null references public.profiles (id) on delete cascade,
  last_message_at timestamptz,
  last_message_preview text,
  buyer_unread integer not null default 0 check (buyer_unread >= 0),
  seller_unread integer not null default 0 check (seller_unread >= 0),
  created_at timestamptz not null default now(),
  unique (listing_id, buyer_id),
  check (buyer_id <> seller_id)
);
create index conversations_buyer_idx on public.conversations (buyer_id, last_message_at desc);
create index conversations_seller_idx on public.conversations (seller_id, last_message_at desc);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id uuid not null references public.profiles (id) on delete cascade,
  body text check (body is null or char_length(body) between 1 and 2000),
  -- chat-images bucket: {conversation_id}/{file}
  image_path text,
  -- {"lat": .., "lng": .., "label": ".."}
  location jsonb check (location is null or (jsonb_typeof(location) = 'object' and location ? 'lat' and location ? 'lng')),
  read_at timestamptz,
  created_at timestamptz not null default now(),
  check (body is not null or image_path is not null or location is not null)
);
create index messages_conversation_idx on public.messages (conversation_id, created_at desc);

create or replace function public.is_conversation_participant(conv uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.conversations c
    where c.id = conv and auth.uid() in (c.buyer_id, c.seller_id)
  )
$$;

-- Opens (or returns) the buyer's conversation about a listing.
create or replace function public.start_conversation(p_listing_id uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  me uuid := auth.uid();
  seller uuid;
  conv uuid;
begin
  if me is null then
    raise exception 'AUTH_REQUIRED';
  end if;
  if public.is_banned(me) then
    raise exception 'ACCOUNT_BANNED';
  end if;

  select user_id into seller from public.listings
  where id = p_listing_id and status = 'published';
  if seller is null then
    raise exception 'LISTING_NOT_AVAILABLE';
  end if;
  if seller = me then
    raise exception 'CANNOT_MESSAGE_SELF';
  end if;
  if public.is_banned(seller) or public.is_blocked_between(me, seller) then
    raise exception 'CANNOT_MESSAGE';
  end if;

  insert into public.conversations (listing_id, buyer_id, seller_id)
  values (p_listing_id, me, seller)
  on conflict (listing_id, buyer_id) do nothing
  returning id into conv;

  if conv is null then
    select id into conv from public.conversations
    where listing_id = p_listing_id and buyer_id = me;
  end if;
  return conv;
end
$$;

-- Validates a new message: sender is a participant, not banned, not
-- blocked, within the rate limit.
create or replace function public.messages_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  c public.conversations;
  other uuid;
  recent integer;
begin
  select * into c from public.conversations where id = new.conversation_id;
  if not found or new.sender_id not in (c.buyer_id, c.seller_id) then
    raise exception 'FORBIDDEN';
  end if;
  other := case when new.sender_id = c.buyer_id then c.seller_id else c.buyer_id end;

  if public.is_banned(new.sender_id) then
    raise exception 'ACCOUNT_BANNED';
  end if;
  if public.is_blocked_between(new.sender_id, other) then
    raise exception 'CANNOT_MESSAGE';
  end if;
  if new.image_path is not null and new.image_path not like new.conversation_id::text || '/%' then
    raise exception 'INVALID_IMAGE_PATH';
  end if;

  select count(*) into recent from public.messages
  where sender_id = new.sender_id and created_at > now() - interval '1 minute';
  if recent >= 30 then
    raise exception 'RATE_LIMITED';
  end if;

  new.read_at := null;
  new.created_at := now();
  return new;
end
$$;

create trigger messages_guard before insert on public.messages
  for each row execute function public.messages_guard();

-- Keeps conversation previews and unread counters in sync.
create or replace function public.messages_after_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  c public.conversations;
begin
  update public.conversations
  set last_message_at = new.created_at,
      last_message_preview = left(coalesce(new.body, case when new.image_path is not null then '📷' else '📍' end), 120),
      buyer_unread = buyer_unread + case when new.sender_id = seller_id then 1 else 0 end,
      seller_unread = seller_unread + case when new.sender_id = buyer_id then 1 else 0 end
  where id = new.conversation_id
  returning * into c;
  return null;
end
$$;

create trigger messages_after_insert after insert on public.messages
  for each row execute function public.messages_after_insert();

-- Marks everything the other party sent as read (✓✓) and clears my counter.
create or replace function public.mark_conversation_read(p_conversation_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  me uuid := auth.uid();
  c public.conversations;
begin
  select * into c from public.conversations where id = p_conversation_id;
  if not found or me not in (c.buyer_id, c.seller_id) then
    raise exception 'FORBIDDEN';
  end if;

  update public.messages set read_at = now()
  where conversation_id = p_conversation_id and sender_id <> me and read_at is null;

  update public.conversations
  set buyer_unread = case when me = buyer_id then 0 else buyer_unread end,
      seller_unread = case when me = seller_id then 0 else seller_unread end
  where id = p_conversation_id;
end
$$;

-- Realtime (present on Supabase; skipped where the publication is absent).
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table public.messages, public.conversations;
  end if;
end
$$;
