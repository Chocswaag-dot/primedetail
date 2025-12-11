# Prime Detail Logo Assets

This directory contains optimized logo assets for the Prime Detail website.

## File Organization

### Transparent Background Logos (PNG + WebP)
- `prime-detail-logo-300x100.png/webp` - Small size (300×100px)
- `prime-detail-logo.png/webp` - Standard size (600×200px)
- `prime-detail-logo@2x.png/webp` - Retina size (1200×400px)
- `prime-detail-logo@2x-large.png/webp` - Extra large (2400×800px)

### Primary Color Background (#2185a0)
- `prime-detail-logo-bg-primary-300x100.png/webp` - Small (300×100px)
- `prime-detail-logo-bg-primary.png/webp` - Standard (600×200px)
- `prime-detail-logo-bg-primary@2x.png/webp` - Retina (1200×400px)
- `prime-detail-logo-bg-primary@2x-large.png/webp` - Extra large (2400×800px)

### White Background
- `prime-detail-logo-bg-white-300x100.png/webp` - Small (300×100px)
- `prime-detail-logo-bg-white.png/webp` - Standard (600×200px)
- `prime-detail-logo-bg-white@2x.png/webp` - Retina (1200×400px)

### Favicons
- `prime-detail-favicon-64.png` - 64×64px favicon
- `prime-detail-favicon-32.png` - 32×32px favicon

## Optimization Details

All assets have been optimized for web use:
- **PNG files**: Compressed with pngquant (quality 60-70)
- **WebP files**: Converted with cwebp (quality 80)
- **Cropping**: Tight crop with 20px margin for clarity

## Usage in HTML

The website uses responsive picture elements for optimal performance:

```html
<picture>
  <source srcset="logo/prime-detail-logo@2x.webp 2x, logo/prime-detail-logo.webp 1x" type="image/webp">
  <source srcset="logo/prime-detail-logo@2x.png 2x, logo/prime-detail-logo.png 1x" type="image/png">
  <img src="logo/prime-detail-logo.png" alt="Prime Detail Logo" class="logo-img">
</picture>
```

## Color Reference

- **Primary Color**: `#2185a0` (CSS variable: `--primary-color`)
- **Secondary Color**: `#1a6a82` (used in logo text)
