# دلّالة — Dallala

Classifieds marketplace for North Kordofan, Sudan — «سوق كردفان في جيبك».

| Part | Path | Stack |
|---|---|---|
| Mobile app (Android + iOS) | `/` (Flutter project root) | Flutter, Riverpod, go_router |
| Backend | `supabase/` | Supabase (Postgres, Auth, Storage, Realtime, Edge Functions) |
| Admin dashboard | `admin/` | Next.js (App Router), TypeScript, Tailwind, shadcn/ui |

> Build status: **Phase 1 — Foundation**. Later sections (SMS, push, deployment)
> are filled in as their phases land.

## Mobile app

### Requirements
- Flutter stable (tested with 3.44), Dart 3.12+
- Android SDK (min API 24 / Android 7.0), Xcode for iOS

### Run
```bash
cp .env.example .env          # public values only (anon key, never service-role)
flutter pub get
dart run build_runner build -d   # Riverpod codegen (*.g.dart)
flutter run --dart-define-from-file=.env
```
Localised strings are generated from `lib/core/l10n/app_ar.arb` automatically
on `flutter pub get` / `flutter run` (or run `flutter gen-l10n`).

### Check
```bash
flutter analyze
flutter test
```
The tests include guards for the code standards (no hard-coded colours, no
left/right layout, no Arabic copy outside `app_ar.arb`) and a WCAG 4.5:1
contrast check for every token text pair in both themes.

### Component gallery
Open the app → (after onboarding stub) «معرض المكوّنات», or navigate to
`/gallery`. It shows every shared widget; switch فاتح / داكن / حسب الجهاز at
the top.

### Release builds
```bash
flutter build apk --release --split-per-abi --dart-define-from-file=.env
flutter build appbundle --release --dart-define-from-file=.env
flutter build ipa --release --dart-define-from-file=.env
```

### Regenerating icons and native splash
```bash
dart run flutter_launcher_icons      # from assets/app_icon/*
dart run flutter_native_splash:create
```
`assets/app_icon/app-icon-square.png` is the square, non-rounded icon (derived
from `assets/02-App-Icon/dallala-app-icon.svg`); the Android adaptive icon uses
`app-icon-foreground.png` on `#B8431A`.

### Project layout
```
lib/
  core/      config, l10n, router, storage, theme, utils, widgets
  features/  splash, onboarding, home, gallery, … (feature-first;
             data / domain / presentation inside each feature)
assets/      fonts (bundled), logo, icons (SVG), backgrounds, splash
legacy/      archived GetX prototype — reference only, not compiled
```

## Fonts
Readex Pro (headings, prices) and IBM Plex Sans Arabic (body) are bundled in
`assets/fonts` under the SIL Open Font License (see `assets/fonts/OFL-*.txt`).
Readex Pro is published only as a variable font; the static SemiBold (600) and
Bold (700) files were instanced from it with `fonttools varLib.instancer`.

## Backend (Supabase)
Initialised with the Supabase CLI (`supabase/config.toml`). Migrations, RLS,
RPCs, seed data and SQL tests arrive in Phase 2.
```bash
npx supabase start     # needs Docker
npx supabase db reset  # applies supabase/migrations + seed.sql
```
Secrets go in `supabase/.env` (template: `supabase/.env.example`).

## Admin dashboard
```bash
cd admin
cp .env.example .env.local
npm install
npm run dev     # http://localhost:3000
npm run lint && npm run build
```
Arabic RTL, brand tokens as CSS variables in `src/app/globals.css` (shadcn/ui
variables are mapped onto them), bundled fonts via `next/font/local`, Latin
digits and the `Africa/Khartoum` timezone (`src/lib/format.ts`).
# dallala
# dallala
# dallala
# dallala_
# dallala
