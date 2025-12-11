#!/usr/bin/env bash
set -euo pipefail

# Usage:
# ./tools/generate-logo-assets.sh path/to/source-logo.png
# Exemple:
# ./tools/generate-logo-assets.sh assets/images/logo/logo.png
#
# Prérequis (installer si besoin):
# - ImageMagick (magick/convert)
# - pngquant (optionnel)
# - oxipng (optionnel)
# - webp (cwebp) (optionnel)
# - potrace (optionnel pour SVG)
#
# Sorties générées dans: assets/images/logo/

SRC="${1:-}"
OUTDIR="assets/images/logo"
BRANCH="assets/logo-update"
PRIMARY_BG="#2185a0"
MARGIN=10

if [[ -z "$SRC" ]]; then
  echo "Usage: $0 path/to/source-logo.png" >&2
  exit 1
fi

mkdir -p "$OUTDIR/tmp"
echo "Source: $SRC"
if [ ! -f "$SRC" ]; then
  echo "Fichier source introuvable : $SRC" >&2
  exit 1
fi

# 1) Recadrer : trim et ajouter marge transparente
TRIMMED="$OUTDIR/tmp/prime-detail-trimmed.png"
magick "$SRC" -alpha set -channel A -fuzz 5% -trim +repage -bordercolor none -border ${MARGIN}x${MARGIN} "$TRIMMED"

# 2) Fonction pour générer variantes
generate_variants() {
  local input="$1"
  local base="$2"
  local w="$3"
  local h="$4"
  local out_png="$OUTDIR/${base}-${w}x${h}.png"

  magick "$input" -resize "${w}x${h}"\> -background none -gravity center -extent "${w}x${h}" "$out_png"

  local out_bg_primary="$OUTDIR/${base}-bg-primary-${w}x${h}.png"
  magick -size ${w}x${h} canvas:"$PRIMARY_BG" "$out_bg_primary"
  magick "$out_bg_primary" "$out_png" -gravity center -compose over -composite "$out_bg_primary"

  local out_bg_white="$OUTDIR/${base}-bg-white-${w}x${h}.png"
  magick -size ${w}x${h} canvas:"#ffffff" "$out_bg_white"
  magick "$out_bg_white" "$out_png" -gravity center -compose over -composite "$out_bg_white"

  local out_dark="$OUTDIR/${base}-dark-${w}x${h}.png"
  magick "$out_png" -fuzz 12% -fill "#f0f0f0" -opaque white "$out_dark"

  echo "Generated: $out_png, $out_bg_primary, $out_bg_white, $out_dark"

  if command -v pngquant >/dev/null 2>&1; then
    pngquant --quality=60-80 --strip --output "${out_png%.png}-q.png" --force "$out_png" && mv -f "${out_png%.png}-q.png" "$out_png"
    pngquant --quality=60-80 --strip --output "${out_bg_primary%.png}-q.png" --force "$out_bg_primary" && mv -f "${out_bg_primary%.png}-q.png" "$out_bg_primary"
    pngquant --quality=60-80 --strip --output "${out_bg_white%.png}-q.png" --force "$out_bg_white" && mv -f "${out_bg_white%.png}-q.png" "$out_bg_white"
    pngquant --quality=60-80 --strip --output "${out_dark%.png}-q.png" --force "$out_dark" && mv -f "${out_dark%.png}-q.png" "$out_dark"
  fi

  if command -v oxipng >/dev/null 2>&1; then
    oxipng -o 4 -strip all "$out_png" || true
    oxipng -o 4 -strip all "$out_bg_primary" || true
    oxipng -o 4 -strip all "$out_bg_white" || true
    oxipng -o 4 -strip all "$out_dark" || true
  fi

  if command -v cwebp >/dev/null 2>&1; then
    cwebp -q 80 "$out_png" -o "${out_png%.png}.webp" >/dev/null
    cwebp -q 80 "$out_bg_primary" -o "${out_bg_primary%.png}.webp" >/dev/null
    cwebp -q 80 "$out_bg_white" -o "${out_bg_white%.png}.webp" >/dev/null
    cwebp -q 80 "$out_dark" -o "${out_dark%.png}.webp" >/devnull 2>&1 || true
  fi
}

# 3) Générer tailles
generate_variants "$TRIMMED" "prime-detail-logo" 600 200
generate_variants "$TRIMMED" "prime-detail-logo@2x" 1200 400
generate_variants "$TRIMMED" "prime-detail-logo-300x100" 300 100

# 4) Favicons
FAV64="$OUTDIR/prime-detail-favicon-64.png"
FAV32="$OUTDIR/prime-detail-favicon-32.png"
magick "$TRIMMED" -resize 64x64 -background none -gravity center -extent 64x64 "$FAV64"
magick "$TRIMMED" -resize 32x32 -background none -gravity center -extent 32x32 "$FAV32"
if command -v pngquant >/dev/null 2>&1; then
  pngquant --quality=60-80 --strip --output "${FAV64%.png}-q.png" --force "$FAV64" && mv -f "${FAV64%.png}-q.png" "$FAV64"
  pngquant --quality=60-80 --strip --output "${FAV32%.png}-q.png" --force "$FAV32" && mv -f "${FAV32%.png}-q.png" "$FAV32"
fi
if command -v cwebp >/dev/null 2>&1; then
  cwebp -q 80 "$FAV64" -o "${FAV64%.png}.webp" >/dev/null || true
  cwebp -q 80 "$FAV32" -o "${FAV32%.png}.webp" >/dev/null || true
fi

# 5) Tentative de vectorisation
SVG_OUT="$OUTDIR/prime-detail-logo.svg"
if command -v potrace >/dev/null 2>&1 && command -v magick >/dev/null 2>&1; then
  magick "$TRIMMED" -colorspace Gray -threshold 50% -flatten "$OUTDIR/tmp/trace-bmp.pbm"
  potrace -s -o "$SVG_OUT" "$OUTDIR/tmp/trace-bmp.pbm" && echo "SVG vectorization produced $SVG_OUT (monochrome)"
else
  echo "Potrace non disponible — SVG non généré (optionnel)."
fi

# 6) Fin
echo "Terminé. Voir outputs dans $OUTDIR"