# CHEKKAM AI Integration

## Project Overview

CHEKKAM is an AI-powered National Digital Trust Platform that helps citizens, businesses, educational institutions, and government agencies verify digital information before acting on it. Scams, phishing attempts, fake documents, and impersonation campaigns increasingly arrive through everyday channels — WhatsApp, SMS, email, Telegram, and social media — faster than any manual review process can keep up with.

The AI subsystem described in this document is the verification core of that platform. It analyzes submitted content (messages, documents, images, URLs), assigns a risk assessment, and routes the result through human moderation before anything is published as a public warning. AI augments moderator judgment; it does not replace it.

This document describes the target architecture for the AI subsystem. It is a planning and reference document, not a record of what has already been shipped — see [Development Roadmap](#development-roadmap) for what is planned per phase, and the codebase (`lib/ai/`) for what currently exists.

## AI Objectives

- Detect scams across the channels citizens actually use (WhatsApp, SMS, email, Telegram, social media).
- Detect phishing attempts and credential-harvesting content.
- Verify suspicious messages and explain *why* they're suspicious, not just flag them.
- Verify the authenticity of submitted documents (certificates, admission letters, government notices).
- Detect fake or spoofed websites impersonating trusted institutions.
- Improve the platform's overall cybersecurity posture by catching abuse patterns early (prompt injection, malicious uploads, automated report flooding).
- Support human moderators with structured, evidence-backed AI output rather than opaque scores, so review is fast and defensible.

## AI Architecture

The AI subsystem is composed of independent, single-responsibility modules. Each module can be developed, tested, and scaled separately, and each degrades gracefully (falls back to a deterministic rule-based path) if its upstream AI provider is unavailable.

### Message Verification Engine

**Responsibilities**
Analyze a single piece of submitted text — regardless of originating channel — and produce a structured risk assessment.

**Inputs**
- Raw message text
- Originating channel (WhatsApp, SMS, email, Telegram, Messenger, plain text submission)
- Optional metadata (sender identifier, timestamp)

**Outputs**
- Risk level (`safe` / `low` / `medium` / `high` / `critical`)
- Confidence score
- Detected scam category (fake recruitment, scholarship scam, mobile money fraud, phishing, impersonation, fake government notice, etc.)
- Human-readable reasons
- Suggested action

**Workflow**
1. Normalize and sanitize input text.
2. Run the primary AI classifier (see [AI Technology Stack](#ai-technology-stack)) with a schema-constrained prompt.
3. Validate the model's structured output against a strict schema; on failure, timeout, or missing API key, fall back to a deterministic keyword/pattern-based classifier.
4. Always mark the result as requiring human review — the engine informs moderators, it does not auto-publish.

### OCR Engine

Extracts machine-readable text and structured fields from non-text submissions so the same downstream pipeline (NLP, classification) can process them.

- **Image OCR** — screenshots of chat conversations, photographed documents.
- **PDF OCR** — scanned or exported PDF documents, including multi-page certificates.
- **Screenshot OCR** — UI captures of messages, emails, or web pages, where layout matters as much as text.
- **Text extraction** — structured extraction of names, dates, phone numbers, emails, URLs, QR code payloads, institution names, certificate numbers, and ID numbers, returned as normalized JSON rather than raw text blobs.

### NLP Engine

Runs on text produced either directly by a submitter or via the OCR Engine.

- **Intent detection** — is this a request for payment, a credential request, an urgent call to action, an informational notice?
- **Entity recognition** — institutions, people, locations, monetary amounts, dates.
- **Scam keyword detection** — urgency language, payment/mobile-money terms, credential-harvesting phrases, in both English and French (with Pidgin/mixed-language handling).
- **Government impersonation detection** — pattern matching against known institution names and formats, flagged for closer review rather than auto-condemned.
- **Threat analysis** — sentiment and pressure-tactic indicators that correlate with fraud (urgency, fear, exclusivity).

### Scam Classification Engine

Turns NLP/OCR output into a quantified fraud assessment.

- **Machine learning model** — a classifier trained on labeled scam/legitimate examples, producing a category and probability distribution rather than a binary verdict.
- **Fraud prediction** — category assignment (mobile money fraud, phishing, fake recruitment, scholarship scam, etc.).
- **Risk scoring** — a 0–100 score derived from model confidence and rule-based signal count, giving moderators a consistent ranking across reports.
- **Confidence score** — surfaced separately from risk level, so a `high risk / low confidence` result is visibly different from `high risk / high confidence` and routed accordingly.

### Semantic Similarity Engine

Identifies that today's report and last week's report are the same scam wearing a different sender name.

- **Scam clustering** — groups reports by semantic similarity of content, not just exact text match.
- **Duplicate detection** — flags near-identical submissions to avoid redundant moderator work.
- **Campaign identification** — links reports sharing phone numbers, URLs, or wording into a single tracked campaign, so a moderator resolving one confirms the pattern for all linked reports.

### Website Verification

Given a URL, assesses whether it's likely to be malicious or impersonating a trusted entity.

- **SSL validation** — certificate presence, validity, and issuer reputation.
- **Domain reputation** — domain age, registration patterns, presence on known blocklists.
- **URL analysis** — suspicious query parameters, redirect chains, shortener resolution.
- **Typosquatting detection** — edit-distance comparison against known institutional domains (e.g. a `.cm` government portal look-alike).

### Document Verification

Confirms whether an uploaded document is genuine, tampered, revoked, or unregistered.

- **QR verification** — validates embedded QR payloads against the issuing system.
- **Digital signatures** — verifies cryptographic signatures where the issuing institution provides them.
- **Hash verification** — compares the uploaded document's hash against a registry of known-genuine document hashes.
- **Certificate validation** — cross-references certificate/reference numbers against the issuing institution's records where available.

Returns one of: `genuine`, `tampered`, `revoked`, `not_found`.

### Explainable AI

No module in this system returns a bare score. Every prediction is required to carry:

- **Confidence** — how sure the model is, independent of the risk level itself.
- **Evidence** — the specific signals that drove the result (e.g. "contains a mobile money payment request", "impersonates a government ministry").
- **Reasons** — a short, human-readable explanation a moderator or end user can read without ML background.
- **Risk explanation** — why this risk level specifically, not a neighboring one.

This is a hard requirement, not a nice-to-have: moderators are making publication decisions based on this output, and opaque scores are not defensible in that context.

### Human Moderation

AI never auto-publishes a critical alert. Every AI-assessed report that reaches a `medium` risk level or above enters a moderation queue before anything is public.

**Workflow**

```
Citizen
   ↓
AI Analysis
   ↓
Risk Score
   ↓
Moderator Review
   ↓
Final Decision
   ↓
Publication
```

The AI's job is to make the moderator's decision faster and better-informed — sorting the queue by urgency, pre-filling evidence, surfacing linked campaigns — not to remove the moderator from the loop.

## AI Technology Stack

| Layer | Recommendation | Why |
|---|---|---|
| OCR | Cloud OCR API (e.g. Google Cloud Vision / Azure Document Intelligence) with a local Tesseract fallback | Cloud OCR gives materially better accuracy on noisy phone-camera images and handwriting; a local fallback keeps the pipeline functional if the cloud provider is unavailable or the document is sensitive. |
| NLP | LLM-based extraction (schema-constrained prompts) over a general-purpose model, backed by a lightweight rule-based fallback | An LLM handles the variability of real-world scam text (multilingual, deliberately obfuscated) far better than a fixed classifier; the rule-based fallback guarantees the pipeline degrades to *something useful* rather than failing closed. |
| Machine Learning (classification) | A dedicated classifier fine-tuned or prompt-engineered specifically for the scam categories CHEKKAM tracks | General-purpose models are good at open-ended reasoning but benefit from being constrained to CHEKKAM's specific taxonomy for consistent, comparable risk scores over time. |
| Vector Search | A managed vector database (e.g. pgvector on the existing Postgres instance, or a dedicated vector store) | pgvector in particular avoids introducing a new infrastructure dependency when the platform already runs Postgres, keeping operational surface area small. |
| Embedding Models | A general-purpose multilingual embedding model | CHEKKAM content spans English, French, and Pidgin — embeddings need to cluster semantically similar scams regardless of language. |
| Cloud AI Provider | OpenAI (already integrated via `lib/ai/risk-analysis.ts`) | Existing integration point; schema-constrained JSON output mode is already in use and proven in this codebase. |
| Queue Processing | A background job queue (e.g. BullMQ on Redis, or a managed queue service) | AI analysis, OCR, and similarity search are all too slow to run synchronously inside a request/response cycle without degrading UX. |
| Database | PostgreSQL (existing Supabase instance) | Already the platform's system of record; new AI tables extend the existing schema rather than introducing a second database to keep consistent. |
| Caching | Redis | Needed regardless for queue processing; doubles as a cache for repeated URL/domain reputation lookups to control API cost and latency. |
| API Layer | Next.js API routes (existing pattern in `app/api/`) | Consistent with the rest of the backend; no new framework to learn or operate. |
| Logging | Structured JSON logging to the existing logging pipeline | Predictions need to be auditable after the fact — structured logs make that queryable rather than relying on prose logs. |
| Monitoring | Application performance monitoring with custom metrics for model latency and fallback-rate | Fallback rate (how often the rule-based path fires instead of the AI path) is the single most useful health signal for this subsystem — a spike means the AI provider is degraded. |

## Security

- **Encryption** — sensitive report content and extracted PII encrypted at rest; TLS enforced in transit for all AI provider calls.
- **Authentication** — all AI endpoints require the same authenticated session/API-key model already used elsewhere in the backend; no unauthenticated write access to AI endpoints.
- **Authorization** — moderation queue actions (approve/reject/publish) restricted to moderator/admin roles; standard users can submit but not resolve.
- **Rate limiting** — per-user and per-IP limits on AI-invoking endpoints to control both abuse and API cost, given each call has a real cost against the AI provider.
- **Prompt injection protection** — submitted content is treated strictly as data inside a schema-constrained prompt, never concatenated into instructions; model output is always validated against a strict schema before use, never executed or trusted blindly.
- **Malicious file protection** — uploaded images/PDFs scanned and size/type-restricted before OCR processing; OCR runs against untrusted input by design, so parsing failures must fail safely, not crash the pipeline.
- **Audit logs** — every AI prediction and every moderator decision is logged with actor, timestamp, and reasoning, independent of the general application log.
- **Privacy protection** — extracted PII (phone numbers, ID numbers) is handled under the same data-retention rules as the rest of the platform's user data, not treated as exempt because it passed through an AI pipeline.

## API Endpoints

| Endpoint | Purpose |
|---|---|
| `POST /api/ai/message` | Submit message text for risk analysis via the Message Verification Engine. |
| `POST /api/ai/document` | Submit a document for authenticity verification (hash/signature/QR check). |
| `POST /api/ai/ocr` | Extract structured text/fields from an uploaded image or PDF. |
| `POST /api/ai/image` | Analyze an image for manipulation indicators (edited screenshots, inconsistent metadata). |
| `POST /api/ai/website` | Submit a URL for website verification (SSL, domain reputation, typosquatting). |
| `POST /api/ai/report` | Submit a full report bundling message/document/image/URL for combined analysis and moderation queueing. |
| `GET /api/ai/history` | Retrieve a user's or moderator's past AI analysis results. |
| `GET /api/ai/campaigns` | List identified scam campaigns from the Semantic Similarity Engine. |

## Database Design

| Table | Purpose |
|---|---|
| `ai_reports` | Submitted content pending or completed AI analysis, linked to the submitting user/channel. |
| `ai_predictions` | Structured AI output per report — risk level, category, confidence, evidence, model version. |
| `ocr_results` | Extracted text and structured fields from OCR processing, linked to the source upload. |
| `scam_campaigns` | Clustered groups of related reports identified by the Semantic Similarity Engine. |
| `moderation_queue` | Reports awaiting human review, with assignment and status tracking. |
| `verification_logs` | Audit trail of every verification action (website, document) independent of report-level logs. |
| `document_hashes` | Registry of known-genuine document hashes used for tamper/authenticity checks. |

Migrations for these tables should be added incrementally, one module at a time, rather than as a single large upfront migration — see [Development Roadmap](#development-roadmap).

## Future AI Roadmap

- **Deepfake detection** — extending Image Analysis to flag AI-generated or synthetically altered video/audio as those attack vectors reach CHEKKAM's user base.
- **Voice scam detection** — analysis of voice message submissions (common on WhatsApp) using speech-to-text ahead of the existing NLP pipeline.
- **Local language support** — expanding NLP coverage beyond English/French/Pidgin to additional local languages as usage data shows demand.
- **Adaptive machine learning** — incorporating moderator decisions as a feedback signal to improve classifier accuracy over time.
- **Federated learning** — worth evaluating only if CHEKKAM expands to partner institutions that cannot share raw report data directly; not a near-term priority.
- **Continuous model improvement** — scheduled re-evaluation of model/prompt performance against a held-out set of moderator-confirmed decisions.

## Development Roadmap

**Phase 1 — Foundation**
Core message analysis pipeline, `ai_reports`/`ai_predictions` tables, single `/api/ai/message` endpoint, rule-based fallback. (A first version of this already exists in `lib/ai/risk-analysis.ts`.)

**Phase 2 — OCR + NLP**
Document/image ingestion, OCR Engine, expanded NLP entity extraction, `ocr_results` table, `/api/ai/ocr` and `/api/ai/document` endpoints.

**Phase 3 — Fraud Detection**
Scam Classification Engine, Semantic Similarity Engine, `scam_campaigns` table, `/api/ai/campaigns` endpoint, Website Verification module.

**Phase 4 — Moderator Dashboard**
`moderation_queue` workflows, moderator UI for reviewing AI output with full explainability, audit logging, `verification_logs` table.

**Phase 5 — Production Optimization**
Caching, queue-based async processing for all AI-invoking endpoints, monitoring/alerting on fallback rate and latency, load testing.

## Code Standards

All AI code in this repository should follow:

- Clean Architecture — clear separation between controllers, services, repositories, and validators.
- SOLID principles.
- Type safety throughout (TypeScript strict mode, schema validation at every boundary, e.g. Zod).
- Comprehensive error handling — every external call (AI provider, OCR service) has a defined fallback or fails safely, never silently.
- Unit tests for pure logic (rule-based fallbacks, scoring functions).
- Integration tests for API endpoints and provider-facing code paths.
- API documentation kept current with the endpoint table above as new routes are added.
