-- Dallala — extensions and shared helpers.

create extension if not exists pg_trgm with schema extensions;
create extension if not exists pgcrypto with schema extensions;

-- Arabic search normalisation (spec §6 "Search"), used at index AND query
-- time: أ/إ/آ/ٱ → ا, ة → ه, ى → ي, ؤ → و, ئ → ي, strip tashkeel and tatweel,
-- Eastern Arabic digits → Latin, collapse whitespace, lower-case Latin.
create or replace function public.normalize_ar(input text)
returns text
language sql
immutable
parallel safe
set search_path = ''
as $$
  select nullif(
    btrim(
      regexp_replace(
        lower(
          translate(
            regexp_replace(coalesce(input, ''), '[ً-ٰٟـ]', '', 'g'),
            'أإآٱةىؤئ٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹',
            'ااااهيوي01234567890123456789'
          )
        ),
        '\s+', ' ', 'g'
      )
    ),
    ''
  )
$$;

comment on function public.normalize_ar(text) is
  'Normalises Arabic text for search: alef forms→ا, ة→ه, ى→ي, removes diacritics/tatweel.';

-- Generic updated_at trigger.
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end
$$;
