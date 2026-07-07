# Chekkam — Brand Guide

**Tagline:** One check. Total trust.
**Version:** 2.0 — warmed lagoon teal, Fraunces/Inter/Plex Mono type system, depth over flat fills
**Purpose:** This guide defines Chekkam's visual and verbal identity for two audiences: (1) designers/juror-facing materials (pitch deck, documents), and (2) developers implementing the actual product UI. Section 6 onward is written to be pasted directly into code.

> **What changed in v2.0:** The core identity — name, checkmark-in-circle mark, teal-as-trust hue family, and the "never color alone" accessibility rule — is unchanged; it was earned and still fits. What changed is execution: the teal is deepened for more gravity, one warm gold accent is added (used sparingly), a warm serif joins the type system for headlines and verdicts, radii and shadows are bigger and softer, and both the Flutter app and web dashboard now support a considered dark mode. See §12 for the full rationale.

---

## 1. Brand Story

**The name:** "Chekkam" is a deliberate, phonetic spelling close to the Cameroonian Pidgin phrase "check am" — "check it." It reads instantly in English and Pidgin, and is easy to say and remember in French-speaking contexts too. It signals the product's entire function in one word: check it, before you trust it.

**The one-line pitch:** Chekkam lets Cameroonians verify suspicious messages, official documents, and local safety information — one check, backed by AI analysis and human review, trusted by institutions and citizens alike.

**Brand personality:**

| We are | We are not |
|---|---|
| Calm and confident | Alarmist or fear-based |
| Clear and plain-spoken | Jargon-heavy or technical-sounding |
| Vigilant and thorough | Paranoid or accusatory |
| Empowering | Shaming (never blame a user for almost falling for a scam) |
| Multilingual and inclusive | English-only or elite-coded |
| Institutional-grade, trustworthy | Cold, bureaucratic, or corporate-generic |

**The two audiences, one seal:** Chekkam serves a citizen forwarding a suspicious WhatsApp message at 11pm, and a ministry registrar issuing an official certificate — often on the same day, in the same app. The visual language leans on the world of seals, certificates, and letterheads (§4) to earn institutional credibility, while staying warm, plain-spoken, and never cold or corporate for the everyday citizen.

---

## 2. Logo Concept

**Primary mark:** A checkmark inscribed inside a circle (or rounded shield silhouette as an optional variant for safety-related contexts). The circle reinforces "complete verification" — a check that closes a loop, not an open-ended tick mark.

**Lockups:**
- **Full lockup:** icon + wordmark "Chekkam," icon to the left, vertically centered against the cap-height of the wordmark.
- **Icon-only:** used for favicons, app icons, social avatars, and the browser extension toolbar icon.
- **Wordmark-only:** used in narrow horizontal spaces (e.g., email footers) where the icon would be too small to read.
- **Seal variant (new, v2):** the icon rendered inside a soft gradient ring (Bright Teal → Gold, §3.1) instead of a flat tint fill — reserved for high-stakes "verdict" moments: a document verification result, a signed-document confirmation. Never use the gradient ring for ordinary navigation/feature icons (§5).

**Clear space:** Maintain minimum clear space around the mark equal to the height of the checkmark itself on all sides. Do not let text, edges, or other graphics enter that space.

**Minimum size:** Icon-only version should never render below 20px (digital) or 8mm (print) — the checkmark inside the circle loses legibility below this.

**Don'ts:**
- Do not recolor the mark outside the approved palette (§3).
- Do not stretch, skew, or rotate the mark.
- Do not add drop shadows, bevels, or outer glows to the logo itself (the seal gradient ring, §2 above, is the one sanctioned exception, and only for verdict moments).
- Do not place the full-color mark on a busy photographic background — use the single-color (white or dark) variant instead.
- Do not recreate the checkmark by hand in a different weight/style than the approved icon set.

---

## 3. Color System

### 3.1 Brand palette

