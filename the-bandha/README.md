# The Bandha Hotel & Suites: Book Direct landing page

A single-page Google Ads landing page for [The Bandha Hotel & Suites](https://thebandha.com) in Legian, Bali. Its job is to turn ad traffic into direct bookings: every call to action sends visitors to the SynXis booking engine.

**Live page:** https://discoverpmgbali.com/the-bandha/

**Preview:** https://moveaheadmedia.github.io/pmg-hotels/the-bandha/

Built by Move Ahead Media. Contact: Josh Tinker (josh.tinker@moveaheadmedia.com.au).

## What's in this folder

| File | Purpose |
|---|---|
| `index.html` | The whole page in one file. Plain HTML, CSS and vanilla JS. No build step, no dependencies. |
| `favicon.ico`, `favicon.png` | The Bandha gold crest favicon. |
| `DEVELOPER-HANDOFF.md` | Implementation notes, settings and the pre-launch checklist. |
| `the-bandha-brand-ci.md` | Brand CI: logo, colour tokens, typography, UI and voice rules. |

## Running it locally

Open `index.html` in a browser. There is nothing to install.

The page loads Google Fonts (Cinzel and Open Sans), a Google Maps embed and images hotlinked from `cms.thebandha.com`, so it needs an internet connection to render fully.

## Configuring the page

Search `index.html` for `PAGE SETTINGS`. The settings block controls the IDR to AUD rate shown under prices and the offer end date for the countdown:

```js
var AUD_PER_IDR=12400;   // approx. AUD shown under every IDR price
var OFFER_END='';        // e.g. '2026-10-31T23:59:00+08:00'; empty = countdown hidden
```

Booking links are plain links to the SynXis engine (chain `7097`, hotel `101578`), and the hero widget is a GET form to it. Each offer card links to that offer's own rate (`rate=...`), copied from the hotel's website. Do not add UTM tags to them: see Tracking in the [root README](../README.md).

## Deployment

Pushing to `main` puts this page live automatically. See "Making a change" in the [root README](../README.md).

## Before launch

Work through the checklist in `DEVELOPER-HANDOFF.md`. The main open items are replacing placeholder reviews, confirming prices and offers with the hotel, self-hosting images, and cross-browser QA.
