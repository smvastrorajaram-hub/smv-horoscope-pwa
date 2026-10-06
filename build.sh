#!/usr/bin/env bash
set -euo pipefail

SRC="_source/public/horoscope"
OUT="_site"

test -f "$SRC/index.html"
test -f "$SRC/manifest-en.webmanifest"
test -f "$SRC/manifest-ta.webmanifest"
test -f "$SRC/sw.js"
test -f "$SRC/pwa.js"

rm -rf "$OUT"
mkdir -p "$OUT"
cp -a "$SRC/." "$OUT/"

# The Calendar has its own independent subdomain. Do not expose a nested Calendar PWA here.
rm -rf "$OUT/calendar"

printf '%s\n' "horoscope.smvastroservices.in" > "$OUT/CNAME"

python3 - <<'PY'
from pathlib import Path
import json

out = Path("_site")

# Root page metadata + Calendar navigation.
p = out / "index.html"
s = p.read_text(encoding="utf-8")
s = s.replace("https://smvastroservices.in/horoscope/", "https://horoscope.smvastroservices.in/")
s = s.replace('href="./calendar/" target="_blank" rel="noopener" id="smvCalendarNav"',
              'href="https://calendar.smvastroservices.in/" target="_blank" rel="noopener" id="smvCalendarNav"')
p.write_text(s, encoding="utf-8")

# Independent root-scope manifests.
for lang in ("en", "ta"):
    p = out / f"manifest-{lang}.webmanifest"
    data = json.loads(p.read_text(encoding="utf-8"))
    data["id"] = "/"
    data["start_url"] = f"/?lang={lang}&source=horoscope-subdomain-pwa"
    data["scope"] = "/"
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# Fresh independent cache namespace; no logic change.
p = out / "sw.js"
s = p.read_text(encoding="utf-8")
s = s.replace(
    "const CACHE='smv-horoscope-v230-print-store-version-restore'+self.registration.scope;",
    "const CACHE='smv-horoscope-independent-v1-'+self.registration.scope;"
)
p.write_text(s, encoding="utf-8")
PY

# Do not publish repo/build documentation inside the PWA.
rm -f "$OUT"/AUDIT*.md "$OUT"/README*.md "$OUT"/FINAL-*.md 2>/dev/null || true

echo "SMV HOROSCOPE independent PWA build: PASS"
