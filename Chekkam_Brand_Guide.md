# Chekkam — Brand Guide

**Tagline:** One check. Total trust.
**Version:** 3.0 — bold red/maroon/ink identity (client-directed palette change), Fraunces/Inter/Plex Mono type system carried over
**Purpose:** This guide defines Chekkam's visual and verbal identity for two audiences: (1) designers/juror-facing materials (pitch deck, documents), and (2) developers implementing the actual product UI. Section 6 onward is written to be pasted directly into code.

> **What changed in v3.0:** The palette changed completely, on direct client instruction: out with the teal/gold "calm trust" direction, in with a bold red/maroon/near-black/near-white identity — vivid, urgent-feeling, unmistakable. Everything else — the name, the checkmark-in-circle mark, the type system (Fraunces for verdicts, Inter for body, IBM Plex Mono for codes), the "never color alone" accessibility rule, the seal-moment high-stakes screens — carries over unchanged. See §12 for how the semantic-color conflict this creates (red is now both the brand color and, historically, the "danger" status color) is resolved.

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

**A bolder register, same voice.** The v3 palette is more urgent and attention-grabbing than v2's teal — that's deliberate and matches a platform whose entire job is "stop and check before you trust this." The voice (§6) stays exactly as calm, plain-spoken, and non-alarmist as before — boldness lives in the color system, never in the copy.

---

## 2. Logo Concept

**Primary mark:** A checkmark inscribed inside a circle (or rounded shield silhouette as an optional variant for safety-related contexts). The circle reinforces "complete verification" — a check that closes a loop, not an open-ended tick mark.

**Lockups:**
- **Full lockup:** icon + wordmark "Chekkam," icon to the left, vertically centered against the cap-height of the wordmark.
- **Icon-only:** used for favicons, app icons, social avatars, and the browser extension toolbar icon.
- **Wordmark-only:** used in narrow horizontal spaces (e.g., email footers) where the icon would be too small to read.
- **Seal variant:** the icon rendered inside a gradient ring (Primary Red → Ink, §3.3) instead of a flat tint fill — reserved for high-stakes "verdict" moments: a document verification result, a signed-document confirmation. Reads like a wax seal on an official document. Never use the gradient ring for ordinary navigation/feature icons (§5).

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

Client-supplied, used exactly as given:

| Name | Hex (light) | Hex (dark) | Usage |
|---|---|---|---|
| **Maroon** | `#68020F` | `#4A0209` | Hero/dark surfaces, sidebar, gradient anchor, danger status (§3.2) |
| **Primary Red** | `#F21137` | `#FF3B5C` | Primary actions, links, headings on light backgrounds |
| **Bright Red** | `#FF3355` | `#FF6B85` | Hover/active states, gradient highlight |
| **Ink (text)** | `#030303` | `#FFFFFE` | Body text, headings — true near-black, not a tinted slate |
| **Muted** | `#4A4A4A` | `#C9C0C0` | Secondary text |
| **Faint** | `#8A8080` | `#8A8080` | Captions, placeholders, disabled states |
| **Surface** | `#FFFFFE` | `#030303` | Page background — near-white in light mode, true near-black in dark mode |
| **Surface Raised** | `#FFFFFF` | `#141010` | Card fill |
| **Tint** | `#F7F1F1` | `#1F1414` | Recessed sections, input fields |
| **Border** | `#E8DEDE` | `#3A2626` | Card/input borders — hairline, never heavy |

**Usage ratio guideline (60/30/10):** ~60% light/dark surface per theme, ~30% Ink/Muted text, ~10% Primary/Bright Red as intentional emphasis. Red is bold by nature — that's the point of this palette — but it should still read as *the* accent on a page, not the page's background. Large surfaces stay white/near-black; red is for actions, links, and the seal moments.

### 3.2 Semantic / status colors

| Status | Hex (light) | Hex (dark) | Used for |
|---|---|---|---|
| **Success / Genuine / Low risk** | `#1E8E5A` | `#3FBE85` | Verified genuine documents, low-risk content |
| **Warning / Medium risk** | `#B5690F` | `#E2A33F` | Medium-risk content, pending review states |
| **Danger / Tampered / High-Critical risk** | `#68020F` (Maroon) | `#FF5C6E` | Tampered documents, high/critical-risk content, rejected reports |
| **Neutral / Revoked / Not Found** | `#7C7272` | `#9A8F8F` | Revoked documents, not-found verification results, inactive states |

**On reusing brand red for danger status:** v2 kept status colors strictly separate from brand accents specifically to avoid "is this branding or a warning?" ambiguity. v3's palette only gives one red family, so full separation isn't possible — the resolution is shade, not hue: **Primary Red (`#F21137`) is reserved for ordinary actions** (buttons, links, active nav), while **danger status uses Maroon (`#68020F`)** specifically, which is visually darker/more muted and never used for an ordinary button. This is a real but deliberate compromise — it still relies on shade discrimination, which is weaker than hue discrimination, so the accessibility rule below is now load-bearing rather than a backup:

