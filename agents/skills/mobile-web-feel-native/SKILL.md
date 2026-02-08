---
name: mobile-web-feel-native
description: "Improve mobile web apps to feel native by auditing and fixing common mobile UX issues (input zooming, accidental horizontal scroll, text selection, zoom behavior, viewport units/address bar issues, CLS, loading feel, caching/optimistic UI, scroll traps like maps). Use when asked to review, diagnose, or polish mobile web UX or interaction performance."
---

# Mobile Web Feel Native

## Quick Start

- Ask for target devices/browsers, app stack, and the exact screens/flows that feel rough or non-native.
- Reproduce on a real device or emulator; capture a short screen recording to anchor observations.
- Use the checklist in `references/mobile-web-feel-native-checklist.md` to identify root causes and fixes.
- Deliver a prioritized fix list with quick wins first and measurable impact notes.

## Workflow

1. **Confirm scope**
   - Identify the problematic flows (e.g., login, checkout, search, maps, forms).
   - Note constraints: accessibility requirements, must-keep pinch zoom, UI framework, performance budgets.

2. **Observe and categorize**
   - Classify issues using the checklist categories: input zoom, horizontal scroll, CLS, loading feel, scroll traps, viewport unit bugs, selection/pointer issues, frame drops.
   - For each issue, note: steps to reproduce, affected devices, and visible impact.

3. **Propose fixes and tradeoffs**
   - Provide specific CSS/JS changes and the tradeoffs (e.g., disabling pinch zoom vs accessibility).
   - Separate **quick wins** (CSS/layout) from **structural fixes** (routing, data caching, optimistic UI).

4. **Validate improvements**
   - Re-test on device and confirm that the interaction now feels smooth and predictable.
   - Call out any remaining risks (e.g., long text edge cases, font loading, or map interactions).

## Output Format

Provide results in this structure:

- **Summary**: 2–4 sentences on overall UX feel and biggest pain points.
- **Top Issues (Prioritized)**: Each item should include reproduction steps, cause, and fix.
- **Quick Wins**: Bullet list of low-effort/high-impact changes.
- **Follow-ups**: Any deeper refactors, instrumentation, or testing recommendations.

## References

- Use `references/mobile-web-feel-native-checklist.md` for detailed heuristics and example fixes.
