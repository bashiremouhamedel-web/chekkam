# Chekkam — Build Documentation

This tracks what has actually been built, how the codebases fit together, how to run
them, and what's next — kept in sync as the project progresses. The product vision, brand
rules, and full technical spec live in the companion documents in this folder:

- `Chekkam_Project_Overview.md` — what Chekkam is, why it exists, competition context
- `Chekkam_Brand_Guide.md` — colors, type, voice, component rules
- `Chekkam_Software_Requirements_Specification.md` (SRS) — the full Phase 1 functional spec.
  Section/FR numbers referenced below (e.g. "FR-043", "§10") point back into that document.
- `Chekkam_Phase2_Build_Spec.md` — the Phase 2 delta spec (channels, key issuance, the
  report→review→publish loop). "P2-xx" references below point into that document.

## 1. Three coordinated codebases, one system

Chekkam is genuinely three applications sharing one backend contract — not a split made for
convenience. This folder (`chekkam/`) is a Flutter app; the SRS also calls for a Next.js web
dashboard and a shared Node/Supabase backend (SRS §2.1, §3.2); Phase 2 added a browser
extension. Since Flutter can't run a Node.js server, and secrets like the OpenAI key, the
Supabase service-role key, and each institution's private document-signing key must never
ship inside a mobile app binary or a browser extension, the backend lives in its own folder:

```
myApp/
├── chekkam/            ← this folder: the Flutter citizen app
├── chekkam-backend/    ← Next.js API + analyst/institution web dashboard + Supabase schema
└── chekkam-extension/  ← Manifest V3 browser extension (load-unpacked for testing)
```

`chekkam-backend/README.md` has backend-specific setup instructions, and
`chekkam-extension/README.md` has load-unpacked install steps. This file focuses on the
overall picture, the Flutter app, and tracking Phase 1/2 status across all three.

## 2. What's implemented — Phase 1 (base system)

### Backend (`chekkam-backend/`)

| Area | Status | Notes |
|---|---|---|
| Database schema + RLS (SRS §5) | Done | `supabase/migrations/0001_init.sql` — all 16 tables, extensions, and minimum RLS policies |
| Document signing/verification (§10, FR-040–048) | Done | SHA-256 + ECDSA P-256, QR generation; now factored into `lib/documents/{sign-document,verify}.ts` (see §3 below) so every channel calls the same engine |
| AI risk analysis (§8, FR-020–025) | Done | OpenAI call with an 8s timeout; deterministic rule-based fallback on any failure/missing key |
| Campaign fingerprinting/matching (§9, FR-030–033) | Done | Jaccard text similarity + exact URL/phone matching, weighted per spec |
| Reports API (§6.1, FR-010–013) | Done | Synchronous analysis + campaign matching on submit; now filterable by channel too (P2-40) |
| Institutions + members (§6.3, FR-080) | Done | Includes one-time signing-key generation on institution creation |
| Push notifications (FR-050–052) | Done, needs Firebase project | Report-status and safety-alert pushes; no-ops cleanly if `FIREBASE_SERVICE_ACCOUNT_JSON` isn't set |
| Safety alerts (§6.6, FR-070–074) | Functional, dashboard added in Phase 2 | Proximity targeting is still approximate (see §4 below) |
| Partner API (§6.8, FR-060–062) | Done | `X-Api-Key` auth, rate limiting, usage logging; key issuance closed in Phase 2 (P2-01) |
| Web dashboard UI | Functional | Login, institution officer document-signing form, analyst review queue (now filterable + promote-to-alert), public verify page |

### Flutter app (`chekkam/`)

| Area | Status | Notes |
|---|---|---|
| Brand theme (`lib/app/theme.dart`) | Done | Colors, type scale, spacing/radius tokens transcribed from the Brand Guide |
| Config (`lib/app/config.dart`) | Done | Backend URL + Supabase credentials via `--dart-define`, all optional |
| Routing (`lib/app/router.dart`) | Done | go_router, feature-based screens |
| API client (`lib/services/api_client.dart`) | Done | Typed exceptions with user-safe messages; never a raw stack trace on screen |
| Document verification (FR-043–045) | Done | Scan (camera), manual ID/PIN entry, file/photo upload, and a shared result screen for Genuine/Tampered/Revoked/Not Found |
| Citizen reporting (FR-010–012) | Done | Text/link submission with the AI risk result shown, always labeled advisory |
| Public alerts (FR-090) | Done | Simple list view — renders newly published alerts (including ones promoted from Phase 2 channels) with no code change, since it reads the same public API |
| Permissions (§7) | Done | Every camera/location request goes through an in-app explanation sheet (`PermissionPrimerSheet`) before the OS prompt; camera denial degrades to manual entry rather than dead-ending |