| Name | Hex (light) | Hex (dark) | Usage |
|---|---|---|---|
| **Lagoon** | `#073F3A` | `#0A2B27` | Hero/dark surfaces, sidebar, gradient anchor |
| **Primary Teal** | `#0E6C61` | `#45D2B7` | Primary actions, links, headings on light backgrounds |
| **Bright Teal** | `#2FB69C` | `#6EE7CB` | Hover/active states, gradient highlight |
| **Gold (sparing accent)** | `#C98A22` | `#F0BA57` | A seal's glow, one highlight per screen — never a whole section (§12) |
| **Ink (text)** | `#0F211D` | `#EAF3EF` | Body text, headings — a pine-tinted near-black, not generic slate |
| **Muted** | `#4C5E57` | `#A9BDB6` | Secondary text |
| **Faint** | `#7C8C86` | `#71857E` | Captions, placeholders, disabled states |
| **Surface** | `#FAFAF7` | `#081512` | Page background — warm-neutral, not stark white; deep lagoon-black in dark mode, never pure black |
| **Surface Raised** | `#FFFFFF` | `#0E211D` | Card fill |
| **Tint** | `#EFF4F1` | `#0B1B17` | Recessed sections, input fields |
| **Border** | `#DEE7E2` | `#1D3833` | Card/input borders — hairline, never heavy |

**Usage ratio guideline (60/30/10):** ~60% light/dark surface per theme, ~30% Ink/Muted text, ~10% Primary/Bright/Gold as intentional emphasis. Gold specifically should read as a *find* on the page, not a color you'd describe the page as being. If a screen has more than one gold element, pull it back.

### 3.2 Semantic / status colors

These are used for AI risk levels and document verification results, and are **deliberately distinct from both the brand accent colors and from Gold** to avoid ambiguity between "this is Chekkam-branded" and "this is a status result."

| Status | Hex (light) | Hex (dark) | Used for |
|---|---|---|---|
| **Success / Genuine / Low risk** | `#1E8E5A` | `#3FBE85` | Verified genuine documents, low-risk content |
| **Warning / Medium risk** | `#B5690F` | `#E2A33F` | Medium-risk content, pending review states |
| **Danger / Tampered / High-Critical risk** | `#C4392A` | `#F0685A` | Tampered documents, high/critical-risk content, rejected reports |
| **Neutral / Revoked / Not Found** | `#7C8C86` | `#7C8C86` | Revoked documents, not-found verification results, inactive states |

**Accessibility rule:** never rely on color alone to communicate a status. Every status color must be paired with an icon and a text label (e.g., a red badge that also says "Tampered," not just a red dot).

### 3.3 Gradients (new, v2)

Two named gradients, used deliberately and sparingly:

| Name | Stops | Usage |
|---|---|---|
| **Lagoon gradient** | Lagoon → Primary Teal, 135° | Hero sections, sidebar, primary CTA buttons, auth screens |
| **Seal gradient** | Bright Teal → Gold, 135° | The one "verdict" moment per screen — a genuine document's seal icon, a successful sign confirmation |

Gradients fade rather than shout — soft, not neon. Never use a gradient on body text or as a page-wide background wash.

---

## 4. Typography

Chekkam uses **three type systems** for three different contexts:

### 4.1 Product UI (Flutter app, web dashboard, browser extension)

| Role | Font | Notes |
|---|---|---|
| Display / headlines / verdicts | **Fraunces** (Google Fonts, variable) | A warm display serif that nods to certificates, seals, and letterheads — the world Chekkam's document-signing side lives in — instead of another geometric sans. Used with restraint: page titles, verdict words ("Genuine.", "Tampered."), big numerals. Weight 500–600; italic 400 reserved for tagline/quote moments. |
| Body & UI text | **Inter** (Google Fonts) | Highly legible on screen, excellent French accent/diacritic support, industry standard for trust & security products. Everything that isn't a headline or a code-like value. |
| Data / codes | **IBM Plex Mono** (Google Fonts, weight 500) | Verification IDs, PINs, timestamps — anything meant to be scanned character-by-character reads better tabular. |
| Fallback stack | `system-ui, -apple-system, sans-serif` (body), `Georgia, serif` (display) | For any environment where web fonts fail to load |

**Type scale (recommended, in rem, base 16px):**

| Level | Size | Weight | Font | Line height |
|---|---|---|---|---|
| H1 | 2.5rem (40px) | 600 | Fraunces | 1.08 |
| H2 | 1.9rem (30px) | 600 | Fraunces | 1.12 |
| H3 | 1.44rem (23px) | 600 | Fraunces | 1.2 |
| Title | 1.19rem (19px) | 600 | Fraunces | 1.3 |
| Body | 1rem (16px) | 400 | Inter | 1.5 |
| Small / caption | 0.875rem (14px) | 400 | Inter | 1.45 |
| Code / data | 0.875–1rem | 500 | IBM Plex Mono | 1.4 |

### 4.2 Print / pitch materials (deck, formal documents)

