# Mobile Web Feel-Native Checklist

Use this checklist to find common "mobile web tells" and propose fixes. Test on real devices or emulators and validate after changes.

## 1) Inputs and Keyboard

- Set input font size to 16px or larger on mobile to prevent iOS auto-zoom.
- Ensure focused inputs remain visible above the keyboard.
- Avoid tiny select controls; increase padding for touch targets.

Example CSS:

```css
@media (max-width: 768px) {
  input,
  select,
  textarea {
    font-size: 16px;
  }
}

.select-lg {
  padding: 0.75rem 1rem;
}
```

## 2) Tap Highlights and Touch Delay

- Remove tap highlight flashes on app-like UIs, especially in PWA/standalone mode.
- Reduce 300ms double-tap delay without disabling pinch zoom via `touch-action: manipulation`.
- Keep visible focus styles for keyboard users.

Example CSS:

```css
* {
  -webkit-tap-highlight-color: transparent;
}

html {
  touch-action: manipulation;
}
```

## 3) Overscroll and Pull-to-Refresh

- For full-screen apps, prevent rubber-banding and pull-to-refresh that fights with carousels and drawers.
- Do not disable overscroll on content-heavy pages where bounce feedback is useful.

Example CSS:

```css
html,
body {
  overscroll-behavior: none;
}
```

## 4) Accidental Text Selection and Pointer Events

- Disable selection on UI chrome only (chips, buttons, icons, tabs).
- Avoid disabling selection on body text and links.
- Use `pointer-events: none` for decorative layers that intercept taps.

Example CSS:

```css
.ui-chip,
.icon-only,
.button-like {
  user-select: none;
  -webkit-user-select: none;
}

.decorative-layer {
  pointer-events: none;
}
```

## 5) Horizontal Scroll Edge Cases

- Identify elements exceeding viewport width (long words, `100vw`, large images).
- Add `min-width: 0` to flex children.
- Use `max-width: 100%` for images and media.
- Use `overflow-wrap: anywhere` or `word-break: break-word` for URLs.
- Avoid blanket `overflow-x: hidden` unless deliberate.

## 6) Safe-Area and Viewport Units

- Use `dvh`, `svh`, or `lvh` instead of `100vh` for full-height layouts.
- Add safe-area padding for sticky headers/footers and floating controls.
- Keep critical buttons away from browser chrome tap zones.

Example CSS:

```css
.app-frame {
  min-height: 100dvh;
  padding-bottom: env(safe-area-inset-bottom);
}

.sticky-footer {
  padding-bottom: max(1.5rem, env(safe-area-inset-bottom));
}

.sticky-top {
  padding-top: max(1rem, env(safe-area-inset-top));
}
```

## 7) Full-Screen App Shells

- If the experience is intentionally full-screen, prevent body scroll to avoid split scroll contexts.
- Do not disable body scroll on content-heavy pages.

Example CSS:

```css
body {
  overflow: hidden;
}
```

## 8) Layout Stability (CLS)

- Reserve space for images, banners, and ads (`width`, `height`, `aspect-ratio`).
- Avoid injecting UI above the fold after initial render.
- Stabilize font loading to prevent late swaps from shifting layout.
- Watch for hydration reflows that jump content.

## 9) Animation and Frame Consistency

- Avoid `transition: all` on large lists; specify exact properties.
- Prefer `transform` and `opacity` for animations.
- Reduce heavy watchers and repeated effects; debounce expensive observers.
- Consistent frame rate matters more than peak FPS.

## 10) Loading Feel and Responsiveness

- Show immediate feedback for actions; disable buttons while requests are in flight.
- Use optimistic UI when safe; rollback on failure.
- Cache data locally (IndexedDB, in-memory) to speed repeat visits.
- Avoid loaders that freeze the entire UI when only part is loading.

## 11) Navigation and Page Transitions

- Avoid full document reloads between routes.
- Prevent white flashes by setting `color-scheme` and body background for dark modes.
- Prefetch data or HTML where possible.

## 12) Scroll Traps (Maps, Embedded Scrollers)

- Avoid full-width maps that hijack scroll; consider "tap to enable map" overlays.
- Ensure one-finger scrolling moves the page, not only embedded content.
- Test pinch-zoom conflicts between the map and the page.

## 13) Touch Target Sizing

- Aim for ~44px touch targets on mobile.
- If font size increases to 16px, verify vertical padding is still sufficient.
- Use `min-height` or `padding` to meet target size.

## Verification

- Test on iOS Safari and Android Chrome.
- Test in standalone PWA mode if applicable.
- Verify: no input zoom, no tap highlight flash, no accidental text selection, no overscroll conflicts, safe-area clearance, stable layout, and consistent animation.
