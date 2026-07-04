# Chekkam — Software Requirements Specification (SRS)

**Version:** 2.0 — revised for a durable, long-term architecture (Flutter mobile app + web dashboard)
**Status:** Build-ready
**Prepared for:** Development team / AI coding agents (Claude Code) building this system
**Companion documents:** `Chekkam_Project_Overview.md`, `Chekkam_Brand_Guide.md`

> **What changed from v1.0:** The earlier draft scoped a web-only build to fit a tight contest deadline. The team has since decided to build the real, durable product from the start: a native **Flutter mobile app** for citizens (Android + iPhone from one codebase) and a **web dashboard** for analysts/institutions, sharing one backend. This version reflects that decision. The competition dates are still real and still matter (see §2.5), but nothing in this document is a shortcut taken purely to hit a deadline.

> **How to use this document if you are an AI coding agent:** Read it in full before writing any code. Section 2 defines the architecture and what to prioritize. Section 5 (data model) and Section 6 (API) are backend-agnostic to frontend choice and should be implemented close to verbatim — they are consumed by both the Flutter app and the web dashboard. Section 7 (Permissions & Consent) is a hard constraint, not a suggestion.

---

## 0. Document Control

| | |
|---|---|
| System name | Chekkam |
| System type | Digital-trust platform: scam/misinformation detection, document authentication, embeddable verification API, community safety alerts |
| Primary country focus | Cameroon |
| Citizen-facing client | **Flutter mobile app** (Android + iOS, one codebase) |
| Institution/analyst/admin client | **Web dashboard** (Next.js) |
| Shared backend | Node/Next.js API + Supabase (Postgres, Auth, Storage) |
| Primary languages | English, French, Pidgin |
| Primary users | Citizens, analysts, institution officers, API partners, law-enforcement liaisons, admins, super admins, public visitors |

---

## 1. Introduction

### 1.1 Purpose

This SRS defines the functional, non-functional, data, API, security, and operational requirements for Chekkam, built as a long-term product rather than a deadline-driven prototype. It remains written to be directly buildable by a development team or an AI coding agent with minimal additional clarification.

### 1.2 Scope

Chekkam consists of three coordinated parts:

1. **A Flutter mobile app** — the primary way citizens interact with Chekkam: submitting reports, scanning/verifying documents, receiving safety alerts, and sharing suspicious content into the app directly from WhatsApp, Gallery, or any other app.
2. **A web dashboard** — used by analysts, institution officers, and admins, who work at a desk and don't need a mobile-first experience.
3. **A shared backend** — one API and one database serving both clients, plus a future public partner API and browser extension without any duplication of logic.

This SRS specifies the full five-pillar vision. Section 2.5 identifies a realistic build order so that meaningful, working software exists at each stage — including in time for the ICT Innovation Week pitch — without treating the deadline as a reason to cut corners on the underlying architecture.

### 1.3 Objectives

- Provide a mobile-first reporting experience with explainable AI risk analysis.
- Let institutions cryptographically sign outgoing official documents; let anyone verify them via the app's camera scanner, a typed PIN, or a file upload — including from a photocopy or forwarded scan.
- Let citizens share a suspicious document, screenshot, or link directly into Chekkam from any other app, using native OS share integration.
- Detect repeated scam/misinformation campaigns across languages and formats.
- Provide a moderated community safety-alert channel with real push notifications, complementing — never replacing — emergency services.
- Expose a documented API so partner organizations can eventually embed verification into their own systems.
- Require human analyst approval before anything is published, revoked, or broadcast.
- Ask explicit, standard OS permission for every camera, file, location, or notification access — nothing passive, nothing silent.
- Minimize personal data collection and protect sensitive evidence and location data.

### 1.4 Definitions

| Term | Meaning |
|---|---|
| Campaign | A group of related reports describing the same scam, false claim, impersonation, or harmful pattern |
| Document Signature | A cryptographic hash of a document, signed with the issuing institution's private key |
| Verification ID | The unique code (encoded in a QR and usable as a manually-typed PIN) used to look up a signed document |
| Share Target / Share Intent | The OS-level mechanism letting a user send content from one app into another via the native "Share" menu |
| Evidence | File hashes, metadata, OCR text, and similarity indicators supporting review |
| Trusted Source | A verified official website, page, institution profile, or media source |
| Public Alert | A human-approved warning published for citizens after verification |
| Safety Alert | A human-moderated, location-tagged community notification about a local incident |
| API Partner | An organization issued an API key to embed Chekkam verification into its own systems |
| RLS | Row Level Security (Postgres/Supabase access control enforced at the database layer) |

### 1.5 References

- Kenya National Examinations Council (KNEC) signed-QR certificate verification model
- Nigeria WAEC / NYSC PIN-based verification portal model
- Cameroon Digital Cameroon Strategic Plan ("strengthening digital trust" pillar)
- Cameroon National Development Strategy 2020–2030 (NDS30)

---

## 2. Overall Description

### 2.1 Product Perspective

Chekkam is a three-part system: a Flutter mobile app (citizens), a Next.js web dashboard (analysts, institution officers, admins), and a shared Node/Next.js API backed by Supabase (Postgres + Storage + Auth). An AI provider (OpenAI API) performs risk analysis; a cryptographic signing module handles document authenticity. Both clients call the same backend API — there is exactly one source of truth for every report, document, and alert.

### 2.2 Product Functions (Full Vision)

