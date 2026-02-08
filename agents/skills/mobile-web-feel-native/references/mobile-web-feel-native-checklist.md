# Mobile Web Feel-Native Checklist

## Testing Mindset

- Test on real devices, not just a resized desktop browser.
- Record a short screen capture of first-time use and narrate confusion points.
- Try multiple devices and OS versions when possible.

## Input Zooming and Keyboard

- Set input font size to 16px or larger on mobile to prevent auto-zoom.
- Apply a mobile-specific media query to override smaller desktop typography.
- Ensure focused inputs are not hidden under the keyboard; scroll or reposition as needed.

Example CSS:

```css
@media (max-width: 768px) {
  input,
  select,
  textarea {
    font-size: 16px;
  }
}
```

## Accidental Horizontal Scroll

- Identify elements exceeding viewport width; inspect for `100vw`, large images, or long words.
- Add `min-width: 0` to flex children so content can shrink.
- Use `max-width: 100%` for images and media.
- Add `overflow-wrap: anywhere` or `word-break: break-word` for long URLs.
- Avoid blanket `overflow-x: hidden` unless you are sure no intentional horizontal scroll exists.

## Pointer Events and Text Selection

- Disable `user-select` only for UI elements that should never be selectable (chips, buttons, icons).
- Avoid disabling selection on body text and links; it harms accessibility and copy/share flows.
- Use `pointer-events: none` for purely decorative layers that intercept taps.

Example CSS:

```css
.ui-chip,
.icon-only {
  user-select: none;
  -webkit-user-select: none;
}

.decorative-layer {
  pointer-events: none;
}
```

## Zoom Behavior (App-Like UIs)

- Decide whether pinch-zoom is required for the experience; allow it on content-heavy pages.
- For app-like flows with fixed headers and maps, consider disabling pinch-zoom and providing explicit image zoom (lightbox/modal).
- If disabling zoom, document the accessibility tradeoff and ensure text size is legible.

Example meta tag (use cautiously):

```html
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
```

## Frame Consistency

- Use DevTools FPS meter to spot drops and layout thrashing.
- Prefer `transform` and `opacity` animations over `width`, `height`, or `background-color` on large lists.
- Reduce heavy watchers and repeated effects; debounce costly observers.
- Consistent frame rate matters more than peak FPS.

## Full Page Refresh Feel

- Avoid full document reloads between routes; use partial updates or client-side transitions.
- Prevent a white flash by setting `color-scheme` and body background for dark modes.
- Prefetch next-page data where possible.

## Slow Loading and Unresponsive UI

- Show immediate feedback for actions; disable buttons while requests are in flight.
- Use optimistic UI for mutations when safe; rollback on failure.
- Cache data locally (IndexedDB, in-memory cache) to speed repeat visits.
- Avoid loaders that freeze the entire UI when only part is loading.

## Cumulative Layout Shift (CLS)

- Reserve space for images and banners with `width`, `height`, or `aspect-ratio`.
- Avoid injecting UI above the fold after initial render.
- Stabilize font loading and prevent late swaps from shifting layout.
- Watch for hydration-driven reflows that jump content.

## Address Bar and Viewport Units

- Use `dvh`, `svh`, or `lvh` for full-height layouts instead of `100vh`.
- Add bottom padding for toolbars and safe areas: `padding-bottom: env(safe-area-inset-bottom)`.
- Keep critical buttons away from the browser chrome tap zones.

Example CSS:

```css
.app-frame {
  min-height: 100dvh;
  padding-bottom: env(safe-area-inset-bottom);
}
```

## Scroll Traps (Maps, Embedded Scrollers)

- Avoid full-width maps that hijack scroll; consider “tap to enable map” overlays.
- Ensure one-finger scrolling still moves the page, not only the embedded content.
- Test pinch zoom conflicts between map and page.

## Instrumentation (Optional)

- Track rage clicks and dead clicks to detect unresponsive UI.
- Use session replay to see where users get stuck.