| Role | Font | Notes |
|---|---|---|
| Headings | **Cambria** | Serif, editorial, gives pitch documents a "designed," non-templated feel |
| Body text | **Calibri** | Clean, standard, widely available in Office/Google Docs |

Do not mix these two systems — Cambria/Calibri stays in slide decks and formal Word/PDF documents; Fraunces/Inter/Plex Mono stays in the actual running product.

---

## 5. Iconography

- **Style:** rounded-line icons, consistent stroke width. Flutter uses Material's rounded icon set; web uses **lucide-react** — do not mix icon styles from multiple libraries within one client.
- **Presentation:** icons sit inside a filled circle (Tint background, Primary Teal icon) for feature/navigation icons — this is Chekkam's signature visual motif, consistent across pitch materials and product UI. Reserve the gradient ring variant (§2) for verdict/seal moments only.
- **Status icons:** use semantic colors (§3.2) directly on the icon, not inside a tinted circle, to keep status indicators visually distinct from navigational/feature icons.
- Never use emoji as functional UI icons (acceptable only in informal chat-style contexts, e.g., a WhatsApp bot reply).

---

## 6. Voice & Tone

- **Plain language first.** Avoid jargon like "leverage," "synergy," "ecosystem" unless describing the technical architecture in a technical document.
- **Calm, not alarming.** Even a "Critical risk" result should be phrased as clear guidance ("This looks like a scam. Do not send money or share personal information.") rather than panic-inducing language.
- **Never shame the user.** No copy should imply the user was foolish for receiving or almost acting on a scam. Everyone is a target; that's the whole reason Chekkam exists.
- **Multilingual respect.** English, French, and Pidgin are all first-class — do not treat Pidgin as an informal afterthought translation; write it deliberately.
- **Action-oriented.** Every result screen tells the user what to do next, not just what was found.
- **Institutional trust, not corporate distance.** Copy should read as if written by a careful, competent public-interest organization — warm but precise, never cutesy or gimmicky given the seriousness of fraud/safety content.
- **Zero visual noise at high-stakes moments (new, v2).** A verification result or a sign confirmation gets one focal seal, one verdict word, and nothing else competing for attention — research on fintech trust signals is consistent that clarity at the moment of truth builds more confidence than any amount of supporting decoration.

---

## 7. UI Component Guidelines