- User registration, authentication, and role-based access control; API-key issuance for partner organizations.
- Suspicious content submission through the mobile app, the web dashboard (for institution-side use), WhatsApp, and (later) a browser extension.
- Native share-to-Chekkam: receiving shared text, links, images, or files from other apps on the phone.
- AI risk analysis with score, category, reasons, language, and recommended action.
- Evidence extraction from text, screenshots, files, links, and documents.
- Campaign fingerprinting and grouping.
- Document registration, cryptographic signing, QR/PIN generation, and verification via camera scan, manual entry, or file upload.
- Analyst review, verification, escalation, and alert/document-status approval (web dashboard).
- Institution onboarding, official source and document-template management, impersonation response (web dashboard).
- Public alert page and broadcast-ready safety posts.
- Real push notifications for safety alerts and report status updates.
- Partner API for text, link, and document verification with usage logging.
- Community safety incident submission, moderation, and proximity-based push notification.
- Audit logs, privacy redaction, secure evidence/location access.

### 2.3 User Classes

| Class | Primary client |
|---|---|
| Public Visitor | Mobile app (document verification without an account) or the public web page |
| Citizen/User | Mobile app — reports, incidents, document checks, safety alerts |
| Analyst | Web dashboard |
| Institution Officer | Web dashboard (document signing/management); may also use the mobile app to check documents |
| API Partner | No UI — server-to-server API access |
| Law-Enforcement Liaison | Receives escalations via email/notification, not a full platform account (§9.6 in the backend spec) |
| Admin | Web dashboard |
| Super Admin | Web dashboard |

### 2.4 Operating Environment

| Component | Choice | Notes |
|---|---|---|
| **Mobile app** | Flutter (Dart), targeting Android and iOS from one codebase | Primary citizen-facing client |
| QR/document scanning | `mobile_scanner` package | Native camera-based scanning, not a browser prompt |
| Share-to-Chekkam | `share_plus` (outgoing) + `receive_sharing_intent` (incoming) packages | Registers Chekkam in the OS share sheet on both Android and iOS |
| Push notifications | Firebase Cloud Messaging + `firebase_messaging` package | Reliable on both platforms |
| Permissions | `permission_handler` package | Every camera/photo/location/notification request is explicit — see §7 |
| Local state/storage | `flutter_secure_storage` (sensitive data), standard state management (Riverpod or Provider — pick one and use it consistently) | |
| Backend client (mobile) | Official `supabase_flutter` SDK | Direct Supabase Auth/Postgres/Storage access from the app where appropriate, alongside custom API routes for AI/signing logic |
| **Web dashboard** | Next.js (App Router) + React, TypeScript | Analyst/institution/admin use only |
| **Backend** | Next.js API routes (Node.js runtime) | Shared by both clients |
| **Database** | Supabase Postgres (PostGIS extension enabled for geolocation) | |
| **Auth** | Supabase Auth, role stored in a `profiles` table, RLS policies enforced | Shared across mobile and web |
| **Storage** | Supabase Storage (buckets: `report-uploads`, `signed-documents`) | |
| **AI Provider** | OpenAI API (chat completions with structured JSON output) | |
| **Cryptography** | Node `crypto` module — SHA-256 hashing, ECDSA (P-256) signatures | Server-side only |
| **QR generation** | `qrcode` npm package (server-side, when a document is signed) | |
| **Messaging** | Meta WhatsApp Cloud API, Telegram Bot API | Phase 2 |
| **Hosting** | Vercel (web dashboard + API routes), Supabase (data/storage/auth), Google Play + Apple App Store (mobile app distribution) | |
| **Styling (web)** | Tailwind CSS, using tokens from `Chekkam_Brand_Guide.md` | |
| **Styling (mobile)** | Flutter theme configured to match the same brand tokens (colors, type scale) from `Chekkam_Brand_Guide.md` | Keep both clients visually consistent |

### 2.5 Build Priority (Not a Deadline-Driven Shortcut List)

The team's priority is a durable product, not a rushed one. That said, the ICT Innovation Week competition dates are real (registration closes 22 July 2026, pre-selection published 24 July, bootcamp 27–29 July, final pitch 30 July 2026), and it's still worth building in an order that leaves something genuinely demoable at each checkpoint. The difference from the original plan: every piece built below is real, production-track code — nothing here is thrown away after the pitch.

| Priority | Feature | Why this order |
|---|---|---|
| 1 | Backend foundation — schema (§5), auth, core API routes (§6) | Everything else depends on this; identical whether the frontend is Flutter or web |
| 2 | Document signing (web dashboard, institution officer side) + document verification (Flutter app: camera scan, manual PIN entry, file upload) | Self-contained, no third-party API dependency, directly demonstrates the cryptographic core |
| 3 | Citizen reporting + AI risk analysis (Flutter app) | Core value proposition; depends only on the backend and OpenAI |
| 4 | Share-to-Chekkam (Flutter, incoming share intent) | High-impact, relatively small addition once the reporting flow exists |
| 5 | Analyst review screen (web dashboard) | Needed for human-review-before-publish to actually function end to end |
| 6 | Public alert page + basic campaign grouping | Rounds out the demonstrable loop |
| 7 | Push notifications, safety alerts, partner API, WhatsApp, browser extension | Full Phase 2 build-out, post-pitch, no time pressure to rush these |

### 2.6 Assumptions & Constraints

- Team's primary language comfort for the mobile app is Dart/Flutter (confirmed).
- Supabase, an OpenAI API key, and a Firebase project (for push) are available before development starts.
- Publishing to the Apple App Store requires an active Apple Developer account (paid, annual) and app review lead time — plan for this early, it is often the slowest step in any mobile launch, not the coding.
- Publishing to the Google Play Store requires a one-time developer registration fee and a review pass, typically faster than Apple's.
- No production law-enforcement liaison relationship is assumed to exist yet — model it in the data (§5.10) but do not claim live integration until one is formally established.

