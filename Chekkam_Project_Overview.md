# Chekkam — Project Overview

**Tagline:** One check. Total trust.
**Prepared for:** National Competition for the Best ICT Project — 5th Edition, ICT Innovation Week, Ministry of Posts and Telecommunications (MINPOSTEL), Cameroon
**Competition theme:** *"Protecting Cyberspace from the Misuse of Artificial Intelligence and Promoting Digital Patriotism"*
**Date:** July 2026

> **Note on figures in this document:** Where exact Cameroon-specific statistics were not independently verifiable, this document says so explicitly and uses conservative, clearly-labeled estimates instead of invented precision. Replace bracketed `[TO CONFIRM]` items with real figures/sources before final submission wherever you can — jurors credit honesty over false precision.

---

## 1. Snapshot

| | |
|---|---|
| **What it is** | A national digital-trust platform that lets citizens verify suspicious messages, lets institutions cryptographically sign official documents, lets organizations embed verification via API, and lets communities report and receive alerts about local safety incidents. |
| **Why it matters** | Cameroonians conduct daily life over WhatsApp, Facebook, SMS, and email — channels with no built-in way to check if a sender, document, or offer is genuine. Forged certificates, scams, and misinformation exploit that gap. |
| **What makes it different** | Not a single-purpose tool. It connects citizen reporting, AI-assisted risk analysis, institutional document signing, an embeddable API, and community safety alerts into one accountable trust infrastructure, with mandatory human review before anything is published. |
| **Proven precedent** | Modeled in part on Kenya's KNEC signed-QR-code certificate system and Nigeria's WAEC/NYSC PIN-based verification portals — bringing both models into one platform, open to any Cameroonian institution. |

---

## 2. Competition Alignment (Read This First)

This section exists for one reason: to make it effortless for a juror to find, for every point on the rubric, exactly where Chekkam earns it. Everything after this section builds out the evidence.

### 2.1 Pre-selection criteria (100 pts) — project document

| # | Criterion | Pts | Where Chekkam earns it |
|---|---|---|---|
| 1 | Relevance of the project | 20 | §3 Problem Statement — three concrete, named failure modes (scams, document forgery, fragmented response) affecting citizens, businesses, and public institutions directly |
| 2 | Innovative nature of the solution | 15 | §5 Competitive Positioning — no existing Cameroonian platform unifies scam detection, document authentication, an embeddable API, and safety alerts; each pillar individually has precedent abroad but not combined, and not in Cameroon |
| 3 | Technical feasibility | 15 | §8 Contest Demo Scope — a deliberately narrow, honestly-scoped slice built on mature, well-documented technology (Supabase, Next.js, standard cryptographic signing), not unproven research |
| 4 | Socio-economic impact | 15 | §6 Expected Impact — citizen financial protection, institutional document integrity, and ties to Cameroon's national digital-economy priorities (§7) |
| 5 | Business model and sustainability | 10 | §9 Business Model & Financial Outlook — free citizen tier, paid institutional/API tiers, 3-year illustrative projection |
| 6 | Use of AI in the proposed solution | 10 | §4 pillar 1 and pillar 2 — AI performs risk scoring, explanation, cross-language campaign matching, and OCR-assisted document matching; justified in the SRS §7 with what the AI decides and why rules alone are insufficient |
| 7 | Contribution to digital patriotism and cybersecurity | 15 | This is Chekkam's structural core, not an add-on: cryptographic document integrity, data-minimized design, and a platform built explicitly to fight cybercrime and disinformation in Cameroon — see §7 |

### 2.2 Final pitch criteria (100 pts) — before the Grand Jury

| # | Criterion | Pts | Where Chekkam earns it |
|---|---|---|---|
| 1 | Quality of pitch and command of project | 10 | Pitch talk script and anticipated Q&A — see the companion pitch materials |
| 2 | Innovative nature and differentiation | 20 | Same as pre-selection #2, sharpened for live delivery |
| 3 | **Demonstration of product/prototype** | 20 | §8 Contest Demo Scope defines exactly what will run live, and a recorded fallback for anything network-dependent (WhatsApp/AI API calls) |
| 4 | Socio-economic impact and value for Cameroon | 20 | §6 + §7, with a direct tie to NDS30 and the Digital Cameroon Strategic Plan's "strengthening digital trust" pillar |
| 5 | Economic viability and business model | 10 | §9 |
| 6 | Scalability and deployment strategy | 10 | §10 Roadmap — phased pilot-to-national path with realistic infrastructure scaling |
| 7 | Contribution to digital sovereignty, AI and cybersecurity | 10 | §7, restated for the demo: local-first data posture, transparent AI use, cryptographic trust |

