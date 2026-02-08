---
name: mobile-web-feel-native
description: "Improve mobile web apps to feel native by auditing and fixing common mobile UX issues (input zooming, tap highlights, touch delays, overscroll bounce, accidental horizontal scroll, text selection, zoom behavior, viewport units/address bar issues, safe-area padding, CLS, loading feel, caching/optimistic UI, scroll traps like maps, touch target sizing). Use when asked to review, diagnose, or polish mobile web UX or interaction performance."
---

# Mobile Web Feel Native

## Quick Start

- Confirm target devices, browsers, and whether the app runs as a PWA/standalone.
- Reproduce on a real device or emulator and capture a short screen recording.
- Run the full checklist in `references/mobile-web-feel-native-checklist.md` and tag each issue as "impact" or "nice-to-have." 
- Provide fixes with clear tradeoffs and validation steps.

## Workflow

1. **Scope and constraints**
   - Identify the exact flows (login, feed, filters, detail view, checkout, maps).
   - Note accessibility requirements, brand constraints, and app shell expectations.

2. **Observe and categorize**
   - Classify issues using the checklist categories (input zoom, tap highlight/touch delay, overscroll, safe-area padding, selection/pointer issues, layout shift, animation jank, loading feel, scroll traps, horizontal scroll, touch targets).
   - Record reproduction steps, affected devices, and visible impact.

3. **Propose fixes**
   - Provide specific CSS/JS changes and explain why they improve native feel.
   - Call out tradeoffs (e.g., `user-select: none` scope, overscroll suppression, pinch-zoom decisions).

4. **Validate**
   - Re-test the exact interaction after fixes and confirm no regressions.
   - List any remaining risks or follow-ups.

## Default Checks (Always Evaluate)

- Input auto-zoom and keyboard occlusion
- Tap highlight flash and touch delay
- Overscroll bounce and pull-to-refresh behavior
- Safe-area top/bottom clearance for sticky controls
- Accidental text selection on non-text UI
- Horizontal scroll edge cases
- Layout stability (CLS)
- Animation/transition performance
- Loading responsiveness (optimistic UI or immediate feedback)
- Scroll traps (maps, embedded scrollers)
- Touch target size (~44px)

## Output Format

- **Summary**: 2–4 sentences on overall feel and highest-impact issues.
- **Top Issues (Prioritized)**: Each item with reproduction, cause, fix, and tradeoff.
- **Quick Wins**: Low-effort/high-impact fixes.
- **Follow-ups**: Deeper refactors, instrumentation, or testing recommendations.
- **Validation Plan**: Concrete steps to confirm improvements.

## References

- Use `references/mobile-web-feel-native-checklist.md` for detailed heuristics and example fixes.