---

## 3. System Architecture & Project Structure

### 3.1 Architecture Diagram

```
        ┌─────────────────────────┐        ┌─────────────────────────┐
        │     Flutter Mobile App    │        │      Web Dashboard       │
        │  (citizens, public users) │        │ (analysts, institutions, │
        │                           │        │        admins)           │
        │  - Report submission      │        │  - Report review         │
        │  - QR/document scan       │        │  - Document signing      │
        │  - Share-to-Chekkam       │        │  - Campaign management   │
        │  - Push notifications     │        │  - Public alert authoring│
        └────────────┬──────────────┘        └────────────┬────────────┘
                     │                                     │
                     └───────────────┬─────────────────────┘
                                     │
                       ┌─────────────▼─────────────┐
                       │      Shared Application API │
                       │      (Next.js API routes)   │
                       │   AI risk · signing · geo    │
                       └─────────────┬─────────────┘
                                     │
                  ┌──────────────────┼──────────────────┐
                  │                  │                  │
           ┌──────▼──────┐   ┌───────▼───────┐   ┌──────▼──────┐
           │  Supabase   │   │   OpenAI API  │   │  Node crypto│
           │  Postgres + │   │  (risk        │   │  (ECDSA     │
           │  Storage +  │   │   analysis)   │   │  signing)   │
           │  Auth       │   │               │   │             │
           └─────────────┘   └───────────────┘   └─────────────┘
                                     │
                       ┌─────────────▼─────────────┐
                       │   Firebase Cloud Messaging  │
                       │      (push notifications)   │
                       └─────────────────────────────┘
```

### 3.2 Recommended Repository Structure

Two applications, one shared backend contract (kept in sync via the API spec in §6 and the data model in §5). A monorepo is recommended but not required.

```
chekkam/
├── mobile/                          # Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app/
│   │   │   ├── theme.dart           # Brand tokens from Chekkam_Brand_Guide.md
│   │   │   └── router.dart
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── reports/
│   │   │   │   ├── report_form_screen.dart
│   │   │   │   └── report_result_screen.dart
│   │   │   ├── documents/
│   │   │   │   ├── scan_screen.dart          # mobile_scanner integration
│   │   │   │   ├── manual_verify_screen.dart # PIN entry
│   │   │   │   └── verify_result_screen.dart
│   │   │   ├── share_intent/
│   │   │   │   └── share_intent_handler.dart # receive_sharing_intent wiring
│   │   │   ├── alerts/
│   │   │   │   └── public_alerts_screen.dart
│   │   │   └── safety/                       # Phase 2
│   │   ├── services/
│   │   │   ├── api_client.dart               # calls the shared backend
│   │   │   ├── supabase_service.dart
│   │   │   ├── push_service.dart             # firebase_messaging setup
│   │   │   └── permissions_service.dart      # permission_handler wrapper
│   │   └── widgets/                          # shared UI components
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── web/                              # Next.js dashboard + shared API
│   ├── app/
│   │   ├── (public)/
│   │   │   ├── page.tsx              # Marketing/info landing page
│   │   │   └── verify/[verificationId]/page.tsx  # public web verification fallback
│   │   ├── (auth)/
│   │   │   ├── login/page.tsx
│   │   │   └── register/page.tsx
│   │   ├── dashboard/
│   │   │   ├── analyst/page.tsx
│   │   │   ├── institution/page.tsx
│   │   │   └── admin/page.tsx
│   │   └── api/
│   │       ├── reports/route.ts
│   │       ├── reports/[id]/route.ts
│   │       ├── campaigns/route.ts
│   │       ├── institutions/route.ts
│   │       ├── documents/sign/route.ts
│   │       ├── documents/verify/[verificationId]/route.ts
│   │       ├── documents/verify-upload/route.ts
│   │       ├── documents/[id]/revoke/route.ts
│   │       ├── safety-alerts/route.ts
│   │       ├── safety-alerts/[id]/approve/route.ts
│   │       ├── public-alerts/route.ts
│   │       ├── push/register-token/route.ts  # mobile device token registration
│   │       ├── webhooks/whatsapp/route.ts    # Phase 2 stub
│   │       └── v1/partner/check/route.ts     # Partner API stub
│   ├── lib/
│   │   ├── ai/
│   │   │   ├── risk-analysis.ts
│   │   │   └── prompts.ts
│   │   ├── crypto/
│   │   │   ├── sign.ts
│   │   │   ├── verify.ts
│   │   │   └── qrcode.ts
│   │   ├── campaigns/
│   │   │   ├── fingerprint.ts
│   │   │   └── matcher.ts
│   │   ├── push/
│   │   │   └── fcm.ts
│   │   ├── supabase/
│   │   │   ├── client.ts
│   │   │   └── admin.ts
│   │   └── validation/
│   │       └── schemas.ts
│   ├── components/                   # web dashboard UI only
│   ├── supabase/
│   │   └── migrations/
│   │       └── 0001_init.sql         # Section 5 schema
│   └── tailwind.config.js
│
└── docs/
    ├── Chekkam_Project_Overview.md
    ├── Chekkam_Software_Requirements_Specification.md
    └── Chekkam_Brand_Guide.md
```

---

## 4. Functional Requirements

Each requirement lists which client(s) it applies to.

### 4.1 Authentication & Roles

