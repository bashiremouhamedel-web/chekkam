# Chekkam — Brand Guide

**Tagline:** One check. Total trust.
**Version:** 1.0
**Purpose:** This guide defines Chekkam's visual and verbal identity for two audiences: (1) designers/juror-facing materials (pitch deck, documents), and (2) developers implementing the actual product UI. Section 6 onward is written to be pasted directly into code.

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

---

## 2. Logo Concept

**Primary mark:** A checkmark inscribed inside a circle (or rounded shield silhouette as an optional variant for safety-related contexts). The circle reinforces "complete verification" — a check that closes a loop, not an open-ended tick mark.

**Lockups:**
- **Full lockup:** icon + wordmark "Chekkam," icon to the left, vertically centered against the cap-height of the wordmark.
- **Icon-only:** used for favicons, app icons, social avatars, and the browser extension toolbar icon.
- **Wordmark-only:** used in narrow horizontal spaces (e.g., email footers) where the icon would be too small to read.

**Clear space:** Maintain minimum clear space around the mark equal to the height of the checkmark itself on all sides. Do not let text, edges, or other graphics enter that space.

**Minimum size:** Icon-only version should never render below 20px (digital) or 8mm (print) — the checkmark inside the circle loses legibility below this.

**Don'ts:**
- Do not recolor the mark outside the approved palette (§3).
- Do not stretch, skew, or rotate the mark.
- Do not add drop shadows, bevels, or outer glows to the logo itself.
- Do not place the full-color mark on a busy photographic background — use the single-color (white or dark) variant instead.
- Do not recreate the checkmark by hand in a different weight/style than the approved icon set.

---

## 3. Color System

### 3.1 Brand palette

| Name | Hex | Usage |
|---|---|---|
| **Primary Teal** | `#028090` | Headings, primary icons on light backgrounds, primary buttons |
| **Secondary Seafoam** | `#00A896` | Full-color panels (hero sections, title/closing slides), secondary buttons, active states |
| **Accent Mint** | `#02C39A` | Sparingly — highlights, hover states, small accents only |
| **Ink (text)** | `#1E293B` | Body text, headings on white backgrounds |
| **Muted Slate** | `#64748B` | Secondary text, captions, placeholders |
| **Tint (card fill)** | `#E9F5F4` | Card backgrounds, icon-circle fills, subtle section backgrounds |
| **Tint 2 (section bg)** | `#F5FAF9` | Alternating section backgrounds, very light distinction from pure white |
| **White** | `#FFFFFF` | Primary background — Chekkam is a *light* brand; avoid large dark/black surfaces |

**Usage ratio guideline (60/30/10):** ~60% white/light backgrounds, ~30% Ink text and Muted Slate, ~10% Primary/Secondary/Accent color as intentional emphasis. If a screen feels heavy or dark, it's off-brand — pull color back, not text.

### 3.2 Semantic / status colors

These are used for AI risk levels and document verification results, and are **deliberately distinct from the brand accent colors** to avoid ambiguity between "this is a Chekkam-branded thing" and "this is a status result."

| Status | Hex | Used for |
|---|---|---|
| **Success / Genuine / Low risk** | `#16A34A` (green) | Verified genuine documents, low-risk content |
| **Warning / Medium risk** | `#F59E0B` (amber) | Medium-risk content, pending review states |
| **Danger / Tampered / High-Critical risk** | `#DC2626` (red) | Tampered documents, high/critical-risk content, rejected reports |
| **Neutral / Revoked / Not Found** | `#64748B` (slate) | Revoked documents, not-found verification results, inactive states |

**Accessibility rule:** never rely on color alone to communicate a status. Every status color must be paired with an icon and a text label (e.g., a red badge that also says "Tampered," not just a red dot).

---

## 4. Typography

Chekkam uses **two different type systems** for two different contexts — this is intentional, not inconsistent:

### 4.1 Product UI (web app, browser extension, dashboards)

| Role | Font | Notes |
|---|---|---|
| Headings | **Sora** or **Poppins** (Google Fonts) | Geometric, modern, trustworthy without feeling cold |
| Body text | **Inter** (Google Fonts) | Highly legible on screen, excellent French accent/diacritic support, industry standard for trust & security products |
| Fallback stack | `system-ui, -apple-system, sans-serif` | For any environment where web fonts fail to load |

**Type scale (recommended, in rem, base 16px):**

| Level | Size | Weight | Line height |
|---|---|---|---|
| H1 | 2.5rem (40px) | 700 | 1.15 |
| H2 | 2rem (32px) | 700 | 1.2 |
| H3 | 1.5rem (24px) | 600 | 1.25 |
| H4 | 1.25rem (20px) | 600 | 1.3 |
| Body | 1rem (16px) | 400 | 1.5 |
| Small / caption | 0.875rem (14px) | 400 | 1.4 |

### 4.2 Print / pitch materials (deck, formal documents)

