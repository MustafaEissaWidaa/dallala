-- Dallala — catalog (categories, subcategories, attributes, quick filters)
-- and admin-managed configuration (settings, payment accounts, packages).

-- Categories ------------------------------------------------------------------
-- One row per top-level category. Visual fields drive the generic
-- CategoryScreen (screens 46–55) so no category needs its own screen.
create table public.categories (
  id uuid primary key default gen_random_uuid(),
  -- Stable key, also the app's icon/visual key (cars, livestock, …).
  key text not null unique check (key ~ '^[a-z][a-z_]*$'),
  name_ar text not null check (char_length(name_ar) between 1 and 40),
  -- Landing-page title when it differs from name_ar («سوق المواشي»).
  title_ar text,
  -- Subtitle on the all-categories banner (screen 33).
  banner_subtitle_ar text,
  show_as_banner boolean not null default false,
  icon_key text not null,
  -- 'accent' = terracotta-soft tile; 'neutral' = sand-deep tile («أخرى»).
  tile_variant text not null default 'accent' check (tile_variant in ('accent', 'neutral')),
  band_color text not null check (band_color ~ '^#[0-9A-F]{6}$'),
  dune_color text not null check (dune_color ~ '^#[0-9A-F]{6}$'),
  card_variant text not null default 'standard' check (card_variant in ('standard', 'job', 'service')),
  search_hint_ar text not null,
  section_title_ar text not null,
  -- Units a listing price may be quoted in («للرأس», «شهر», «قنطار»…).
  price_units text[] not null default '{}',
  -- Price text when a listing has no fixed price («حسب المشوار»).
  price_on_request_label_ar text,
  -- «ما لقيت قسم مناسب؟ اقترح قسم جديد» link (screen 55).
  allow_suggest_category boolean not null default false,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger categories_touch before update on public.categories
  for each row execute function public.touch_updated_at();

create table public.subcategories (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete cascade,
  key text not null check (key ~ '^[a-z][a-z_]*$'),
  name_ar text not null check (char_length(name_ar) between 1 and 40),
  -- Overrides categories.price_units when set (e.g. solar panels «اللوح»).
  price_units text[],
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (category_id, key),
  unique (category_id, name_ar)
);
create index subcategories_category_idx on public.subcategories (category_id, sort_order);

-- Attribute definitions. Listing values live in listings.attributes (jsonb)
-- and are validated against these rows by a trigger.
create table public.category_attributes (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete cascade,
  -- NULL = applies to every subcategory of the category.
  subcategory_keys text[],
  key text not null check (key ~ '^[a-z][a-z0-9_]*$'),
  label_ar text not null,
  type text not null check (type in ('text', 'integer', 'boolean', 'enum', 'multi_enum', 'year')),
  unit_ar text,
  -- enum / multi_enum: [{"value": "...", "label_ar": "...", ...}]
  options jsonb check (options is null or jsonb_typeof(options) = 'array'),
  min_value numeric,
  max_value numeric,
  max_length integer check (max_length is null or max_length between 1 and 500),
  required boolean not null default false,
  filterable boolean not null default false,
  -- Shown as a chip on listing cards.
  show_as_chip boolean not null default false,
  -- Chip text for boolean attributes when true («مطعّمة», «رخصة سارية»).
  true_label_ar text,
  -- Rendered as a segmented toggle on the landing page (rent / sale).
  is_segment boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  unique (category_id, key),
  check ((type in ('enum', 'multi_enum')) = (options is not null)),
  check (not is_segment or type = 'enum'),
  check (type <> 'boolean' or not show_as_chip or true_label_ar is not null)
);
create index category_attributes_category_idx on public.category_attributes (category_id, sort_order);

-- Quick-filter chips under the subcategory grid, per category.
create table public.category_quick_filters (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete cascade,
  kind text not null check (kind in ('attribute', 'price', 'locality', 'neighborhood', 'verified')),
  attribute_key text,
  label_ar text not null,
  control text not null check (control in ('dropdown', 'toggle', 'segment', 'range')),
  sort_order integer not null default 0,
  check ((kind = 'attribute') = (attribute_key is not null))
);
create index category_quick_filters_category_idx on public.category_quick_filters (category_id, sort_order);

-- Quick filters that point at an attribute must point at a real one.
create or replace function public.category_quick_filters_check()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.kind = 'attribute' and not exists (
    select 1 from public.category_attributes a
    where a.category_id = new.category_id and a.key = new.attribute_key
  ) then
    raise exception 'UNKNOWN_ATTRIBUTE' using detail = new.attribute_key;
  end if;
  return new;
end
$$;

create trigger category_quick_filters_check before insert or update on public.category_quick_filters
  for each row execute function public.category_quick_filters_check();

-- App settings (top-up limits, support contacts, banned words, legal text…)
create table public.app_settings (
  key text primary key check (key ~ '^[a-z][a-z0-9_]*$'),
  value jsonb not null,
  -- Readable by the app (anon). Private keys (banned words…) are staff-only.
  is_public boolean not null default false,
  description text,
  updated_at timestamptz not null default now(),
  updated_by uuid references public.profiles (id) on delete set null
);

create trigger app_settings_touch before update on public.app_settings
  for each row execute function public.touch_updated_at();

-- Typed accessors used by server-side functions.
create or replace function public.setting_bigint(setting_key text, fallback bigint)
returns bigint
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select (value #>> '{}')::bigint from public.app_settings where key = setting_key), fallback)
$$;

create or replace function public.setting_text(setting_key text, fallback text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select value #>> '{}' from public.app_settings where key = setting_key), fallback)
$$;

create or replace function public.setting_bool(setting_key text, fallback boolean)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select (value #>> '{}')::boolean from public.app_settings where key = setting_key), fallback)
$$;

-- Company accounts for manual top-ups, one per method (screen 24).
create table public.payment_accounts (
  id uuid primary key default gen_random_uuid(),
  method text not null unique check (method in ('bankak', 'fawry', 'ocash', 'phone_credit')),
  display_name_ar text not null,
  account_number text not null,
  account_holder text not null,
  instructions_ar text,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  updated_at timestamptz not null default now()
);

create trigger payment_accounts_touch before update on public.payment_accounts
  for each row execute function public.touch_updated_at();

-- Promotion packages (screen 21).
create table public.promotion_packages (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  description_ar text,
  price bigint not null check (price > 0),
  duration_days integer not null check (duration_days between 1 and 365),
  placement text not null check (placement in ('category_top', 'top_and_home')),
  max_listings integer not null default 1 check (max_listings between 1 and 100),
  is_popular boolean not null default false,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger promotion_packages_touch before update on public.promotion_packages
  for each row execute function public.touch_updated_at();
