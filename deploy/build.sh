#!/usr/bin/env bash
# Builds the public copy of the site into <output-folder>, and stops if a page would go live
# without its tracking or with the wrong booking links.
# Run by .github/workflows/deploy.yml. To try it yourself: deploy/build.sh /tmp/site
set -euo pipefail
out=${1:?usage: deploy/build.sh <output-folder>}
cd "$(dirname "$0")/.."

# The GTM container each hotel page must carry. Add a line for a new hotel.
declare -A gtm=(
  [the-bandha]=GTM-TZS9RG
  [the-magani]=GTM-W8W5B9Z
)

failed=0
problem() { echo "::error file=$1::$2"; failed=1; }

rm -rf "$out"
mkdir -p "$out"
cp .htaccess "$out/"

for page in */index.html; do
  hotel=${page%/index.html}
  id=${gtm[$hotel]:-}

  if [ -z "$id" ]; then
    problem "$page" "No GTM container listed for $hotel. Add it to deploy/build.sh."
  elif ! grep -qF "'dataLayer','$id')" "$page" || ! grep -qF "ns.html?id=$id" "$page"; then
    problem "$page" "The GTM snippet for $id is missing (it needs both the head and the noscript part)."
  fi
  if grep -q 'reservation\.pmgbali\.com' "$page"; then
    problem "$page" "Links to the old booking engine (reservation.pmgbali.com). Bookings go through be.synxis.com now."
  fi
  if grep -Eq 'be\.synxis\.com[^"]*utm_' "$page"; then
    problem "$page" "UTM tags on a booking link. Remove them: they overwrite the ad click (see README, Tracking)."
  fi

  # Everything in the hotel's folder goes live, except its docs.
  cp -a "$hotel" "$out/"
  find "$out/$hotel" -name '*.md' -delete
done

[ "$failed" = 0 ] || { echo "Not deployed: fix the problems above. The live site has not changed."; exit 1; }
echo "Built $(find "$out" -type f | wc -l) files in $out"