**Honest self-assessment:** Chekkam has structural coverage of all 14 criteria across both stages — most competing projects will only touch two or three naturally. The remaining work (tracked in the SRS and this document) is converting that coverage from *claims* into *evidence*: real numbers, a named team, a financial projection, and — the single highest-weighted item in the whole competition — a working demo for criterion 3. Breadth without proof will not outscore a narrower project that proves everything it claims.

---

## 3. Problem Statement

1. **Scams & impersonation** — fake recruitment, scholarship scams, mobile-money fraud, and phishing links spread across English, French, and Pidgin, frequently impersonating real institutions or officials.
2. **Document forgery** — certificates, admission letters, payslips, contracts, and civil-status documents are altered, then photographed, scanned, or forwarded repeatedly, with no practical way for a recipient to check them.
3. **Fragmented response** — cybercrime tiplines, fact-checkers, and institutions each act alone. No shared registry connects an individual report to a wider pattern, or a document to its issuing institution.
4. **No embeddable trust layer** — banks, telecoms, schools, and government offices have no simple way to plug a verification capability into their own systems.
5. **Weak local safety information flow** — information about an unfolding local incident spreads informally, with no structured way to reach nearby residents quickly or route a credible report to the right authority.

*[TO CONFIRM before final submission: any real Cameroon-specific statistics you or your team can source — e.g., MINPOSTEL/ANTIC cybercrime reports, mobile money fraud figures from operators, or GSMA regional fraud data. Concrete local numbers here would meaningfully strengthen criterion 1 (Relevance, 20 pts) — the single highest-weighted pre-selection criterion.]*

---

## 4. The Solution — Five Pillars

| Pillar | What it does | Precedent it builds on | AI role |
|---|---|---|---|
| **1. Verify Messages & Media** | Citizens submit suspicious text, links, screenshots, or files. AI risk analysis explains the result; a campaign engine groups repeated scams across languages and formats. | National cybercrime tiplines and fact-checking initiatives across Africa | Risk scoring, category classification, explanation generation, cross-language similarity matching |
| **2. Verify Documents** | Institutions cryptographically sign outgoing official documents with an embedded QR code and/or PIN. Anyone — including someone holding a photocopy or forwarded scan — can check it instantly. | Kenya's KNEC signed-QR certificate system; Nigeria's WAEC PIN-based result verification and NYSC verification portal | OCR-assisted matching for photographed/rescanned copies |
| **3. Verify Everywhere** | A browser extension and WhatsApp channel let people check a link, page, or forwarded message where they already are, on an opt-in basis. | Browser-based phishing/safe-browsing checks | Reuses pillar 1's engine |
| **4. Verify at Scale** | A documented public API lets banks, telecoms, schools, and government agencies embed content and document verification directly into their own systems. | KYC/identity-verification API models used by African fintech and onboarding platforms | Reuses pillars 1 & 2's engines |
| **5. Protect Communities** | A moderated safety-alert channel lets people report an ongoing local incident; verified alerts reach nearby opted-in users and a designated authority liaison — alongside, never instead of, emergency services. | Community safety-alert apps used in South Africa and the United States | None required for MVP (human-moderated by design) |

All five pillars share one verification engine and one rule: **nothing is published, revoked, or sent to the public without human analyst approval.**

---

## 5. Competitive Positioning

| Capability | Typical single-purpose tool (Cameroon/regional) | Chekkam |
|---|---|---|
| Citizen scam reporting | Cybercrime tiplines exist, isolated | Linked to detected campaigns |
| Institutional document signing | Rare, siloed to individual bodies (e.g., exam boards abroad) | Open to any institution, one shared registry |
| Embeddable verification API | Not available to Cameroonian organizations today `[TO CONFIRM]` | Yes |
| Browser-based checking | Not available for Cameroon-specific scams `[TO CONFIRM]` | Yes |
| Community safety alerts | No unified national platform `[TO CONFIRM]` | Same trust infrastructure as everything else |
| Human review before publishing | Varies | Always required |

*[TO CONFIRM: if your team is aware of any existing Cameroonian competitor or near-competitor, name it here — jurors will know the landscape, and acknowledging a competitor by name and explaining the differentiation is more credible than implying nothing exists.]*

---

## 6. Expected Impact