| ID | Requirement | Client(s) |
|---|---|---|
| FR-001 | The system shall allow users to register and log in via Supabase Auth (email/password minimum; phone-based OTP recommended for the mobile app given local usage patterns). | Mobile, Web |
| FR-002 | The system shall support roles: citizen, analyst, institution_officer, admin, super_admin, stored in a `profiles` table. | Backend |
| FR-003 | The system shall restrict dashboard routes and API actions by role using Supabase RLS policies, not just client-side checks. | Backend |
| FR-004 | The system shall log role changes and sensitive admin actions to `audit_logs`. | Backend |
| FR-005 | The system shall allow anonymous use of core citizen features (reporting, document verification) without requiring account creation. | Mobile |

### 4.2 Citizen Reporting

| ID | Requirement | Client(s) |
|---|---|---|
| FR-010 | The system shall allow a citizen to submit suspicious text, a link, or an uploaded screenshot/file from within the app. | Mobile |
| FR-011 | The system shall assign a unique report ID and show a confirmation screen with that ID after submission. | Mobile |
| FR-012 | The system shall show the AI risk result to the submitter once analysis completes (§7 of the backend spec below). | Mobile |
| FR-013 | The system shall allow institution officers to view reports mentioning their institution from the web dashboard. | Web |

### 4.3 Share-to-Chekkam (Native Share Intent)

| ID | Requirement | Client(s) |
|---|---|---|
| FR-014 | The mobile app shall register as a share target on both Android and iOS, appearing in the native OS share sheet. | Mobile |
| FR-015 | When the user shares text, a link, or an image/file into Chekkam from another app, the system shall pre-fill a new report with that content and route the user to review and submit it. | Mobile |
| FR-016 | Sharing into Chekkam shall never auto-submit without the user reviewing and confirming — the share action opens a pre-filled report screen, it does not silently submit. | Mobile |

### 4.4 AI Risk Analysis

| ID | Requirement | Client(s) |
|---|---|---|
| FR-020 | The system shall classify submitted content by risk level: Low, Medium, High, or Critical. | Backend |
| FR-021 | The system shall identify a likely category (fake recruitment, scholarship scam, mobile-money fraud, phishing, impersonation, fake government notice, leaked document, AI manipulation, other). | Backend |
| FR-022 | The system shall provide plain-language, explainable reasons for the risk result. | Backend |
| FR-023 | The system shall provide a recommended action for the user in the same response. | Backend |
| FR-024 | The system shall clearly label AI output as advisory, pending human review, both in the API response (`needs_human_review: true`) and in the mobile app's UI copy. | Backend, Mobile |
| FR-025 | If the AI provider call fails or times out, the system shall fall back to a rule-based check rather than showing an error with no result. | Backend |

### 4.5 Campaign Detection

| ID | Requirement | Client(s) |
|---|---|---|
| FR-030 | The system shall extract fingerprint indicators from each report: links, phone numbers, payment/mobile-money numbers, and a normalized text hash. | Backend |
| FR-031 | The system shall compare new reports against existing reports and flag matches above a similarity threshold as a candidate campaign. | Backend |
| FR-032 | The system shall allow an analyst to confirm, merge, split, or reject a campaign grouping from the web dashboard. | Web |
| FR-033 | The system shall support cross-language matching (English/French/Pidgin) for identical underlying claims. | Backend (Phase 2) |

### 4.6 Document Authentication & Digital Signature

| ID | Requirement | Client(s) |
|---|---|---|
| FR-040 | The system shall allow an authorized institution officer to register a document (file upload) for signing from the web dashboard. | Web |
| FR-041 | The system shall compute a SHA-256 hash of the document content and sign that hash with the institution's ECDSA private key. | Backend |
| FR-042 | The system shall generate a unique, human-readable verification ID, a numeric PIN, and a QR code encoding a verification URL. | Backend |
| FR-043 | The mobile app shall allow a user to verify a document by scanning the QR code with the device camera (`mobile_scanner`), manually entering the verification ID/PIN, or uploading a photo/file of the document. | Mobile |
| FR-044 | The web dashboard shall also expose a manual verification page (ID/PIN entry, file upload) for verifiers without the mobile app installed. | Web |
| FR-045 | The verification result shall be exactly one of: Genuine, Tampered, Revoked, or Not Found. | Backend |
| FR-046 | The system shall allow an institution officer to revoke a previously signed document, after which verification returns Revoked with the stated reason. | Web |
| FR-047 | The system shall maintain a per-institution log of all documents signed, verified, and revoked, visible on the web dashboard. | Web |
| FR-048 | The system shall support OCR-assisted matching so a photographed/rescanned copy of a signed document can still be matched to its record when an exact hash match fails. | Backend (Phase 2) |

### 4.7 Push Notifications

| ID | Requirement | Client(s) |
|---|---|---|
| FR-050 | The mobile app shall request notification permission explicitly (never pre-checked or silent) and register the resulting device token with the backend. | Mobile |
| FR-051 | The backend shall send a push notification when a submitted report's status changes to a final state (verified threat, false report, etc.), if the user opted in. | Backend |
| FR-052 | The backend shall send a push notification to opted-in users within a configured radius when a safety alert is approved (Phase 2). | Backend |

### 4.8 Public Verification API (Phase 2, Data Model Now)

| ID | Requirement | Client(s) |
|---|---|---|
| FR-060 | The system shall issue API keys to approved partner organizations, storing only a hashed version of the key. | Backend |
| FR-061 | The system shall expose authenticated endpoints for text/link risk checks and document verification under `/v1/partner/`. | Backend |
| FR-062 | The system shall rate-limit API requests per key and log usage. | Backend |

### 4.9 Community Safety Alert Network (Phase 2, Data Model Now)

