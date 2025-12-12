#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://prime-detail.github.io/prime-detail/assets/images/logo/logo.png"
VER="${1:-3}"

echo "Test URL absolue GitHub Pages:"
curl -I "${BASE_URL}?v=${VER}" || true

echo
echo "Test URL fallback relative (à lancer depuis le site déployé):"
echo "(vérification manuelle dans le navigateur, car relative dépend du contexte)"

echo
echo "Ouvrir dans le navigateur (si variable $BROWSER définie):"
if [[ -n "${BROWSER:-}" ]]; then
  "$BROWSER" "${BASE_URL}?v=${VER}" || true
else
  echo "Définissez $BROWSER pour ouverture automatique, sinon copiez l'URL ci-dessus."
fi
