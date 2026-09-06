#!/usr/bin/env bash
# Regenerates assets/org-banner.png and assets/logo.png with headless Chrome.
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$(pwd)"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"

shoot() { # src w h out [scale]
  "$CHROME" --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor="${5:-1}" --window-size="$2,$3" \
    --virtual-time-budget=10000 --screenshot="$4" "file://$1" >/dev/null 2>&1
}

# Banner at 2x so it stays crisp on retina.
shoot "$ROOT/tools/org-banner.html" 1280 440 "$ROOT/assets/org-banner.png" 2

# Organisation avatar. Upload by hand at
# github.com/organizations/Cratefield/settings/profile — there is no API.
shoot "$ROOT/tools/avatar.html" 1024 1024 "$ROOT/assets/logo.png"

for f in org-banner.png logo.png; do
  printf '%-18s %s\n' "$f" "$(sips -g pixelWidth -g pixelHeight "$ROOT/assets/$f" | tail -2 | tr -d ' \n')"
done