| Audience | Impact | Illustrative estimate |
|---|---|---|
| Citizens & families | Fewer losses to mobile-money fraud, fake recruitment, and scholarship scams | `[TO CONFIRM — e.g., "X reports processed in pilot phase, protecting an estimated Y users"]` |
| Institutions | Protected document integrity, fewer disputes and fraud investigations | Pilot with 2–3 institutions in Phase 1 |
| Authorities | Structured evidence and trend visibility instead of isolated complaints | Aggregated, anonymized campaign data |
| The economy | Faster verification, stronger trust in digital transactions and services | Ties to Cameroon's digital-sector growth priorities (see §7) |

Where you don't yet have real pilot numbers, it is more credible to present a **modeled estimate with stated assumptions** (e.g., "assuming X% of Y million WhatsApp users in Cameroon encounter at least one scam attempt per year, a Z% reduction in successful fraud attempts driven by a national verification habit would represent...") than to state a number with no visible basis. The SRS demo should be built so at least one real number (e.g., reports processed during the bootcamp) can be quoted live at the pitch.

---

## 7. Alignment with National Digital Priorities

Chekkam is not positioned as a add-on to government priorities — its core function overlaps directly with stated national strategy:

- **Digital Cameroon Strategic Plan** names *"strengthening digital trust: ensuring cybersecurity and data protection"* as one of its explicit pillars — this is Chekkam's entire premise, not a side benefit.
- **NDS30 (National Development Strategy 2020–2030)** projects continued digital-sector growth and treats digital technology as a priority transformation sector; Cameroon's ICT sector contribution to GDP has been reported at approximately 5% (2024, Minpostel), with strategic ambition to grow it further.
- **Cameroon's National AI Strategy** targets training 60,000 AI professionals and creating 12,000 direct jobs by 2040, with an AI-driven contribution to GDP targeted at 0.8–1.2%. Chekkam's use of AI for risk analysis and campaign detection is a direct, applied example of the kind of "AI for national benefit" this strategy is meant to produce — not AI adopted for its own sake.

This gives Chekkam a legitimate, sourced answer to "why does this matter to Cameroon specifically" beyond the project's own narrative — worth stating explicitly and confidently in the pitch, criterion 7 in both stages (15 pts pre-selection, 10 pts final).

---

## 8. Contest Demo Scope (Distinct from the Long-Term MVP)

The competition calendar is tight. From the rules: registration closes **22 July 2026**, the pre-selected list is published **24 July**, the bootcamp runs **27–29 July**, and the final pitch is **30 July 2026**. Counting from today, that leaves a narrow, real window to have something demonstrable — and "demonstration of product/prototype" is worth 20 of 100 points in the final stage, the single heaviest-weighted line item in the entire competition.

**This document deliberately separates two things that must not be confused:**

1. **The Contest Demo Scope** — what will actually run live, end to end, in front of the jury.
2. **The Phase 1 MVP / long-term roadmap** (§10) — the fuller vision, clearly marked as post-contest.

> **Action needed from the team before the SRS demo section is finalized:** confirm team size and hours available between now and 27 July. The recommendation below assumes a small team (2–4 developers) working part-to-full-time for roughly three weeks — adjust if that's inaccurate.

**Recommended demo scope (highest confidence-to-effort ratio first):**

| Priority | Feature | Why it's in scope for the demo |
|---|---|---|
| 1 | **Document Authentication** (Pillar 2) — sign a sample document, generate QR + verification ID, scan/upload to verify Genuine/Tampered/Revoked | Visually striking, directly demonstrates cryptography + AI-adjacent OCR, maps to the highest-weight criteria (demo, innovation, digital sovereignty) with the least dependency on unpredictable third-party APIs |
| 2 | **Verify Messages & Media** (Pillar 1) — submit a suspicious message/link, get an AI-generated risk score and explanation live | Directly demonstrates the "use of AI" criterion with visible, explainable output |
| 3 | Public alert page showing a sample verified alert | Cheap to build, shows the "human review before publishing" principle visually |
| Represented but not fully live | Browser extension, Partner API, Safety Alerts | Show as a working prototype/mockup with a clear "next phase" label rather than pretending they are production-ready — jurors respect honest scoping over overreach |

**Fallback plan:** record a short backup video of every live demo flow in advance. If venue Wi-Fi or a third-party API (OpenAI, WhatsApp) fails during the pitch, switch to the recording without losing momentum — never let the demo criterion (20 pts) depend entirely on live network conditions.

Full technical detail for the demo build — schema, API contracts, algorithms — is in the companion **Chekkam Software Requirements Specification**.

---

## 9. Business Model & Financial Outlook

| Tier | Model | Covers |
|---|---|---|
| Citizen | Free, indefinitely | Reporting, risk checks, document verification, safety alerts |
| Institutional | Per-document / subscription | Signed-document issuance at volume |
| Partner API | Usage-based | Embedded verification for banks, telecoms, organizations |
| Grants / pilot funding | Time-limited | Hosting, AI costs, core team through early pilots |