## 3. What's implemented — Phase 2 (channels + operational loop)

Five deliverables per `Chekkam_Phase2_Build_Spec.md`, all sharing the Phase 1 engine
(`analyzeContent()`, `hashDocument`/`signHash`/`getInstitutionPrivateKey`, and the document
verify logic — now factored into `lib/documents/sign-document.ts` and `lib/documents/verify.ts`
specifically so bots and the web routes call the exact same code, not a second implementation).

| Area | Status | Notes |
|---|---|---|
| API key issuance (P2-01) | Done | `POST/GET /api/admin/api-keys` + revoke route; `scripts/issue-api-key.mjs` CLI fallback |
| Channel identity linking (P2-02) | Done | `POST /api/channel-identities` + `/verify`; a WhatsApp/Telegram identity must be `verified=true` with a non-null `institution_id` before it can sign — enforced in `lib/channels/identity.ts`, checked by both bots, no exceptions |
| Shared channel helpers (P2-03) | Done | `lib/channels/{router,replies,intent,media,send,identity}.ts` — one dispatcher, brand-voice EN/FR/Pidgin reply templates, intent parsing, WhatsApp/Telegram media download + server-side QR decode (`jsqr`+`jimp`), outbound send |
| Browser extension (P2-30–37) | Done | `chekkam-extension/` (Manifest V3, load-unpacked) + `POST /api/extension/check` (no API key, IP rate-limited, CORS for `chrome-extension://`) |
| Telegram bot (P2-20–27) | Done | `POST /api/webhooks/telegram`, secret-token validated, `/start`/`/sign`/`/report`/free-text all routed through the shared dispatcher |
| WhatsApp bot (P2-10–16) | Done | `POST /api/webhooks/whatsapp` extended from a silent stub into a full router with `X-Hub-Signature-256` validation and reply-back (text + QR image) |
| Report → review → promote → publish loop (P2-40–45) | Done | Dashboard report queue gained channel/risk/category/status filters; `POST /api/public-alerts/from-report` pre-fills a redacted draft; new `/dashboard/analyst/alerts` (edit+publish) and `/dashboard/analyst/safety-alerts` (approve) pages close the loop |
| Seed script + env docs (P2-50) | Done | `scripts/seed-demo.mjs` (idempotent), full `.env.example` covering Phase 1 + Phase 2 |

### Which env var activates which channel

All of these are optional — see `.env.example` for the full list with comments. Nothing
below is required to run the app; each channel simply stays inactive until its variables are set.

| Set this... | ...to activate |
|---|---|
| `OPENAI_API_KEY` | Real AI reasoning (otherwise the rule-based fallback answers) |
| `WHATSAPP_CLOUD_API_TOKEN` + `WHATSAPP_PHONE_NUMBER_ID` + `WHATSAPP_VERIFY_TOKEN` + `WHATSAPP_APP_SECRET` | The WhatsApp bot (check/verify/sign/report/help) |
| `TELEGRAM_BOT_TOKEN` + `TELEGRAM_WEBHOOK_SECRET` (then `npm run set-telegram-webhook`) | The Telegram bot |
| `UPSTASH_REDIS_REST_URL` + `UPSTASH_REDIS_REST_TOKEN` | Cross-instance rate limiting for the extension endpoint (otherwise an in-memory per-process limiter is used) |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Push notifications |
| `CHANNEL_ID_SALT` | Real privacy-grade hashing of phone numbers/chat IDs at rest (a dev-only fallback salt is used otherwise) |
| `DOCUMENT_SIGNING_KEY_<institution-uuid>` | That institution's ability to sign documents (any channel) |

### Known limitation carried into Phase 2

**Safety-alert proximity push is still approximate**, not a true radius query — see the
comment in `chekkam-backend/app/api/safety-alerts/[id]/approve/route.ts`. The schema
deliberately avoids storing exact device coordinates at rest (SRS §5.12), so real proximity
targeting needs an approximate-area tagging pipeline that doesn't exist yet. Phase 2 added the
moderation *dashboard* for safety alerts; the push-targeting precision itself is unchanged.

## 4. Running everything locally

**Backend** (`chekkam-backend/`): `npm install`, create a Supabase project, copy
`.env.example` to `.env.local`, run both migrations (`supabase/migrations/0001_init.sql` then
`0002_phase2.sql`), `npm run dev`. Then `npm run seed-demo` to stand up a demo institution,
logins, a verified channel identity, a sample published alert, and a partner API key —
re-runnable safely.