| ID | Requirement | Client(s) |
|---|---|---|
| FR-070 | The mobile app shall allow a user to report a local incident with category, description, optional media, and location — location requested via an explicit, standard OS permission prompt. | Mobile |
| FR-071 | Incident reports shall queue for analyst review on the web dashboard, separate from the scam/misinformation queue. | Web |
| FR-072 | Upon analyst approval, the system shall push-notify opted-in users within a configurable radius of the incident location. | Backend, Mobile |
| FR-073 | Every safety alert shall display a disclaimer that it is a community information channel, instructing users to contact official emergency numbers for immediate danger. | Mobile |
| FR-074 | The system shall rate-limit incident submissions per user/device to reduce false or malicious reports. | Backend |

### 4.10 Institution & Analyst/Admin Dashboard (Web)

| ID | Requirement | Client(s) |
|---|---|---|
| FR-080 | The system shall allow institution officers to register verified websites and social pages for their institution. | Web |
| FR-081 | The system shall display report and document lists filterable by status, risk level, and category. | Web |
| FR-082 | The system shall allow analysts to view AI analysis details alongside each report. | Web |
| FR-083 | The system shall allow analysts to approve, reject, or mark reports/documents as reviewed. | Web |
| FR-084 | The system shall allow admins to manage trusted sources and platform settings. | Web |

### 4.11 Public Alert Page & Broadcast

| ID | Requirement | Client(s) |
|---|---|---|
| FR-090 | The system shall display human-approved public alerts, accessible from both the mobile app and a public web page. | Mobile, Web |
| FR-091 | The system shall support generating Telegram/Facebook/X copy-ready formats from an approved alert (web dashboard). | Web (Phase 2) |

---

## 5. Data Model

Unchanged from the backend's perspective regardless of frontend choice — implement as a single Supabase migration (`web/supabase/migrations/0001_init.sql`). All tables use `uuid` primary keys (`gen_random_uuid()`) and `timestamptz` timestamps. Enable `pgcrypto` and `postgis` first.

```sql
-- Extensions
create extension if not exists pgcrypto;
create extension if not exists postgis;

-- 5.1 Profiles (extends Supabase auth.users)
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  phone text unique,
  role text not null default 'citizen'
    check (role in ('citizen','analyst','institution_officer','admin','super_admin')),
  preferred_language text default 'en' check (preferred_language in ('en','fr','pidgin')),
  consent_location boolean default false,
  consent_notifications boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5.2 Institutions
create table institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text check (type in
    ('ministry','exam_board','school','university','company','ngo','media','civil_registry','other')),
  verified boolean default false,
  verified_domains text[] default '{}',
  signing_public_key text,
  signing_key_ref text,          -- reference only; private key material lives in a secrets manager, never in this table
  contact_email text,
  contact_phone text,
  status text default 'pending' check (status in ('pending','active','suspended')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5.3 Institution members
create table institution_members (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  role text default 'officer' check (role in ('officer','admin')),
  created_at timestamptz default now(),
  unique (institution_id, user_id)
);

-- 5.4 Documents
create table documents (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id) on delete restrict,
  document_type text not null,
  recipient_name text,
  file_hash text not null,
  signature text not null,
  verification_id text unique not null,   -- e.g. CHK-4F7K-9QRT
  qr_payload text not null,
  pin_code text,
  issued_at timestamptz default now(),
  status text default 'active' check (status in ('active','revoked')),
  revoked_at timestamptz,
  revocation_reason text,
  metadata jsonb default '{}',
  created_at timestamptz default now()
);
create index idx_documents_verification_id on documents(verification_id);
create index idx_documents_file_hash on documents(file_hash);

-- 5.5 Document verification logs
create table document_verification_logs (
  id uuid primary key default gen_random_uuid(),
  document_id uuid references documents(id) on delete set null,
  verification_id_attempted text,
  result text check (result in ('genuine','tampered','revoked','not_found')),
  verifier_channel text check (verifier_channel in ('mobile','web','api')),
  created_at timestamptz default now()
);

-- 5.6 Campaigns
create table campaigns (
  id uuid primary key default gen_random_uuid(),
  title text,
  fingerprint jsonb default '{}',
  category text,
  risk_level text check (risk_level in ('low','medium','high','critical')),
  report_count int default 0,
  status text default 'open' check (status in ('open','confirmed','merged','dismissed')),
  merged_into uuid references campaigns(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5.7 Reports
create table reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references profiles(id) on delete set null,
  channel text default 'mobile' check (channel in ('mobile','web','whatsapp','api','share_intent')),
  content_type text check (content_type in ('text','link','image','file')),
  raw_content text,
  file_url text,
  language text default 'unknown' check (language in ('en','fr','pidgin','mixed','unknown')),
  risk_level text check (risk_level in ('low','medium','high','critical')),
  risk_score int check (risk_score between 0 and 100),
  category text,
  ai_reasons text[],
  ai_indicators jsonb default '{}',
  recommended_action text,
  needs_human_review boolean default true,
  confidence text check (confidence in ('low','medium','high')),
  status text default 'pending' check (status in
    ('pending','analyzed','under_review','verified_threat','false_report','dismissed')),
  campaign_id uuid references campaigns(id) on delete set null,
  location geography(point, 4326),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5.8 Evidence
create table evidence (
  id uuid primary key default gen_random_uuid(),
  report_id uuid references reports(id) on delete cascade,
  document_id uuid references documents(id) on delete cascade,
  file_hash text,
  file_type text,
  exif_metadata jsonb,
  ocr_text text,
  perceptual_hash text,
  created_at timestamptz default now()
);

-- 5.9 Public alerts
create table public_alerts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  alert_type text check (alert_type in
    ('scam_campaign','document_fraud','safety_incident','general_advisory')),
  related_campaign_id uuid references campaigns(id),
  severity text check (severity in ('info','warning','critical')),
  published boolean default false,
  published_at timestamptz,
  created_by uuid references profiles(id),
  created_at timestamptz default now()
);

-- 5.10 Liaison contacts
create table liaison_contacts (
  id uuid primary key default gen_random_uuid(),
  organization text not null,
  region text,
  contact_name text,
  email text,
  phone text,
  active boolean default true,
  created_at timestamptz default now()
);

-- 5.11 Safety alerts
create table safety_alerts (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references profiles(id) on delete set null,
  category text check (category in
    ('violent_crime','accident','fire','natural_hazard','civil_unrest','missing_person','other')),
  description text,
  media_url text,
  location geography(point, 4326),
  location_precision text default 'approximate' check (location_precision in ('exact','approximate')),
  radius_meters int default 1000,
  status text default 'pending' check (status in
    ('pending','approved','rejected','merged','resolved')),
  escalated_to_liaison boolean default false,
  liaison_contact_id uuid references liaison_contacts(id),
  analyst_id uuid references profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5.12 Device tokens (push notifications)
create table device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade,
  fcm_token text not null,
  platform text check (platform in ('android','ios')),
  last_known_area text,          -- approximate area only, never exact coordinates at rest
  consent_given boolean default true,
  created_at timestamptz default now(),
  unique (user_id, fcm_token)
);

-- 5.13 API keys
create table api_keys (
  id uuid primary key default gen_random_uuid(),
  organization_name text not null,
  key_hash text not null,
  key_prefix text not null,
  scopes text[] default '{}',
  rate_limit_per_minute int default 60,
  status text default 'active' check (status in ('active','revoked')),
  created_at timestamptz default now(),
  revoked_at timestamptz
);

-- 5.14 API usage logs
create table api_usage_logs (
  id uuid primary key default gen_random_uuid(),
  api_key_id uuid references api_keys(id) on delete cascade,
  endpoint text,
  status_code int,
  response_time_ms int,
  created_at timestamptz default now()
);

-- 5.15 Trusted sources
create table trusted_sources (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id),
  name text,
  type text check (type in ('website','facebook_page','twitter_account','telegram_channel','phone_number')),
  value text,
  verified boolean default true,
  created_at timestamptz default now()
);

-- 5.16 Audit logs
create table audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references profiles(id),
  actor_type text default 'user' check (actor_type in ('user','system','api_partner')),
  action text not null,
  target_table text,
  target_id uuid,
  metadata jsonb default '{}',
  created_at timestamptz default now()
);
```

