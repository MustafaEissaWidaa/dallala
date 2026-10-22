-- Dallala — listings, images, favourites, saved searches, view counting.

create table public.listings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  category_id uuid not null references public.categories (id),
  subcategory_id uuid references public.subcategories (id),
  locality_id uuid not null references public.localities (id),
  neighborhood text check (neighborhood is null or char_length(neighborhood) <= 60),
  title text not null check (char_length(btrim(title)) between 3 and 70),
  description text not null default '' check (char_length(description) <= 4000),
  -- Whole Sudanese pounds. Shape depends on price_mode:
  --   fixed / from  → price set, price_max null
  --   range         → price..price_max (salaries, screen 53)
  --   on_request    → no price («حسب المشوار», screen 54)
  price bigint check (price is null or price >= 0),
  price_max bigint check (price_max is null or price_max >= 0),
  price_mode text not null default 'fixed' check (price_mode in ('fixed', 'from', 'range', 'on_request')),
  price_unit text,
  is_negotiable boolean not null default false,
  attributes jsonb not null default '{}'::jsonb check (jsonb_typeof(attributes) = 'object'),
  status text not null default 'pending'
    check (status in ('draft', 'pending', 'published', 'rejected', 'expired', 'sold', 'deleted')),
  reject_reason text,
  views_count integer not null default 0 check (views_count >= 0),
  published_at timestamptz,
  expires_at timestamptz,
  sold_at timestamptz,
  featured_until timestamptz,
  featured_package_id uuid references public.promotion_packages (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  search_vector tsvector,
  check (
    case price_mode
      when 'fixed' then price is not null and price_max is null
      when 'from' then price is not null and price_max is null
      when 'range' then price is not null and price_max is not null and price_max >= price
      when 'on_request' then price is null and price_max is null
    end
  ),
  check (status <> 'rejected' or reject_reason is not null),
  check (status <> 'published' or (published_at is not null and expires_at is not null))
);

create index listings_feed_idx on public.listings (status, locality_id, published_at desc);
create index listings_category_feed_idx on public.listings (status, category_id, subcategory_id, published_at desc);
create index listings_featured_idx on public.listings (featured_until) where featured_until is not null;
create index listings_user_idx on public.listings (user_id, created_at desc);
create index listings_expires_idx on public.listings (expires_at) where status = 'published';
create index listings_search_idx on public.listings using gin (search_vector);
create index listings_title_trgm_idx on public.listings
  using gin (public.normalize_ar(title) extensions.gin_trgm_ops);
create index listings_price_idx on public.listings (category_id, price) where status = 'published';

create trigger listings_touch before update on public.listings
  for each row execute function public.touch_updated_at();