**Illustrative 3-year outlook** *(label explicitly as illustrative in the submission — replace with real projections once you have them)*:

| Year | Institutional partners (est.) | API partners (est.) | Revenue driver | Notes |
|---|---|---|---|---|
| Year 1 | 2–5 (pilot) | 0–1 | Grant/pilot funding | Focused on proving the model, not revenue |
| Year 2 | 10–20 | 2–5 | Per-document fees + early API usage fees | Break-even target dependent on institutional adoption pace |
| Year 3 | 30+ | 10+ | Subscription + usage-based API revenue | Scale phase, contingent on Phase 2/3 roadmap execution |

The citizen-facing core stays free indefinitely — it is the trust-building foundation of the platform and must not be paywalled, even once institutional revenue exists.

---

## 10. Roadmap (Post-Contest)

| Phase | Timeframe | Focus |
|---|---|---|
| Contest demo | Now – 30 July 2026 | See §8 |
| Phase 1 (MVP) | 0–4 months post-contest | Reporting portal, AI risk analysis, document-signing pilot (2–3 institutions), browser extension MVP, safety tipline in one pilot area |
| Phase 2 | 4–8 months | Analyst dashboard maturity, public alert page, trusted-source registry, expanded institution onboarding |
| Phase 3 | 8–12 months | Full API partner program, evidence-intelligence tooling, law-enforcement liaison integration |
| Phase 4+ | 12+ months | Mobile app, wider geographic rollout, independent security review, national deployment discussions |

---

## 11. Target Users & Roles

| Role | Description |
|---|---|
| Citizen / Public Visitor | Reports suspicious content, checks a document, receives alerts. No account required for basic checks. |
| Analyst | Reviews reports, documents, and safety alerts; verifies campaigns; approves or rejects before publication. |
| Institution Officer | Manages an institution's verified profile, signs and revokes documents, responds to impersonation reports. |
| API Partner | An organization (bank, telecom, school) with an API key, embedding verification into its own systems. |
| Law-Enforcement Liaison | Receives escalated, serious safety-alert reports and evidence packages through an agreed process. |
| Admin / Super Admin | Manages users, trusted sources, platform settings, and sensitive data access. |

---

## 12. Team

*[REQUIRED by the competition rules (Article 5.1) and currently missing — this section must be completed before registration. For each member, provide: full name, role on the project, one to two lines of relevant background, and Cameroonian nationality/residency confirmation, per Article 5's eligibility conditions.]*

| Name | Role | Background |
|---|---|---|
| `[TO ADD]` | `[e.g., Team Lead / Founder]` | `[TO ADD]` |
| `[TO ADD]` | `[e.g., Lead Developer]` | `[TO ADD]` |
| `[TO ADD]` | `[e.g., AI/Backend Developer]` | `[TO ADD]` |
| `[TO ADD]` | `[e.g., Design/Frontend]` | `[TO ADD]` |

---

## 13. Success Metrics (KPIs)

- Reports processed, campaigns identified, time from first report to public alert
- Documents signed, verifications performed, tampered/revoked cases correctly caught
- API partners onboarded, verification calls served
- Safety alerts sent, users reached within radius, liaison escalations
- Repeat usage and institutional renewal rate after pilot

---

## 14. Risks & Safeguards (Summary)

- No public alert, document revocation, or safety notification without human analyst approval
- No public accusation of a named individual without verified, legally appropriate evidence
- Safety alerts always labeled as a community information channel, never an emergency-dispatch replacement
- Location data collected only with explicit consent, minimized, and time-limited
- Rate-limiting and audit logs to prevent abuse of reporting and alert systems

Full detail is in the SRS, Section 12 (Security, Privacy & Legal Safety).

---

## 15. Glossary

| Term | Meaning |
|---|---|
| Campaign | A group of related reports describing the same scam, false claim, or harmful pattern |
| Document Signature | A cryptographic hash of a document, signed with the issuing institution's private key |
| Verification ID | The unique code (encoded in a QR and/or usable as a PIN) used to look up a signed document |
| Evidence Intelligence | File hashes, metadata, OCR text, and similarity indicators supporting review |
| Trusted Source | A verified official website, page, institution profile, or media source |
| Public Alert | A human-approved warning published for citizens after verification |
| Safety Alert | A human-moderated, location-tagged community notification about a local incident |
| API Partner | An organization issued an API key to embed Chekkam verification into its own systems |

---

*Companion documents: `Chekkam_Software_Requirements_Specification.md`, `Chekkam_Brand_Guide.md`.*