| Role | Font | Notes |
|---|---|---|
| Headings | **Cambria** | Serif, editorial, gives pitch documents a "designed," non-templated feel |
| Body text | **Calibri** | Clean, standard, widely available in Office/Google Docs |

Do not mix these two systems — Cambria/Calibri stays in slide decks and formal Word/PDF documents; Sora/Inter stays in the actual running product.

---

## 5. Iconography

- **Style:** rounded-line icons, consistent stroke width. Recommended library: **lucide-react** (already available in the tech stack) — do not mix icon styles from multiple libraries.
- **Presentation:** icons sit inside a filled circle (Tint color `#E9F5F4` background, Primary Teal `#028090` icon) for feature/navigation icons — this is Chekkam's signature visual motif, consistent across pitch materials and product UI.
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

---

## 7. UI Component Guidelines

- **Buttons:** Primary = Primary Teal fill, white text. Secondary = white fill, Primary Teal border and text (outline style).
- **Cards:** white or Tint background, subtle 1px border (`#E2E8E7` or similar), rounded corners (`rounded-xl`, ~12px radius), soft shadow (`shadow-sm`/`shadow-md` — normal web shadows are fine; this constraint does not apply outside static office/slide exports, where heavy shadow effects can cause rendering issues in some tools).
- **Badges (status):** pill-shaped, semantic color background at ~10–15% opacity, full-opacity semantic color text/icon, always paired with a text label.
- **Border radius scale:** use one consistent scale across the app — e.g., `6px` (small elements), `12px` (cards), `9999px` (pills/badges). Do not mix arbitrary radius values.
- **Spacing scale:** stick to a 4px-based scale (4, 8, 12, 16, 24, 32, 48, 64px) for all padding/margin — avoids the visually inconsistent, slightly-off feel of arbitrary spacing.

---

## 8. Accessibility

- Maintain **WCAG AA contrast** (4.5:1 minimum for body text) for all text/background combinations — Ink (`#1E293B`) on white passes easily; light Muted Slate text on Tint backgrounds should be checked, as some combinations may fall short and need darkening for body copy.
- Never encode meaning by color alone (§3.2).
- Minimum body text size: 16px (1rem) in the product UI; do not go smaller for primary content.
- All interactive elements (buttons, links, form fields) need visible focus states — do not remove default focus outlines without replacing them with an equally visible custom style.

---

## 9. Do's and Don'ts Summary

| Do | Don't |
|---|---|
| Keep backgrounds light; use color as accent | Fill large surfaces with dark color (except title/closing slide treatments) |
| Pair every status color with an icon + label | Rely on color alone to signal risk or verification status |
| Use Inter/Sora in the product, Cambria/Calibri in documents | Mix the two type systems in the same artifact |
| Write calm, action-oriented copy | Use alarmist, shaming, or jargon-heavy language |
| Use one consistent icon library and motif (icon-in-circle) | Mix icon styles or use emoji as functional icons |
| Treat French and Pidgin as first-class content | Treat non-English copy as an afterthought translation |

---

## 10. Developer Reference — Tailwind Config

Paste directly into `tailwind.config.js` (or the `theme.extend` block of an existing config):

```js
// tailwind.config.js (excerpt)
module.exports = {
  theme: {
    extend: {
      colors: {
        chekkam: {
          primary: "#028090",   // Primary Teal
          secondary: "#00A896", // Secondary Seafoam
          accent: "#02C39A",    // Accent Mint
          ink: "#1E293B",       // Body text / headings
          muted: "#64748B",     // Secondary text
          tint: "#E9F5F4",      // Card fill
          tint2: "#F5FAF9",     // Section background
        },
        status: {
          success: "#16A34A",
          warning: "#F59E0B",
          danger: "#DC2626",
          neutral: "#64748B",
        },
      },
      fontFamily: {
        heading: ["Sora", "Poppins", "system-ui", "sans-serif"],
        body: ["Inter", "system-ui", "sans-serif"],
      },
      borderRadius: {
        chekkam: "12px",
      },
    },
  },
};
```

## 11. Developer Reference — CSS Variables (framework-agnostic alternative)

```css
:root {
  /* Brand */
  --chekkam-primary: #028090;
  --chekkam-secondary: #00A896;
  --chekkam-accent: #02C39A;
  --chekkam-ink: #1E293B;
  --chekkam-muted: #64748B;
  --chekkam-tint: #E9F5F4;
  --chekkam-tint-2: #F5FAF9;
  --chekkam-white: #FFFFFF;

  /* Semantic status */
  --status-success: #16A34A;
  --status-warning: #F59E0B;
  --status-danger: #DC2626;
  --status-neutral: #64748B;

  /* Typography */
  --font-heading: "Sora", "Poppins", system-ui, sans-serif;
  --font-body: "Inter", system-ui, sans-serif;

  /* Radius & spacing */
  --radius-sm: 6px;
  --radius-md: 12px;
  --radius-pill: 9999px;
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
}
```

---

*Companion documents: `Chekkam_Project_Overview.md`, `Chekkam_Software_Requirements_Specification.md`.*
