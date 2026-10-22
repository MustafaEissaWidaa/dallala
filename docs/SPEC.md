# Review & Complete — Dallala (دلّالة)

You are a senior engineer (Flutter, Supabase/Postgres, Next.js). I have **already started** building Dallala, a classifieds app for North Kordofan, Sudan. Your job is to **review what exists, fix it, and finish the product completely** — mobile app, Supabase backend and admin dashboard.

## Sources of truth (read all of them before touching code)

| File | What it is |
|---|---|
| `docs/SPEC.md` | The full build specification: product, revenue model, stack, tokens, screens, database, RPCs, RLS, business rules, admin dashboard, phases, code standards. |
| `docs/design/screens/01–32` | Original screen designs (onboarding → offline). |
| `docs/design/screens/33–55` | New and updated designs: updated all-categories screen, the full settings flow, and one landing page per category (details in "Additions since the spec" below). |
| `docs/design/assets/` | Logo, icons, backgrounds, app-icon layers, splash. |
| The existing code in this repo | What I've built so far. |

**Conflicts:** on business, payment and security rules → `SPEC.md` wins. On visuals and copy → the screenshot wins. If existing code disagrees with either, don't silently change it — list it in the audit.

---

## Step 1 — Audit (no code changes yet)

1. Read the whole repo, `SPEC.md` and every screenshot.
2. Run everything and record the real output:
   - `flutter pub get && flutter analyze && flutter test`
   - `supabase start && supabase db reset && supabase test db`
   - in the dashboard: `npm ci && npm run lint && npm run build`
3. Write **`docs/AUDIT.md`** containing:
   - **Status table:** every phase and feature from `SPEC.md` section 12 plus the additions below → `done` / `partial` / `missing` / `wrong`, with the file paths that implement it.
   - **Rule violations**, especially:
     - any payment path other than the manual wallet top-up;
     - wallets or balances writable from the client;
     - service-role key reachable from the app;
     - tables without RLS, or RLS that leaks another user's phone, wallet, chats or receipts;
     - hard-coded strings, colours or sizes in widgets;
     - `left`/`right` instead of directional APIs;
     - Latin digits inside the app.
   - **Bugs and risks:** crashes, analyzer warnings, failing tests, missing error states, anything that breaks on a slow 3G connection.
   - **Visual mismatches** against the screenshots (screen number + what differs).
   - **A prioritised fix list:**
     - **P0** — security and money;
     - **P1** — broken or crashing;
     - **P2** — missing features;
     - **P3** — visual polish.
4. **Stop.** Show me a short summary of `AUDIT.md` and wait for my approval.

---

## Step 2 — Fix P0 and P1

Fix every P0 and P1 item. Add a test for each money or security fix. Re-run all the checks from step 1 and show the output. **Stop and wait.**

---

## Step 3 — Complete the product

Continue through the phases in `SPEC.md` section 12, in order, skipping what the audit marked `done`. Include the additions below in the phase where they belong.

After **each** phase:
- all checks pass (`flutter analyze` clean, all tests green, dashboard builds);
- prove the phase's acceptance criteria — test output, or steps I can repeat on a device;
- list what changed;
- **stop and wait for my approval.**

---

## Additions since the spec

### A. Settings flow (screens 34–45)

`Settings` is reached from the gear icon on `Profile`. Every row opens the screen shown in the designs:

| Screen | Behaviour |
|---|---|
| 34 Settings | Profile card (→ 35); Account: phone & verification (→ 36), privacy & security (→ 37), my balance (→ Wallet); Preferences: default locality (→ 38), notifications (→ 39), appearance (→ 40 sheet), data saver toggle; Help: safety tips (→ 41), contact us (→ 42), terms & privacy (→ 43); sign out (→ 44 sheet); version number. |
| 35 Personal details | Avatar upload, name, locality, optional bio (max 150 chars), verified phone shown read-only with "change". |
| 36 Phone & verification | Verified status and date; changing the number re-runs the OTP flow and keeps ads, balance and chats. |
| 37 Privacy & security | Toggles: show my phone on ads, WhatsApp button on ads (both off → buyers can only message in-app). Blocked accounts list (blocked users can't message you or see your number). "Sign out of all devices" = global sign-out. Delete account (→ 45). |
| 38 Default locality | Radio list of the localities from the database + "كل شمال كردفان" + "detect my location". It drives what Home shows first. |
| 39 Notifications | Master switch + per-type switches: new messages, ad approved/rejected, ad expiring, featuring ended, saved-search matches, price drops in favourites, top-up requests, tips & news. Security and account alerts are always sent. Store per user in the database and respect them in the code that sends notifications. |
| 40 Appearance | Light / dark / system, stored locally. Dark mode uses the dark tokens in `SPEC.md`. |
| 41 Safety tips | Static content, buyer/seller tabs; "report" → 42. |
| 42 Contact us | WhatsApp, call and email support (numbers and email come from config, not hard-coded) + a form: issue type, optional transaction reference, message, optional image. Saved as a support ticket visible in the admin dashboard. |
| 43 Terms & privacy | Two tabs; content loaded from the database or a remote config so it can be edited without an app release. Show "[النص الكامل]" placeholders until I supply the legal text. |
| 44 Sign-out sheet | Confirm sheet with sign out / cancel. |
| 45 Delete account | Shows what will be lost (ads, chats, favourites, remaining balance), an optional reason, then OTP re-verification, then an Edge Function that deletes or anonymises the user's data and the auth user. **Ask me before implementing what happens to a remaining balance** — the design assumes it is forfeited. |

The admin dashboard needs a **Support tickets** page (list, filter by type, reply/close) and must show **deletion requests** in the audit log.

### B. Category landing pages (screens 46–55)

Each tile on the all-categories screen (33) opens that category's landing page. **Build ONE generic `CategoryScreen` driven by data, not 10 copies.** Per category it needs:

- **Band:** colour, dune colour, faint large icon, title, live ad count, and a search field scoped to the category.
- **Subcategories:** a 3-column grid with live counts per subcategory.
- **Quick filters:** chips specific to the category, defined in the database (for example cars: make, year, transmission, price; livestock: wholesale, age, breed, price per head).
- **Card variant:**
  - `standard` — image, price, title, attribute chips, location, time;
  - `job` — screen 53: icon, title, employer, tags, salary in green;
  - `service` — screen 54: provider initial, verified tag, "call" button.
- **Segmented toggles where shown:**
  - real estate: rent / sale (screen 48);
  - jobs: hiring / seeking work (screen 53).
- **"Suggest a new category"** link on the "other" page (screen 55), which opens contact-us.

Model this in the database:
- a `categories` table and a `subcategories` table, with the colours, icon key, card variant and sort order;
- a `category_attributes` table (key, Arabic label, type, unit, options, `filterable`, `show_as_chip`);
- listing attribute values stored as validated `jsonb`.

The post-ad flow, the filters screen, the attribute chips on cards and the listing details must all read from these tables. Counts come from a view or materialised view, refreshed cheaply. Seed every category, subcategory and attribute exactly as shown in screens 46–55.

---

## Rules of engagement

- **Don't rewrite working code** just to restyle it. Prefer small, reviewable commits with clear messages, one per fix or feature.
- **Never delete my files** or the existing splash animation (`DallalaSplash`). Keep it as it is.
- **Ask before:**
  - changing a business or payment rule;
  - adding a dependency that isn't in `SPEC.md`;
  - changing the database schema in a way that drops data.
- **Copy:** all copy comes from the designs verbatim, through `app_ar.arb`.
- **Config, not code:** company account details (`[رقم حساب الشركة]`, `[اسم صاحب الحساب]`), support numbers and email live in config or the database, never in code.
- **Be honest:** if something can't be verified here (real SMS, push, a physical device), say so plainly and give me exact steps to verify it myself. Never report something as working without running it.

## Definition of done

- Every screen 01–55 is implemented, navigable, and matches its screenshot in light **and** dark mode.
- Every phase's acceptance criteria in `SPEC.md` is proven.
- `flutter analyze` is clean; Flutter, pgTAP and dashboard tests all pass; the dashboard builds.
- A release APK installs and runs on a real Android phone.
- `README.md` explains setup, environment variables, SMS provider, Firebase push, deployment, and how an admin approves a top-up.

**Start with Step 1 now.**