**Row Level Security (minimum required policies):**
- `reports`: a citizen can `select`/`insert` their own rows (or anonymous insert); analysts/admins can `select`/`update` all rows.
- `documents`: institution officers can `insert`/`update` only documents where `institution_id` matches their `institution_members` row; verification reads go through a service-role-backed API route, not direct client table access.
- `profiles`: users can `select`/`update` their own row only; admins can `select` all.
- `device_tokens`: a user can only `insert`/`delete` their own tokens.

---

## 6. API Specification

Shared by both clients. Internal endpoints (`/api/`) use Supabase Auth session/JWT; partner endpoints (`/v1/partner/`) use API-key header auth.

### 6.1 Reports

**POST `/api/reports`**
```json
// Request
{ "content_type": "text", "raw_content": "Congratulations! You have won 500,000 FCFA...", "channel": "mobile" }
// Response 201
{ "id": "b3f1...", "status": "pending", "message": "Report received. Analyzing..." }
```

**GET `/api/reports/:id`**
```json
{
  "id": "b3f1...",
  "status": "analyzed",
  "risk_level": "high",
  "risk_score": 82,
  "category": "mobile_money_fraud",
  "ai_reasons": [
    "Requests urgent action and payment before verifying identity",
    "Uses generic congratulatory language typical of lottery scams",
    "No verifiable sender or institution named"
  ],
  "recommended_action": "Do not send money or share personal information.",
  "needs_human_review": true,
  "confidence": "high"
}
```

**GET `/api/reports`** — filterable list (web dashboard). **PATCH `/api/reports/:id`** — analyst status update.

### 6.2 Campaigns

**GET `/api/campaigns`**, **GET `/api/campaigns/:id`**, **PATCH `/api/campaigns/:id`** (merge/confirm/dismiss — web dashboard).

### 6.3 Institutions

**POST `/api/institutions`**, **GET `/api/institutions/:id`**, **POST `/api/institutions/:id/members`** (web dashboard).

### 6.4 Documents

**POST `/api/documents/sign`** (web dashboard, institution officer)
```json
// Request (multipart/form-data)
{ "institution_id": "a1c2...", "document_type": "certificate", "recipient_name": "Jane Doe" }
// Response 201
{
  "id": "doc_9f...",
  "verification_id": "CHK-4F7K-9QRT",
  "pin_code": "482915",
  "qr_payload": "https://chekkam.cm/verify/CHK-4F7K-9QRT",
  "status": "active"
}
```

**GET `/api/documents/verify/:verificationId`** (mobile + web)
```json
{ "status": "genuine", "institution": "Lycée Bilingue de Yaoundé", "document_type": "certificate", "verification_id": "CHK-4F7K-9QRT" }
```

**POST `/api/documents/verify-upload`** (mobile + web — hash comparison)
**POST `/api/documents/:id/revoke`** (web dashboard)

### 6.5 Push Notifications