**Accessibility rule (non-negotiable given §3.2's compromise): never rely on color alone to communicate a status.** Every status color must be paired with an icon and a text label (e.g., a badge that visibly says "Tampered," not just a colored dot) — every screen in this codebase already does this; keep it that way.

### 3.3 Gradients

Two named gradients, used deliberately and sparingly:

| Name | Stops | Usage |
|---|---|---|
| **Hero gradient** | Maroon → Primary Red, 135° | Hero sections, sidebar, primary CTA buttons, auth screens |
| **Seal gradient** | Primary Red → Ink, 135° | The one "verdict" moment per screen — a genuine document's seal icon, a successful sign confirmation. Deliberately evokes a wax seal on an official document. |

Text placed on the Seal gradient must be white — it crosses from vivid red into near-black, and only white holds contrast across the whole range.

---

## 4. Typography

Unchanged from v2 — the palette changed, the type system didn't.

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
- **Presentation:** icons sit inside a filled circle (Tint background, Primary Red icon) for feature/navigation icons — this is Chekkam's signature visual motif, consistent across pitch materials and product UI. Reserve the gradient ring variant (§2) for verdict/seal moments only.
- **Status icons:** use semantic colors (§3.2) directly on the icon, not inside a tinted circle, to keep status indicators visually distinct from navigational/feature icons.
- Never use emoji as functional UI icons (acceptable only in informal chat-style contexts, e.g., a WhatsApp bot reply).

---

## 6. Voice & Tone

- **Plain language first.** Avoid jargon like "leverage," "synergy," "ecosystem" unless describing the technical architecture in a technical document.
- **Calm, not alarming.** Even a "Critical risk" result should be phrased as clear guidance ("This looks like a scam. Do not send money or share personal information.") rather than panic-inducing language. This matters more, not less, now that the palette itself is bolder — the color can shout so the copy doesn't have to.
- **Never shame the user.** No copy should imply the user was foolish for receiving or almost acting on a scam. Everyone is a target; that's the whole reason Chekkam exists.
- **Multilingual respect.** English, French, and Pidgin are all first-class — do not treat Pidgin as an informal afterthought translation; write it deliberately.
- **Action-oriented.** Every result screen tells the user what to do next, not just what was found.
- **Institutional trust, not corporate distance.** Copy should read as if written by a careful, competent public-interest organization — warm but precise, never cutesy or gimmicky given the seriousness of fraud/safety content.
- **Zero visual noise at high-stakes moments.** A verification result or a sign confirmation gets one focal seal, one verdict word, and nothing else competing for attention.

---

## 7. UI Component Guidelines

- **Buttons:** Primary = Hero gradient fill (§3.3), white text, soft tinted shadow. Secondary = surface fill, Primary Red border and text (outline style). Ghost/tertiary = Tint fill, Ink text, no border.
- **Cards:** Surface Raised background, hairline Border (§3.1), generously rounded corners (18–20px), soft layered shadow instead of a visible border doing all the work (`shadow-sm`/`shadow-md`, §7.1).
- **Badges (status):** pill-shaped, semantic color background at ~12% opacity, full-opacity semantic color text/icon, always paired with a text label.
- **Border radius scale:** `10px` (small elements — inputs, small buttons), `18–20px` (cards), `24–26px` (hero panels), `9999px` (pills/badges). Do not mix arbitrary radius values.
- **Spacing scale:** stick to a 4px-based scale (4, 8, 12, 16, 24, 32, 48, 64px) for all padding/margin.

### 7.1 Depth

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
- Never encode meaning by color alone (§3.2) — this is especially important now that brand and danger share a hue family.
- Minimum body text size: 16px (1rem) in the product UI; do not go smaller for primary content.
- All interactive elements (buttons, links, form fields) need visible focus states — do not remove default focus outlines without replacing them with an equally visible custom style.
- Both light and dark mode are first-class (§3.1); dark mode uses elevation via lighter surface tokens, never pure black, so depth stays legible.
- Text placed on the Seal gradient (§3.3) must be white, never Ink or Maroon — both lose contrast against the gradient's red-to-black range.

---

## 9. Do's and Don'ts Summary

| Do | Don't |
|---|---|
| Use Primary Red for actions, Maroon specifically for danger status | Use the same red shade for an ordinary button and a "Tampered" badge |
| Pair every status color with an icon + label | Rely on color alone to signal risk or verification status |
| Use Fraunces for headlines/verdicts, Inter for body/UI, Plex Mono for codes | Mix the print type system (Cambria/Calibri) into the product |
| Give high-stakes moments (verify result, sign confirmation) one focal element | Clutter a verdict screen with competing information |
| Use soft, layered shadows for depth | Use flat Material-default cards or hard drop shadows |
| Use one consistent icon library and motif (icon-in-circle) | Mix icon styles or use emoji as functional icons |
| Treat French and Pidgin as first-class content | Treat non-English copy as an afterthought translation |
| Support both light and dark mode with real elevation | Naively invert light-mode colors for dark mode |
| Use white text on the Seal gradient | Use Ink or Maroon text on the Seal gradient (contrast failure) |

---

## 10. Developer Reference — Tailwind / CSS (web dashboard)

The web dashboard (`chekkam-backend/app/globals.css`) defines these as CSS custom properties consumed by Tailwind v4's `@theme inline`. Token names (`lagoon`, `bright`) are kept from v2 for code continuity — only their values changed:

```css
:root {
  --chekkam-lagoon: #68020f;   /* Maroon */
  --chekkam-primary: #f21137;  /* Primary Red */
  --chekkam-bright: #ff3355;   /* Bright Red */

  --chekkam-ink: #030303;
  --chekkam-muted: #4a4a4a;
  --chekkam-faint: #8a8080;
  --chekkam-surface: #fffffe;
  --chekkam-surface-raised: #ffffff;
  --chekkam-tint: #f7f1f1;
  --chekkam-border: #e8dede;

  --status-success: #1e8e5a;
  --status-warning: #b5690f;
  --status-danger: #68020f;
  --status-neutral: #7c7272;
}

@media (prefers-color-scheme: dark) {
  :root {
    --chekkam-lagoon: #4a0209;
    --chekkam-primary: #ff3b5c;
    --chekkam-bright: #ff6b85;
    --chekkam-ink: #fffffe;
    --chekkam-muted: #c9c0c0;
    --chekkam-faint: #8a8080;
    --chekkam-surface: #030303;
    --chekkam-surface-raised: #141010;
    --chekkam-tint: #1f1414;
    --chekkam-border: #3a2626;
    --status-success: #3fbe85;
    --status-warning: #e2a33f;
    --status-danger: #ff5c6e;
    --status-neutral: #9a8f8f;
  }
}
```

Radius tokens: `--radius-chekkam-sm: 10px`, `--radius-chekkam: 18px`, `--radius-chekkam-hero: 24px`.
Fonts loaded via `next/font/google` in `app/layout.tsx`: Fraunces (`--font-fraunces`), Inter (`--font-sans`), IBM Plex Mono (`--font-mono`) — see `--font-heading`/`--font-body`/`--font-data` in `globals.css`.
Gradient utilities: `.bg-gradient-lagoon` (Hero gradient), `.bg-gradient-seal` (Seal gradient, §3.3). Shadow utilities: `.shadow-chekkam-sm/md/lg` (§7.1).

## 11. Developer Reference — Flutter (`chekkam/lib/app/theme.dart`)

`ChekkamColors`, `ChekkamSpacing`, `ChekkamRadius`, and `ChekkamShadows` in `lib/app/theme.dart` are the single source of truth — every screen reads from these, never a hardcoded hex. Named tokens: `maroon`, `primary`, `brightRed`, `ink`, `muted`, `faint`, `surface`, `surfaceRaised`, `tint`, `border`. Headings use `ChekkamTheme.display(...)` (Fraunces); verification codes use `ChekkamTheme.mono(...)` (IBM Plex Mono); everything else flows through `ChekkamTheme.light`'s `TextTheme` (Inter). `ChekkamColors.gradientHero` and `ChekkamColors.gradientSeal` correspond to the Hero and Seal gradients in §3.3.

## 12. Why the danger/brand color compromise is acceptable

The client-supplied palette (§3.1) has exactly one red family and no separate hue for "danger." v2's rule — status colors must be a different hue from brand accents — can't be fully honored under this palette. The mitigation:

1. **Shade separation, not hue separation.** Primary Red (`#F21137`) for actions, Maroon (`#68020F`) for danger — visibly different in isolation, even if both are "red."
2. **The icon + label rule becomes load-bearing, not a backup.** Every status badge in the codebase already pairs a semantic color with an icon and a text label (`StatusBadge` in Flutter, the pill pattern in the web dashboard) — this was always the accessibility rule (§3.2/§8), but under this palette it's the *primary* disambiguator, not a redundant one.
3. **Danger only appears in status contexts**, never as a general-purpose UI accent — so a maroon element on screen is reliably "something is wrong here," even without reading the label.

If a future design pass wants stricter hue separation, the fix is a palette addition (e.g., a distinct danger hue), not a rule change — §3.2's accessibility rule stays as strict as it's ever been.

---

*Companion documents: `Chekkam_Project_Overview.md`, `Chekkam_Software_Requirements_Specification.md`, `Chekkam_Phase2_Build_Spec.md`.*
