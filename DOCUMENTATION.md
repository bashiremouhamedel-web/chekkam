# Chekkam — Build Documentation

This tracks what has actually been built, how the two codebases fit together, how to run
them, and what's next — kept in sync as the project progresses. The product vision, brand
rules, and full technical spec live in the three companion documents in this folder:

- `Chekkam_Project_Overview.md` — what Chekkam is, why it exists, competition context
- `Chekkam_Brand_Guide.md` — colors, type, voice, component rules
- `Chekkam_Software_Requirements_Specification.md` (SRS) — the full functional spec this
  build implements against. Section/FR numbers referenced below (e.g. "FR-043", "§10") point
  back into that document.

## 1. Two coordinated codebases, one system

Chekkam is genuinely two applications sharing one backend contract — not a split made for
convenience. This folder (`chekkam/`) is a Flutter app; the SRS also calls for a Next.js web
dashboard and a shared Node/Supabase backend (SRS §2.1, §3.2). Since Flutter can't run a
Node.js server, and secrets like the OpenAI key, the Supabase service-role key, and each
institution's private document-signing key must never ship inside a mobile app binary, that
part lives in a sibling folder:

```
myApp/
├── chekkam/            ← this folder: the Flutter citizen app
└── chekkam-backend/    ← Next.js API + analyst/institution web dashboard + Supabase schema
```

`chekkam-backend/README.md` has backend-specific setup instructions. This file focuses on
the overall picture and the Flutter app.

## 2. What's implemented

### Backend (`chekkam-backend/`)

| Area | Status | Notes |
|---|---|---|
| Database schema + RLS (SRS §5) | Done | `supabase/migrations/0001_init.sql` — all 16 tables, extensions, and minimum RLS policies |
| Document signing/verification (§10, FR-040–048) | Done | SHA-256 + ECDSA P-256, QR generation, sign/verify/verify-upload/revoke routes |
| AI risk analysis (§8, FR-020–025) | Done | OpenAI call with an 8s timeout; deterministic rule-based fallback on any failure/missing key |
| Campaign fingerprinting/matching (§9, FR-030–033) | Done | Jaccard text similarity + exact URL/phone matching, weighted per spec |
| Reports API (§6.1, FR-010–013) | Done | Synchronous analysis + campaign matching on submit |
| Institutions + members (§6.3, FR-080) | Done | Includes one-time signing-key generation on institution creation |
| Push notifications (FR-050–052) | Done, needs Firebase project | Report-status and safety-alert pushes; no-ops cleanly if `FIREBASE_SERVICE_ACCOUNT_JSON` isn't set |
| Safety alerts (§6.6, FR-070–074) | Schema-complete, functional | Proximity targeting is approximate (see §4 below — known limitation) |
| Partner API (§6.8, FR-060–062) | Done | `X-Api-Key` auth, rate limiting, usage logging |
| WhatsApp webhook (§6.6) | Functional stub | Creates real `reports` rows from incoming text; doesn't reply back yet |
| Web dashboard UI | Minimal but functional | Login, institution officer document-signing form, analyst review queue, public verify page |

### Flutter app (`chekkam/`)

| Area | Status | Notes |
|---|---|---|
| Brand theme (`lib/app/theme.dart`) | Done | Colors, type scale, spacing/radius tokens transcribed from the Brand Guide |
| Config (`lib/app/config.dart`) | Done | Backend URL + Supabase credentials via `--dart-define`, all optional |
| Routing (`lib/app/router.dart`) | Done | go_router, feature-based screens |
| API client (`lib/services/api_client.dart`) | Done | Typed exceptions with user-safe messages; never a raw stack trace on screen |
| Document verification (FR-043–045) | Done | Scan (camera), manual ID/PIN entry, file/photo upload, and a shared result screen for Genuine/Tampered/Revoked/Not Found |
| Citizen reporting (FR-010–012) | Done | Text/link submission with the AI risk result shown, always labeled advisory |
| Public alerts (FR-090) | Done | Simple list view |
| Permissions (§7) | Done | Every camera/location request goes through an in-app explanation sheet (`PermissionPrimerSheet`) before the OS prompt; camera denial degrades to manual entry rather than dead-ending |

## 3. Running both projects locally

**Backend** (`chekkam-backend/`): see its README. Short version — `npm install`, create a
Supabase project, copy `.env.example` to `.env.local`, run the migration, `npm run dev`.

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

## 4. Known limitations / deliberately deferred

- **Mobile auth screens don't exist yet.** Citizen flows are anonymous by design (FR-005), so
  this doesn't block the core loop, but there's no sign-in UI in the Flutter app yet (the web
  dashboard has one, for analysts/institution officers).
- **Share-to-Chekkam (FR-014–016, SRS Build Priority 4) isn't wired up.** `share_plus` and a
  `receive_sharing_intent`-equivalent are the next Flutter feature to add.
- **Offline report queueing isn't implemented.** The SRS's non-functional requirement ("queue
  a submitted report locally and retry when connectivity returns") is real but not yet built;
  `connectivity_plus` is already a dependency for this.
- **Safety-alert proximity targeting is approximate**, not a true radius query — see the
  comment in `chekkam-backend/app/api/safety-alerts/[id]/approve/route.ts`. The schema
  deliberately avoids storing exact device coordinates at rest (SRS §5.12), so real proximity
  targeting needs an approximate-area tagging pipeline that doesn't exist yet.
- **OCR-assisted document matching (FR-048)** and **cross-language campaign matching
  (FR-033)** are explicitly Phase 2 in the SRS and not built.
- **WhatsApp/Telegram integrations** have working webhook/stub endpoints but no reply-back
  logic yet (needs real WhatsApp Business API credentials to test end to end).
- **Browser extension** doesn't exist (SRS Build Priority 7, explicitly last).

## 5. Suggested next steps, in priority order

1. Mobile auth screens (sign-in/sign-up) so institution officers can also verify their own
   institution's documents from the app, and citizens can opt into report-status notifications.
2. Share-to-Chekkam incoming intent handling (`receive_sharing_intent` or equivalent) —
   SRS calls this "high-impact, relatively small addition once the reporting flow exists."
3. Push notification wiring end-to-end: register a device token from the app
   (`POST /api/push/register-token`) once a Firebase project exists, and test a real report
   status-change notification.
4. Offline report queueing on the mobile app.
5. Analyst dashboard maturity: campaign management UI (confirm/merge/split), institution
   onboarding UI (currently API-only).

## 6. Design decisions worth knowing about

- **AI failures never block a result.** `analyzeContent()` always returns a usable risk
  result — real AI output or a deterministic rule-based fallback — never an error state
  (FR-025). The same is true for missing Firebase config on the push-sending path.
- **Every document-signing private key lives only in an environment variable**, named
  `DOCUMENT_SIGNING_KEY_<institution-uuid>`, never in the database (SRS §10.1, §14). The
  `POST /api/institutions` response returns a freshly generated private key exactly once.
- **Every write that can affect the public record goes through human approval**: public
  alerts have a separate `publish` step, safety alerts have an `approve` step, and AI report
  results always carry `needs_human_review: true` regardless of confidence.