-- Search vector: normalised title (A), category names (B), description (C).
create or replace function public.listings_search_vector()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  cat_names text;
begin
  select concat_ws(' ', c.name_ar, c.title_ar, s.name_ar)
    into cat_names
  from public.categories c
  left join public.subcategories s on s.id = new.subcategory_id
  where c.id = new.category_id;

  new.search_vector :=
    setweight(to_tsvector('simple', coalesce(public.normalize_ar(new.title), '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(public.normalize_ar(cat_names), '')), 'B') ||
    setweight(to_tsvector('simple', coalesce(public.normalize_ar(new.neighborhood), '')), 'C') ||
    setweight(to_tsvector('simple', coalesce(public.normalize_ar(new.description), '')), 'D');
  return new;
end
$$;

create trigger listings_search_vector
  before insert or update of title, description, neighborhood, category_id, subcategory_id
  on public.listings
  for each row execute function public.listings_search_vector();

-- Validates category/subcategory/unit and every attribute value against
-- category_attributes. Raises INVALID_LISTING / INVALID_ATTRIBUTE.
create or replace function public.listings_validate()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  sub_key text;
  sub_units text[];
  cat_units text[];
  units text[];
  attr record;
  k text;
  v jsonb;
  allowed jsonb;
  item jsonb;
  checks jsonb;
begin
  if new.subcategory_id is not null then
    select s.key, s.price_units into sub_key, sub_units
    from public.subcategories s
    where s.id = new.subcategory_id and s.category_id = new.category_id;
    if not found then
      raise exception 'INVALID_LISTING' using detail = 'subcategory does not belong to category';
    end if;
  end if;

  select c.price_units into cat_units from public.categories c where c.id = new.category_id;
  units := coalesce(sub_units, cat_units);
  if new.price_unit is not null and not (new.price_unit = any (units)) then
    raise exception 'INVALID_LISTING' using detail = 'price_unit not allowed for category';
  end if;

  -- `_checks` holds auto-moderation results and is written only by the
  -- server; keep the stored value whatever the client sends.
  checks := case when tg_op = 'UPDATE' then old.attributes -> '_checks' end;
  if current_user in ('anon', 'authenticated') and not public.is_staff() then
    new.attributes := new.attributes - '_checks';
    if checks is not null then
      new.attributes := new.attributes || jsonb_build_object('_checks', checks);
    end if;
  end if;

  for k, v in select * from jsonb_each(new.attributes) loop
    continue when k = '_checks';

    select a.* into attr
    from public.category_attributes a
    where a.category_id = new.category_id
      and a.key = k
      and (a.subcategory_keys is null or sub_key = any (a.subcategory_keys));
    if not found then
      raise exception 'INVALID_ATTRIBUTE' using detail = format('unknown attribute %s', k);
    end if;

    if attr.type = 'text' then
      if jsonb_typeof(v) <> 'string'
         or char_length(v #>> '{}') > coalesce(attr.max_length, 120) then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s must be text', k);
      end if;
    elsif attr.type in ('integer', 'year') then
      if jsonb_typeof(v) <> 'number' or (v #>> '{}')::numeric <> trunc((v #>> '{}')::numeric) then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s must be an integer', k);
      end if;
      if (attr.min_value is not null and (v #>> '{}')::numeric < attr.min_value)
         or (attr.max_value is not null and (v #>> '{}')::numeric > attr.max_value)
         or (attr.type = 'year' and ((v #>> '{}')::int < 1950
             or (v #>> '{}')::int > extract(year from now())::int + 1)) then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s out of range', k);
      end if;
    elsif attr.type = 'boolean' then
      if jsonb_typeof(v) <> 'boolean' then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s must be boolean', k);
      end if;
    elsif attr.type = 'enum' then
      allowed := (select jsonb_agg(o -> 'value') from jsonb_array_elements(attr.options) o);
      if jsonb_typeof(v) <> 'string' or not (allowed @> jsonb_build_array(v)) then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s has an invalid option', k);
      end if;
    elsif attr.type = 'multi_enum' then
      allowed := (select jsonb_agg(o -> 'value') from jsonb_array_elements(attr.options) o);
      if jsonb_typeof(v) <> 'array' or jsonb_array_length(v) = 0 then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s must be a list', k);
      end if;
      for item in select * from jsonb_array_elements(v) loop
        if not (allowed @> jsonb_build_array(item)) then
          raise exception 'INVALID_ATTRIBUTE' using detail = format('%s has an invalid option', k);
        end if;
      end loop;
      if (select count(distinct e) from jsonb_array_elements(v) e) <> jsonb_array_length(v) then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s has duplicates', k);
      end if;
    end if;
  end loop;

  -- Required attributes must be present before review / publication.
  if new.status in ('pending', 'published') then
    for attr in
      select a.key from public.category_attributes a
      where a.category_id = new.category_id
        and a.required
        and (a.subcategory_keys is null or sub_key = any (a.subcategory_keys))
    loop
      if not new.attributes ? attr.key then
        raise exception 'INVALID_ATTRIBUTE' using detail = format('%s is required', attr.key);
      end if;
    end loop;
  end if;

  return new;
end
$$;

create trigger listings_validate before insert or update on public.listings
  for each row execute function public.listings_validate();

-- Owner-side rules (staff and server functions are exempt):
--  * inserts always start as draft/pending with no moderation/featuring data;
--  * owners can never publish, reject or expire, nor touch featured_until,
--    views_count, publication dates or the reject reason;
--  * editing content of a published ad sends it back to review, except a
--    price/negotiable change (so price-drop alerts keep working);
--  * creation is rate-limited per day.
-- SECURITY INVOKER on purpose: `current_user` is `authenticated`/`anon` for
-- direct API writes and the function owner inside trusted RPCs.
create or replace function public.listings_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  daily_limit integer;
  created_today integer;
begin
  if current_user not in ('anon', 'authenticated') or public.is_staff() then
    if tg_op = 'UPDATE' and new.status = 'sold' and old.status <> 'sold' then
      new.sold_at := now();
    end if;
    return new;
  end if;

  if public.is_banned(auth.uid()) then
    raise exception 'ACCOUNT_BANNED';
  end if;

  if tg_op = 'INSERT' then
    if new.status not in ('draft', 'pending') then
      raise exception 'FORBIDDEN' using detail = 'new listings start as draft or pending';
    end if;
    new.views_count := 0;
    new.featured_until := null;
    new.featured_package_id := null;
    new.published_at := null;
    new.expires_at := null;
    new.sold_at := null;
    new.reject_reason := null;

    daily_limit := public.setting_bigint('listing_daily_hard_limit', 30);
    select count(*) into created_today
    from public.listings
    where user_id = new.user_id and created_at > now() - interval '24 hours';
    if created_today >= daily_limit then
      raise exception 'RATE_LIMITED' using detail = 'too many listings today';
    end if;
    return new;
  end if;

  -- UPDATE by the owner
  if new.user_id is distinct from old.user_id
     or new.views_count is distinct from old.views_count
     or new.featured_until is distinct from old.featured_until
     or new.featured_package_id is distinct from old.featured_package_id
     or new.published_at is distinct from old.published_at
     or new.expires_at is distinct from old.expires_at
     or new.sold_at is distinct from old.sold_at
     or new.reject_reason is distinct from old.reject_reason
     or new.created_at is distinct from old.created_at then
    raise exception 'FORBIDDEN' using detail = 'protected listing field';
  end if;

  if new.status is distinct from old.status then
    if not (
      (old.status = 'draft' and new.status in ('pending', 'deleted')) or
      (old.status = 'pending' and new.status in ('draft', 'deleted')) or
      (old.status = 'rejected' and new.status in ('pending', 'deleted')) or
      (old.status = 'published' and new.status in ('sold', 'deleted')) or
      (old.status = 'expired' and new.status in ('sold', 'deleted')) or
      (old.status = 'sold' and new.status = 'deleted')
    ) then
      raise exception 'FORBIDDEN' using detail = format('cannot move listing from %s to %s', old.status, new.status);
    end if;
    if new.status = 'sold' then
      new.sold_at := now();
    end if;
    if old.status = 'rejected' then
      new.reject_reason := null;
    end if;
  end if;

  if old.status = 'published' and new.status = 'published' and (
       new.title is distinct from old.title
    or new.description is distinct from old.description
    or new.category_id is distinct from old.category_id
    or new.subcategory_id is distinct from old.subcategory_id
    or new.attributes - '_checks' is distinct from old.attributes - '_checks'
    or new.locality_id is distinct from old.locality_id
    or new.neighborhood is distinct from old.neighborhood
    or new.price_mode is distinct from old.price_mode
    or new.price_unit is distinct from old.price_unit
  ) then
    new.status := 'pending';
  end if;

  return new;
end
$$;

create trigger listings_guard before insert or update on public.listings
  for each row execute function public.listings_guard();

-- Images (1–10 per listing; first by sort_order is the cover).
create table public.listing_images (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings (id) on delete cascade,
  storage_path text not null,
  sort_order smallint not null check (sort_order between 0 and 9),
  width integer check (width is null or width between 1 and 4096),
  height integer check (height is null or height between 1 and 4096),
  created_at timestamptz not null default now(),
  unique (listing_id, sort_order) deferrable initially deferred
);
create index listing_images_listing_idx on public.listing_images (listing_id, sort_order);

create or replace function public.listing_images_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  owner_id uuid;
begin
  select l.user_id into owner_id from public.listings l where l.id = new.listing_id;
  -- Images must live under the owner's folder: {user_id}/{listing_id}/…
  if new.storage_path not like owner_id::text || '/' || new.listing_id::text || '/%' then
    raise exception 'INVALID_IMAGE_PATH';
  end if;
  if tg_op = 'INSERT' and (select count(*) from public.listing_images where listing_id = new.listing_id) >= 10 then
    raise exception 'TOO_MANY_IMAGES';
  end if;
  return new;
end
$$;

create trigger listing_images_guard before insert or update on public.listing_images
  for each row execute function public.listing_images_guard();

-- Favourites. price_at_save is captured server-side for «نزل السعر».
create table public.favorites (
  user_id uuid not null references public.profiles (id) on delete cascade,
  listing_id uuid not null references public.listings (id) on delete cascade,
  price_at_save bigint,
  created_at timestamptz not null default now(),
  primary key (user_id, listing_id)
);
create index favorites_listing_idx on public.favorites (listing_id);

create or replace function public.favorites_capture_price()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  select l.price into new.price_at_save from public.listings l where l.id = new.listing_id;
  return new;
end
$$;

create trigger favorites_capture_price before insert on public.favorites
  for each row execute function public.favorites_capture_price();

-- Saved searches («نبّهني بالجديد»).
create table public.saved_searches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  query text check (query is null or char_length(query) <= 100),
  category_id uuid references public.categories (id) on delete cascade,
  subcategory_id uuid references public.subcategories (id) on delete cascade,
  locality_id uuid references public.localities (id) on delete cascade,
  filters jsonb not null default '{}'::jsonb check (jsonb_typeof(filters) = 'object'),
  notify boolean not null default true,
  last_notified_at timestamptz,
  created_at timestamptz not null default now(),
  check (query is not null or category_id is not null)
);
create index saved_searches_user_idx on public.saved_searches (user_id, created_at desc);
create index saved_searches_notify_idx on public.saved_searches (category_id, locality_id) where notify;

create or replace function public.saved_searches_limit()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select count(*) from public.saved_searches where user_id = new.user_id) >= 20 then
    raise exception 'RATE_LIMITED' using detail = 'max 20 saved searches';
  end if;
  return new;
end
$$;

create trigger saved_searches_limit before insert on public.saved_searches
  for each row execute function public.saved_searches_limit();

-- One counted view per user/device per listing per 24 h.
create table public.listing_views (
  listing_id uuid not null references public.listings (id) on delete cascade,
  viewer_key text not null check (char_length(viewer_key) between 8 and 128),
  viewed_at timestamptz not null default now(),
  primary key (listing_id, viewer_key)
);

-- Called from the details screen. Signed-in users are keyed by user id,
-- guests by the device id the app generates. Returns the new count.
create or replace function public.record_listing_view(p_listing_id uuid, p_device_id text default null)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  key text := coalesce(auth.uid()::text, 'd:' || p_device_id);
  counted boolean := false;
  result integer;
begin
  if key is null or char_length(key) < 8 then
    raise exception 'INVALID_VIEWER';
  end if;
  if not exists (
    select 1 from public.listings
    where id = p_listing_id and status = 'published' and user_id is distinct from auth.uid()
  ) then
    select views_count into result from public.listings where id = p_listing_id;
    return coalesce(result, 0);
  end if;

  insert into public.listing_views as v (listing_id, viewer_key)
  values (p_listing_id, key)
  on conflict (listing_id, viewer_key) do update
    set viewed_at = now()
    where v.viewed_at < now() - interval '24 hours'
  returning true into counted;

  if counted then
    update public.listings set views_count = views_count + 1
    where id = p_listing_id
    returning views_count into result;
  else
    select views_count into result from public.listings where id = p_listing_id;
  end if;
  return result;
end
$$;
