#!/usr/bin/env bash
# Waits for the live site to show this build, then compares every public file with it byte for byte.
# Run by .github/workflows/deploy.yml after the deploy.
set -euo pipefail
dir=${1:?usage: deploy/verify.sh <build-folder>}
site=${SITE:-https://discoverpmgbali.com}
sha=$(cat "$dir/deployed.txt")

live() { curl -fsS --max-time 20 "$site/$1?v=$RANDOM$RANDOM"; }

tries=36   # 5 seconds apart: 3 minutes
until [ "$(live deployed.txt 2>/dev/null || true)" = "$sha" ]; do
  tries=$((tries - 1))
  if [ "$tries" = 0 ]; then
    echo "::error::Hostinger did not pick up this commit within 3 minutes. The live site still shows: $(live deployed.txt 2>/dev/null || echo 'nothing')"
    exit 1
  fi
  sleep 5
done

cd "$dir"
for file in $(find . -type f ! -name .htaccess | sed 's|^\./||'); do
  if ! live "$file" | cmp -s - "$file"; then
    echo "::error::$site/$file does not match this commit."
    exit 1
  fi
done

landed=$(curl -sS -o /dev/null --max-time 20 -w '%{http_code} %{redirect_url}' "$site/")
if [ "$landed" != "301 $site/the-bandha/" ]; then
  echo "::error::$site/ should redirect to /the-bandha/ but answered: $landed"
  exit 1
fi
echo "Live site matches $sha"
