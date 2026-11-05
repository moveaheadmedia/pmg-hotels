# PMG Hotels: Book Direct landing pages

Google Ads landing pages for the PMG Bali hotel group. Each hotel has its own folder with a single-file page (plain HTML, CSS and vanilla JS, no build step) whose job is to turn ad traffic into direct bookings through the hotel's SynXis booking engine.

**Live site:** https://discoverpmgbali.com/ (there is no home page: it redirects to The Bandha)

**Preview index:** https://moveaheadmedia.github.io/pmg-hotels/

Built by Move Ahead Media. Contact: Josh Tinker (josh.tinker@moveaheadmedia.com.au).

## Hotels

| Folder | Hotel | Live page | Preview |
|---|---|---|---|
| [`the-bandha/`](the-bandha/) | The Bandha Hotel & Suites, Legian | https://discoverpmgbali.com/the-bandha/ | https://moveaheadmedia.github.io/pmg-hotels/the-bandha/ |
| [`the-magani/`](the-magani/) | The Magani Hotel and Spa, Legian | https://discoverpmgbali.com/the-magani/ | https://moveaheadmedia.github.io/pmg-hotels/the-magani/ |

Each folder has its own `README.md` with the page settings and launch notes. The shared developer handoff and pre-launch checklist live in `the-bandha/DEVELOPER-HANDOFF.md`.

## Making a change

**Anything pushed to `main` goes live on https://discoverpmgbali.com/ automatically, in about a minute.** There is no staging step, so use a pull request if you want someone to look first. Merging it counts as a push.

Edit on `main` only:

- Do not edit the `live` branch: the next deploy replaces it.
- Do not edit files on Hostinger: the next deploy overwrites them.

To undo a change, revert its commit on `main`. That deploys the previous version.

## How the deploy works

`.github/workflows/deploy.yml` runs on every push to `main`:

1. `deploy/build.sh` checks each page and builds the public copy: the hotel folders without their `.md` files, plus `.htaccess`. The root `index.html` and all docs stay off the live site.
2. The public copy is committed to the `live` branch.
3. Hostinger pulls `live` into the site, through the deploy webhook in the `HOSTINGER_DEPLOY_WEBHOOK` Actions secret.
4. `deploy/verify.sh` waits for the commit to show up at https://discoverpmgbali.com/deployed.txt, then compares every public file on the live site with the build.

**If a deploy goes wrong**, the run turns red in the [Actions tab](https://github.com/moveaheadmedia/pmg-hotels/actions), the commit gets a red X and GitHub emails the person who pushed. The error message says what to fix.

- If step 1 fails, nothing was deployed: the site keeps the last good version. It stops a page that has lost its GTM snippet, carries the wrong container, links to the old booking engine, or has UTM tags on a booking link.
- If step 3 or 4 fails, check the live site, then use **Re-run jobs** on the failed run.

`.htaccess` here is the site's root `.htaccess`: the redirect from `/` to `/the-bandha/`, `www` to the main domain, and cache headers. A mistake in it can take the whole site down.

## Tracking

Each page loads its hotel's GTM container, and the same container runs on the booking engine. It carries the ad click across by itself: the Google tag adds `_gl` and MAM's attribution tag adds `_mam` when someone clicks through to SynXis, and the booking is logged with its real source and landing page.

**Do not add UTM tags to booking links.** They count as a new visit on SynXis, so every Google Ads booking would be credited to whatever the link says.

## Adding a hotel

1. Create a new folder named after the hotel in kebab-case, for example `the-new-hotel/`.
2. Put the page in it as `index.html`, plus any favicon files and a `README.md`. Everything in the folder except `.md` files goes live.
3. Add the hotel's GTM container to `deploy/build.sh`.
4. Add a row to the table above and a card to the root `index.html`.
5. Push to `main`. The page goes live at `https://discoverpmgbali.com/<folder>/`, and GitHub Pages serves the preview at `/pmg-hotels/<folder>/`.
