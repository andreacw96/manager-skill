#!/usr/bin/env bash
# Renders banner.png (1000x380 @2x) and ../../.claude-plugin/icon.png (1024x1024) with headless Chrome.
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
shot(){ "$CHROME" --headless=new --allow-file-access-from-files --hide-scrollbars --window-size="$1" --force-device-scale-factor="$2" \
  --default-background-color=00000000 --virtual-time-budget=8000 --screenshot="$3" "$4" >/dev/null 2>&1; magick "$3" -strip "$3"; echo "$3"; }
shot 1000,380 2 "$PWD/banner.png" "file://$PWD/banner.html"
shot 512,512 2 "$PWD/../../.claude-plugin/icon.png" "file://$PWD/icon.svg"
