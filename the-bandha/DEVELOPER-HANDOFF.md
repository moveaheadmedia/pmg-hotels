# The Bandha: Book Direct Landing Page (developer handoff)

**Goal:** get more direct bookings. Google Ads traffic lands here, and every CTA sends visitors to the SynXis booking engine.
**Contact:** Josh Tinker, Move Ahead Media (josh.tinker@moveaheadmedia.com.au)

## Files
| File | What it is |
|---|---|
| `index.html` | The complete page in one file. Plain HTML, CSS and vanilla JS, with no build step or dependencies. Open it in a browser to see it. |
| `the-bandha-brand-ci.md` | Brand CI: logo, colour tokens, type, UI and voice rules. |

## How it's built
- **One file, one page.** CSS is in `<style>` and the brand tokens are CSS variables at the top of `:root`. The JS sits at the bottom of `<body>`.
- **External resources:**
  - Google Fonts: Cinzel and Open Sans
  - Google Maps embed (no API key needed)
  - Images hotlinked from `cms.thebandha.com/uploads`
- **Settings block** (search the file for `PAGE SETTINGS`):
  ```js
  var AUD_PER_IDR=12400;   // approx. AUD shown under every IDR price
  var OFFER_END='';        // e.g. '2026-10-31T23:59:00+08:00'; empty = countdown hidden
  ```
- **Booking widget:** a GET form to `https://be.synxis.com/` with the same fields as the form on the hotel's website: `chain`, `hotel`, `arrive`, `depart`, `adult`, `child`, `rooms`. With no dates picked it searches from today.
- **Book Now links:** plain links to SynXis, the same as the hotel's website. Offer cards link to their own rate (`rate=...`, taken from the offer's `Book_Now_Link` on the hotel's website). Early Bird gets its arrival date from JS (`data-days-ahead`), because that rate needs an arrival 30+ days out.
- **Tracking:** GTM carries the ad click to SynXis (`_gl` and `_mam`). No UTM tags on booking links: see the root README.

## Hosting

Live on https://discoverpmgbali.com/, deployed automatically from `main`. See "Making a change" in the root README.

## Must do before launch
- [x] **Booking engine:** moved to SynXis.
- [x] **Tracking:** GTM installed; the ad click reaches SynXis.
- [ ] **Tracking test:** make a test booking and confirm the session is attributed to the right campaign.
- [ ] **GA4:** add `discoverpmgbali.com` to the cross-domain list of the hotel's GA4 stream.
- [ ] **Images:**
  - Download them from the CMS and self-host them, as WebP in responsive sizes with `srcset`, so the page keeps working if CMS files are renamed.
  - The hero image is a large PNG. Compress it.
- [ ] **Fonts:** Trajan Pro is the brand heading font. If the client holds a web licence, self-host it; the CSS already lists it first. Otherwise Cinzel is the fallback.
- [x] **Head tags:** `noindex` added (paid traffic only).
- [ ] **Placeholder content to replace:**
  - [ ] 3 guest review quotes (search for `Verified guest review`). Use real, attributed reviews only.
  - [ ] `OFFER_END` for the 10.10 countdown, using the real end date from the hotel.
  - [ ] **Prices and offers:** confirm they're current. They were taken from thebandha.com on 14 Oct 2026.
  - [ ] **Direct vs booking-sites table:** have the hotel confirm each perk is direct-only.
  - [ ] **Redeemable Room Night copy:** confirm how the membership points work.
- [ ] **QA:**
  - [ ] Test on iOS Safari and Android Chrome, especially the date inputs.
  - [ ] Run Lighthouse (performance and accessibility).
  - [ ] Check every CTA opens the booking engine on the right hotel and rate.
  - [ ] Check the gallery lightbox (Esc and arrow keys), the in-page nav and the mobile sticky book bar.

## Page structure (top to bottom)
1. Promo ribbon, with the countdown when it's set
2. Sticky header
3. Hero with booking widget and trust line
4. Trust bar
5. Why book direct
6. Offers
7. Rooms
8. Gallery and lightbox
9. Experience
10. Direct vs booking sites
11. Reviews
12. Location and map
13. FAQ
14. Final CTA
15. Footer
16. Mobile sticky book bar
