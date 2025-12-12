# primedetail
Site web de Prime Detail — Nettoyage automobile premium à domicile à Caen. Présente les services, les tarifs, et permet de réserver en ligne.

## Assets & Logos

Les images sont organisées dans `assets/images/...`. Utilisez des formats optimisés (WebP/PNG) et des dimensions adaptées.

### Ajouter le logo et générer variantes
- Placez votre fichier source dans `assets/images/logo/logo.png`.
- Générez automatiquement les variantes et favicons avec le script:

```bash
./tools/generate-logo-assets.sh assets/images/logo/logo.png
```

- Commitez et poussez:

```bash
git add assets/images/logo/*.png assets/images/logo/*.webp assets/images/logo/*.svg
git commit -m "Add: variantes logo et favicons"
git push origin main
```

Le site référence le logo avec un chemin absolu GitHub Pages et un fallback local; un cache-busting `?v=3` est utilisé pour éviter les caches agressifs.

### Tester rapidement le logo en ligne
Utilisez le script simple ci-dessous pour vérifier la disponibilité du logo via GitHub Pages:

```bash
./tools/test-logo.sh 3
```

Le script tente une requête HEAD (`curl -I`) et ouvre l’URL si `$BROWSER` est défini.