**POST `/api/push/register-token`** (mobile)
```json
{ "fcm_token": "d3f...", "platform": "android" }
```

### 6.6 Safety Alerts *(Phase 2 — schema + stub routes now)*

**POST `/api/safety-alerts`** (mobile), **GET `/api/safety-alerts`** (web), **POST `/api/safety-alerts/:id/approve`** (web).

### 6.7 Public Alerts

**GET `/api/public-alerts`** (public, mobile + web), **POST `/api/public-alerts`** (web), **POST `/api/public-alerts/:id/publish`** (web).

### 6.8 Partner API *(Phase 2 — stub now)*

**POST `/v1/partner/check`**, **POST `/v1/partner/document-check`** — API-key authenticated, server-to-server.

### 6.9 Error Response Format

```json
{ "error": { "code": "VALIDATION_ERROR", "message": "raw_content is required for content_type=text", "field": "raw_content" } }
```
Standard HTTP status codes: `400`, `401`, `403`, `404`, `429`, `500`.

---

## 7. Permissions & Consent (Hard Requirement, Not Optional)

Every access to a sensitive device capability must go through the standard OS permission dialog — never pre-granted, never silent, never bundled into a blanket "accept all" at signup.

| Action | Permission requested | Flutter package | Trigger point |
|---|---|---|---|
| Scanning a QR code | Camera | `permission_handler` + `mobile_scanner` | Only when the user taps "Scan QR Code" |
| Uploading a document/screenshot | Photo/file library | `permission_handler` | Only when the user taps "Upload a file" |
| Receiving shared content from another app | None beyond the OS's own share mechanism | `receive_sharing_intent` | The share action itself is the user's consent |
| Safety alert location tagging | Location | `permission_handler` | Only when the user opts into reporting an incident with location |
| Push notifications | Notifications | `firebase_messaging` + `permission_handler` | Only when the user opts into alerts, with a clear explanation of what they'll receive |

**Rules:**
- If a permission is denied, the app must degrade gracefully (e.g., allow manual PIN entry if camera access is denied) rather than block the user entirely.
- No background location tracking, no passive content scanning, no permission requested "just in case" before the relevant feature is used.
- Every permission request should be preceded by a short, plain-language explanation of why it's needed, shown in the app's own UI before the OS dialog appears (a "pre-permission" screen) — this measurably improves grant rates and is standard good practice, not just a trust nicety.

---

## 8. AI Risk Analysis Specification

### 8.1 Why AI Here

Rule-based keyword matching alone cannot explain *why* something is risky in plain language, handle paraphrased scams, or work across English/French/Pidgin without a constantly maintained dictionary. The AI performs risk classification, plain-language explanation, and cross-language category detection. Human review remains mandatory downstream regardless of AI confidence.

### 8.2 System Prompt Template

```
You are a content-risk analyst for Chekkam, a Cameroonian digital-trust platform.
Analyze the submitted content for signs of scam, fraud, impersonation, or harmful
misinformation. Consider common patterns in Cameroon: mobile-money fraud, fake
recruitment/scholarship offers, impersonation of government offices, phishing links.

Respond ONLY with a JSON object matching this exact schema, no other text:
{
  "risk_level": "low" | "medium" | "high" | "critical",
  "risk_score": <integer 0-100>,
  "category": "fake_recruitment" | "scholarship_scam" | "mobile_money_fraud" |
              "phishing" | "impersonation" | "fake_government_notice" |
              "leaked_document" | "ai_manipulation" | "other" | "none",
  "language": "en" | "fr" | "pidgin" | "mixed" | "unknown",
  "reasons": [<2-4 short plain-language reasons, each under 20 words>],
  "indicators": {
    "has_urgency_pressure": <boolean>,
    "requests_payment": <boolean>,
    "requests_personal_info": <boolean>,
    "impersonates_institution": <string or null>,
    "contains_suspicious_link": <boolean>
  },
  "recommended_action": "<one clear, plain-language sentence>",
  "confidence": "low" | "medium" | "high"
}
```

### 8.3 Output Handling Rules

- Always set `needs_human_review: true` at the application layer, regardless of AI confidence.
- On API failure/timeout (>8s) or invalid JSON, fall back to a rule-based keyword/domain check; return `risk_level: "medium"`, `confidence: "low"`.
- Present results in the mobile app using calm, non-alarmist copy per the Brand Guide's voice principles.

---

## 9. Campaign Detection Algorithm

1. On each new report, extract: URLs (normalized), phone numbers (normalized), a normalized text fingerprint (lowercase, punctuation/accent-stripped, stopwords removed).
2. Compare against existing **open** campaigns: identical URL (weight 0.9), identical phone number (weight 0.85), text similarity >0.75 (weight 0.6).
3. Combined score ≥ 0.6 → attach to that campaign, increment `report_count`; otherwise create a new campaign once a second matching report appears.
4. Cross-language matching and analyst merge/split tooling: Phase 2.

---

## 10. Document Signing & Verification Specification

### 10.1 Signing Steps

1. Compute canonical byte content of the uploaded document.
2. `SHA-256(content)` → hex digest.
3. Sign the digest with the institution's ECDSA (P-256) private key → base64 signature. **Private key material never touches the application database** — reference it via `signing_key_ref`, keep actual keys in a secrets manager.
4. Generate a unique `verification_id` (`CHK-XXXX-XXXX`) and a random 6-digit `pin_code`.
5. Construct `qr_payload` as `https://chekkam.cm/verify/{verification_id}`.
6. Generate a QR code image server-side (`qrcode` package).
7. Insert the `documents` row, `status: 'active'`.
8. Return the verification ID, PIN, and QR image to the institution officer.

