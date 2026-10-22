-- Dallala — localities, profiles, roles, privacy (blocks), notification
-- preferences and device tokens.

-- Localities (editable from the dashboard) --------------------------------
create table public.localities (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null check (char_length(name_ar) between 1 and 60),
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (name_ar)
);

-- Profiles ------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text check (full_name is null or char_length(btrim(full_name)) between 1 and 60),
  avatar_url text,
  -- E.164 phone from Supabase Auth. Never exposed directly to other users;
  -- see public.public_profiles.
  phone text,
  bio text check (bio is null or char_length(bio) <= 150),
  -- Where the user lives (shown on their profile).
  locality_id uuid references public.localities (id) on delete set null,
  -- What Home shows first (screen 38). NULL = «كل شمال كردفان».
  default_locality_id uuid references public.localities (id) on delete set null,
  show_phone boolean not null default true,
  whatsapp_enabled boolean not null default true,
  role text not null default 'user' check (role in ('user', 'moderator', 'admin')),
  is_verified boolean not null default false,
  verified_at timestamptz,
  is_banned boolean not null default false,
  ban_reason text,
  -- NULL with is_banned = permanent ban (admin only).
  banned_until timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  last_seen_at timestamptz,
  check (not is_banned or ban_reason is not null)
);

create index profiles_role_idx on public.profiles (role) where role <> 'user';
create index profiles_phone_idx on public.profiles (phone);
create index profiles_name_trgm_idx on public.profiles
  using gin (public.normalize_ar(full_name) extensions.gin_trgm_ops);

create trigger profiles_touch before update on public.profiles
  for each row execute function public.touch_updated_at();

-- Role helpers. SECURITY DEFINER so policies can call them without
-- recursing into profiles' own RLS.
create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid()
      and p.role in ('moderator', 'admin')
      and not p.is_banned
  )
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and not p.is_banned
  )
$$;

-- Banned = flag set and (permanent or not yet expired).
create or replace function public.is_banned(uid uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((
    select p.is_banned and (p.banned_until is null or p.banned_until > now())
    from public.profiles p where p.id = uid
  ), false)
$$;

-- Users may edit their own profile, but never their role, verification,
-- ban state or phone (phone changes go through Auth OTP). Staff rules:
-- moderators can verify and apply temporary bans only; admins anything.
-- SECURITY INVOKER: trusted server code (owner/service_role) is exempt.
create or replace function public.profiles_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if current_user not in ('anon', 'authenticated') then
    return new;
  end if;

  if public.is_admin() then
    return new;
  end if;

  if public.is_staff() and new.id <> auth.uid() then
    if new.role is distinct from old.role then
      raise exception 'FORBIDDEN' using detail = 'Only admins can change roles';
    end if;
    if new.is_banned and new.banned_until is null then
      raise exception 'FORBIDDEN' using detail = 'Moderators cannot ban permanently';
    end if;
    return new;
  end if;

  if new.id <> auth.uid() then
    raise exception 'FORBIDDEN';
  end if;

  if new.role is distinct from old.role
     or new.is_verified is distinct from old.is_verified
     or new.verified_at is distinct from old.verified_at
     or new.is_banned is distinct from old.is_banned
     or new.ban_reason is distinct from old.ban_reason
     or new.banned_until is distinct from old.banned_until
     or new.phone is distinct from old.phone
     or new.created_at is distinct from old.created_at then
    raise exception 'FORBIDDEN' using detail = 'Protected profile field';
  end if;
  return new;
end
$$;

create trigger profiles_guard before update on public.profiles
  for each row execute function public.profiles_guard();

-- Blocked users (screen 37): blocked accounts can't message you or see your
-- number.
create table public.blocked_users (
  blocker_id uuid not null references public.profiles (id) on delete cascade,
  blocked_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);
create index blocked_users_blocked_idx on public.blocked_users (blocked_id);

-- True when either user has blocked the other.
create or replace function public.is_blocked_between(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.blocked_users
    where (blocker_id = a and blocked_id = b)
       or (blocker_id = b and blocked_id = a)
  )
$$;

-- Notification preferences (screen 39), one row per user per type.
-- A missing row means the default. Security/account alerts are not
-- configurable and are always delivered.
create table public.notification_preferences (
  user_id uuid not null references public.profiles (id) on delete cascade,
  type text not null check (type in (
    'all',                -- master switch «كل الإشعارات»
    'new_message',        -- «رسائل جديدة»
    'listing_review',     -- «نشر أو رفض الإعلان»
    'listing_expiring',   -- «قرب انتهاء الإعلان»
    'promotion_ended',    -- «انتهاء التمييز»
    'saved_search_match', -- «إعلانات جديدة تطابق بحثك»
    'price_drop',         -- «نزول السعر»
    'topup',              -- «طلبات الشحن»
    'tips_news'           -- «نصائح وأخبار» (off by default)
  )),
  enabled boolean not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, type)
);

create trigger notification_preferences_touch before update on public.notification_preferences
  for each row execute function public.touch_updated_at();

-- Device tokens for push (FCM).
create table public.device_tokens (
  user_id uuid not null references public.profiles (id) on delete cascade,
  token text not null check (char_length(token) between 10 and 4096),
  platform text not null check (platform in ('android', 'ios', 'web')),
  updated_at timestamptz not null default now(),
  primary key (user_id, token)
);
create unique index device_tokens_token_idx on public.device_tokens (token);

-- Public view of a profile. Phone is only revealed to signed-in users when
-- the owner allows calls or WhatsApp, and never across a block. Banned
-- users are hidden. Runs with the owner's rights on purpose: it exposes a
-- fixed, safe column set instead of the private profiles table.
create view public.public_profiles
with (security_barrier = true)
as
select
  p.id,
  p.full_name,
  p.avatar_url,
  p.bio,
  p.locality_id,
  p.is_verified,
  p.verified_at,
  p.show_phone,
  p.whatsapp_enabled,
  p.created_at,
  p.last_seen_at,
  case
    when auth.uid() is not null
     and (p.show_phone or p.whatsapp_enabled)
     and not public.is_blocked_between(p.id, auth.uid())
    then p.phone
  end as contact_phone
from public.profiles p
where not public.is_banned(p.id)
  and p.full_name is not null;

comment on view public.public_profiles is
  'Safe public profile columns; contact_phone only for signed-in, non-blocked viewers when the owner allows it.';