**Browser extension** (`chekkam-extension/`): `chrome://extensions` → Developer mode →
Load unpacked → select the folder. See its README for details.

**Telegram bot**: after setting `TELEGRAM_BOT_TOKEN`, run `npm run set-telegram-webhook`
(requires `APP_BASE_URL` to be a publicly reachable HTTPS URL — use a tunnel like ngrok for
local testing).

**WhatsApp bot**: configure the Cloud API test number and webhook in the Meta developer
dashboard, pointing at `<APP_BASE_URL>/api/webhooks/whatsapp`, matching
`WHATSAPP_VERIFY_TOKEN`. Use the 5 allow-listed test recipient numbers for the demo.

**Flutter app** (`chekkam/`):
```
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000 \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```
All three `--dart-define` flags are optional. With none set, the app still runs — document
verification and reporting work against whatever `API_BASE_URL` resolves to (default assumes
an Android emulator talking to a backend on your host machine at port 3000; use
`http://localhost:3000` for an iOS simulator, or your machine's LAN IP for a physical device).

## 5. Known limitations / deliberately deferred (Phase 1 items still open)

- **Mobile auth screens don't exist yet.** Citizen flows are anonymous by design (FR-005), so
  this doesn't block the core loop, but there's no sign-in UI in the Flutter app yet (the web
  dashboard has one, for analysts/institution officers). This also means officers can't yet
  sign documents from the Flutter app itself — only from the web dashboard or a chat bot.
- **Share-to-Chekkam (FR-014–016, SRS Build Priority 4) isn't wired up.** `share_plus` and a
  `receive_sharing_intent`-equivalent are the next Flutter feature to add.
- **Offline report queueing isn't implemented.** The SRS's non-functional requirement ("queue
  a submitted report locally and retry when connectivity returns") is real but not yet built;
  `connectivity_plus` is already a dependency for this.
- **OCR-assisted *fuzzy* document matching (FR-048)** beyond the server-side QR decode already
  used by the bots, and **cross-language campaign matching (FR-033)**, remain out of scope
  (Phase 2 spec §1.1 non-goals).
- **WhatsApp/Telegram outbound broadcast of public alerts** (as opposed to inbound
  checking/reporting) is out of scope for Phase 2 (spec §1.1 non-goal).
- **Chrome Web Store / Edge Add-ons store publishing** is out of scope — the extension ships
  load-unpacked for testing only (Phase 2 spec §1.1 non-goal).

## 6. Suggested next steps, in priority order

1. Mobile auth screens (sign-in/sign-up) so institution officers can also verify/sign their
   own institution's documents from the app, and citizens can opt into push notifications.
2. Share-to-Chekkam incoming intent handling (`receive_sharing_intent` or equivalent).
3. Offline report queueing on the mobile app.
4. Proximity-based push targeting for safety alerts (needs an approximate-area tagging
   pipeline compatible with the schema's "never exact coordinates at rest" constraint).
5. WhatsApp/Telegram outbound broadcast of newly published public alerts.
6. Chrome Web Store / Edge Add-ons store submission for the extension.

## 7. Design decisions worth knowing about

- **AI failures never block a result.** `analyzeContent()` always returns a usable risk
  result — real AI output or a deterministic rule-based fallback — never an error state
  (FR-025). The same is true for missing Firebase config on the push-sending path, and for
  missing WhatsApp/Telegram tokens (the bot just can't reply, but never crashes).
- **Every document-signing private key lives only in an environment variable**, named
  `DOCUMENT_SIGNING_KEY_<institution-uuid>`, never in the database (SRS §10.1, §14). The
  `POST /api/institutions` response and `seed-demo.mjs` both return a freshly generated
  private key exactly once.
- **Signing over chat is gated hard.** A WhatsApp/Telegram sender can only sign a document if
  their `channel_identities` row is `verified=true` AND has a non-null `institution_id` —
  checked in one place (`lib/channels/identity.ts`) that both bots call. Everyone else gets a
  clear refusal, never a silent failure or a bypass.
- **Every write that can affect the public record goes through human approval**: public
  alerts have a separate `publish` step (now with an explicit promote-then-edit-then-publish
  flow), safety alerts have an `approve` step, and AI report results always carry
  `needs_human_review: true` regardless of confidence or which channel they came from.
- **Phone numbers and chat IDs are never stored raw** in `reports.reporter_external_hash` or
  `channel_messages.external_id_hash` — both are salted with `CHANNEL_ID_SALT`. The one
  intentional exception is `channel_identities.external_id`, which must stay in plain form so
  an inbound message's sender can be looked up against it to authorize signing.