### 10.2 Verification Steps

Given a `verification_id`/PIN (scanned or typed):
1. Not found → `not_found`.
2. Found, `revoked` → `revoked` + reason.
3. Found, `active`, no file for comparison → `genuine` (existence + active-status check, mirroring the Nigeria WAEC PIN model).
4. Found, `active`, file uploaded for comparison → recompute hash, compare. Match → `genuine`. Mismatch → `tampered`.

Given only an uploaded file, no ID:
1. Recompute hash, search by `file_hash`. No match → `not_found`. Match + active → `genuine`. Match + revoked → `revoked`.

Every attempt is logged to `document_verification_logs`, tagged with `verifier_channel` (`mobile`/`web`/`api`).

---

## 11. Non-Functional Requirements

| Area | Requirement |
|---|---|
| Usability | Mobile app must work smoothly on mid-range Android devices, which represent the bulk of the Cameroonian market — test on real mid-tier hardware, not just flagship devices or emulators. |
| Performance | AI risk analysis returns within ~5 seconds under normal conditions; document verification within ~2 seconds (no external API dependency). |
| Offline resilience | The mobile app should queue a submitted report locally and retry when connectivity returns, rather than failing outright on a dropped connection — mobile data reliability varies significantly across Cameroon. |
| Reliability | Submission flows must never silently fail — always show a clear success/error/pending state. |
| Auditability | All document signing, revocation, and analyst approval actions are logged. |
| Maintainability | Keep AI, campaigns, documents/signing, and push logic in separate backend modules; keep Flutter features organized by domain (§3.2). |
| Localization | UI copy structured for English/French/Pidgin from the start in both clients. |
| Cryptographic integrity | SHA-256 + ECDSA (P-256) minimum; never roll a custom scheme. |
| App store compliance | Design permission requests and data handling to satisfy both Google Play and Apple App Store review guidelines from the start — retrofitting compliance after a rejected submission costs real time. |

---

## 12. Testing & Acceptance Criteria

### 12.1 Core Loop (Milestone 1)

- [ ] A user can submit a suspicious message from the mobile app and receive a risk score, category, explanation, and recommended action.
- [ ] An institution officer can sign a sample document from the web dashboard and receive a verification ID, PIN, and QR code.
- [ ] Scanning that QR with the mobile app's camera returns "Genuine."
- [ ] Revoking the document, then verifying again, returns "Revoked" with the reason shown.
- [ ] Uploading a deliberately altered copy returns "Tampered."
- [ ] An analyst can view submitted reports on the web dashboard and mark one as reviewed.
- [ ] Sharing a screenshot from WhatsApp into Chekkam via the native share sheet correctly pre-fills a new report.

### 12.2 Phase 2

- [ ] A push notification is received when a report's status changes, if the user opted in.
- [ ] A safety incident submitted with location consent, once approved, triggers a notification to a test account within the configured radius, including the required disclaimer.
- [ ] A partner can obtain an API key and successfully call `/v1/partner/check`.
- [ ] WhatsApp webhook reporting creates a `reports` row indistinguishable in structure from an app-submitted report.
- [ ] Sensitive indicators (phone numbers, exact reporter location) are redacted from all public-facing output.

---

## 13. Security, Privacy & Legal Safety

- Collect only the data needed to analyze and verify reports, documents, and incidents.
- Redact sensitive phone numbers, payment numbers, and precise reporter location from public-facing output.
- Only analysts/admins can view sensitive evidence or institutional signing-key references; private key material is never exposed via any API response.
- Public alerts, document revocations, and safety notifications require human approval, enforced in application logic.
- Use cautious status language ("suspicious," "under review," "verified threat," "verified genuine," "tampered," "false report") — never assert something is definitively fraudulent without human verification.
- Never publicly name or accuse an individual without verified, legally appropriate evidence.
- Safety alerts always carry a visible disclaimer directing users to official emergency numbers.
- Every sensitive permission follows §7 — explicit, contextual, revocable.

---

## 14. Third-Party Integrations & Environment/Config Variables

| Variable/Config | Purpose | Where used |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase client config | Web, Mobile |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-only Supabase access | Backend only, never shipped to any client |
| `OPENAI_API_KEY` | AI risk analysis | Backend |
| `DOCUMENT_SIGNING_KEY_<INSTITUTION_ID>` | Per-institution ECDSA private key | Backend only |
| `APP_BASE_URL` | Constructs QR verification URLs | Backend |
| `firebase_options.dart` (generated via FlutterFire CLI) | Firebase project config for push | Mobile |
| `google-services.json` / `GoogleService-Info.plist` | Platform-specific Firebase config | Mobile (Android/iOS respectively) |
| `WHATSAPP_CLOUD_API_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, `WHATSAPP_VERIFY_TOKEN` | WhatsApp integration | Backend (Phase 2) |
| `TELEGRAM_BOT_TOKEN` | Telegram broadcast | Backend (Phase 2) |

---

## 15. Appendix — Sample Seed Data

```json
{
  "institution": {
    "name": "Lycée Bilingue de Yaoundé",
    "type": "school",
    "contact_email": "admin@example.cm",
    "status": "active"
  },
  "public_alert": {
    "title": "Fake scholarship offer circulating on WhatsApp",
    "body": "A message claiming to offer a government scholarship requiring an upfront 'processing fee' is circulating. This is not a legitimate government process. Do not send payment.",
    "alert_type": "scam_campaign",
    "severity": "warning",
    "published": true
  }
}
```

---

*Companion documents: `Chekkam_Project_Overview.md`, `Chekkam_Brand_Guide.md`.*