- **Buttons:** Primary = Lagoon gradient fill (§3.3), white text, soft tinted shadow. Secondary = surface fill, Primary Teal border and text (outline style). Ghost/tertiary = Tint fill, Ink text, no border.
- **Cards:** Surface Raised background, hairline Border (§3.1), generously rounded corners (18–20px, up from v1's 12px), soft layered shadow instead of a visible border doing all the work (`shadow-sm`/`shadow-md`, §7.1).
- **Badges (status):** pill-shaped, semantic color background at ~12% opacity, full-opacity semantic color text/icon, always paired with a text label.
- **Border radius scale:** `10px` (small elements — inputs, small buttons), `18–20px` (cards), `24–26px` (hero panels), `9999px` (pills/badges). Do not mix arbitrary radius values.
- **Spacing scale:** stick to a 4px-based scale (4, 8, 12, 16, 24, 32, 48, 64px) for all padding/margin.

### 7.1 Depth (new, v2)

Flat Material-default cards read cold. Use three shadow levels, applied via the tokens in §10–11:

| Level | Use for |
|---|---|
| `shadow-sm` | Default card/input resting state |
| `shadow-md` | Hero cards, hover/active states, the institution-signing result panel |
| `shadow-lg` | The verify-result seal, modal/sheet surfaces |

Shadows should read as soft and diffuse (large blur, low opacity), never a hard drop shadow.

---

## 8. Accessibility

- Maintain **WCAG AA contrast** (4.5:1 minimum for body text) for all text/background combinations in both light and dark mode.
- Never encode meaning by color alone (§3.2).
- Minimum body text size: 16px (1rem) in the product UI; do not go smaller for primary content.
- All interactive elements (buttons, links, form fields) need visible focus states — do not remove default focus outlines without replacing them with an equally visible custom style.
- Both light and dark mode are first-class (§3.1); dark mode uses elevation via lighter surface tokens, never pure black, so depth stays legible.

---

## 9. Do's and Don'ts Summary

| Do | Don't |
|---|---|
| Use Lagoon/Teal as the dominant hue; Gold as one sparing accent | Let Gold dominate a screen, or use it for status meaning |
| Pair every status color with an icon + label | Rely on color alone to signal risk or verification status |
| Use Fraunces for headlines/verdicts, Inter for body/UI, Plex Mono for codes | Mix the print type system (Cambria/Calibri) into the product |
| Give high-stakes moments (verify result, sign confirmation) one focal element | Clutter a verdict screen with competing information |
| Use soft, layered shadows for depth | Use flat Material-default cards or hard drop shadows |
| Use one consistent icon library and motif (icon-in-circle) | Mix icon styles or use emoji as functional icons |
| Treat French and Pidgin as first-class content | Treat non-English copy as an afterthought translation |
| Support both light and dark mode with real elevation | Naively invert light-mode colors for dark mode |

---

## 10. Developer Reference — Tailwind / CSS (web dashboard)

The web dashboard (`chekkam-backend/app/globals.css`) defines these as CSS custom properties consumed by Tailwind v4's `@theme inline`:

```css
:root {
  --chekkam-lagoon: #073f3a;
  --chekkam-primary: #0e6c61;
  --chekkam-bright: #2fb69c;
  --chekkam-gold: #c98a22;

  --chekkam-ink: #0f211d;
  --chekkam-muted: #4c5e57;
  --chekkam-faint: #7c8c86;
  --chekkam-surface: #fafaf7;
  --chekkam-surface-raised: #ffffff;
  --chekkam-tint: #eff4f1;
  --chekkam-border: #dee7e2;

  --status-success: #1e8e5a;
  --status-warning: #b5690f;
  --status-danger: #c4392a;
  --status-neutral: #7c8c86;
}

@media (prefers-color-scheme: dark) {
  :root {
    --chekkam-lagoon: #0a2b27;
    --chekkam-primary: #45d2b7;
    --chekkam-bright: #6ee7cb;
    --chekkam-gold: #f0ba57;
    --chekkam-ink: #eaf3ef;
    --chekkam-muted: #a9bdb6;
    --chekkam-faint: #71857e;
    --chekkam-surface: #081512;
    --chekkam-surface-raised: #0e211d;
    --chekkam-tint: #0b1b17;
    --chekkam-border: #1d3833;
    --status-success: #3fbe85;
    --status-warning: #e2a33f;
    --status-danger: #f0685a;
  }
}
```

Radius tokens: `--radius-chekkam-sm: 10px`, `--radius-chekkam: 18px`, `--radius-chekkam-hero: 24px`.
Fonts loaded via `next/font/google` in `app/layout.tsx`: Fraunces (`--font-fraunces`), Inter (`--font-sans`), IBM Plex Mono (`--font-mono`) — see `--font-heading`/`--font-body`/`--font-data` in `globals.css`.
Gradient utilities: `.bg-gradient-lagoon`, `.bg-gradient-seal` (§3.3). Shadow utilities: `.shadow-chekkam-sm/md/lg` (§7.1).

## 11. Developer Reference — Flutter (`chekkam/lib/app/theme.dart`)

`ChekkamColors`, `ChekkamSpacing`, `ChekkamRadius`, and `ChekkamShadows` in `lib/app/theme.dart` are the single source of truth — every screen reads from these, never a hardcoded hex. Headings use `ChekkamTheme.display(...)` (Fraunces); verification codes use `ChekkamTheme.mono(...)` (IBM Plex Mono); everything else flows through `ChekkamTheme.light`'s `TextTheme` (Inter). `ChekkamColors.gradientHero` and `ChekkamColors.gradientSeal` correspond to the Lagoon and Seal gradients in §3.3.

---

## 12. Why v2 (research rationale)

Grounded in 2026 fintech/trust-product design research, not just taste:

- **Zero visual noise in high-stakes moments** builds more trust than supporting decoration — hence the seal-moment redesign of the verify result and sign-confirmation screens (§6).
- **Intent-first navigation** — surfacing the one thing a user came to do, immediately — is why the Flutter home screen leads with a single "paste to check" action instead of an equal-weight list of five pillars.
- **2026 palettes favor soft gradients that fade rather than shout, muted grounds, and dark modes with true elevation instead of near-black** — hence the Lagoon/Seal gradients (§3.3), the warm-neutral Surface tokens instead of stark white, and dark mode's lighter-not-pure-black surfaces.

---

*Companion documents: `Chekkam_Project_Overview.md`, `Chekkam_Software_Requirements_Specification.md`, `Chekkam_Phase2_Build_Spec.md`.*
