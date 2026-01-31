---
title: Prefer Opacity and Scale for Performance
impact: HIGH
impactDescription: opacity and scale animate on GPU without layout recalculation
tags: props, opacity, scale, performance, gpu
---

## Prefer Opacity and Scale for Performance

Animating `opacity` and `scaleEffect` is highly performant because these properties don't trigger layout recalculation. The GPU handles these transforms directly, maintaining smooth 60fps animations even with complex view hierarchies.

**Incorrect (animating frame triggers layout):**

```swift
struct ExpandingButton: View {
    @State private var isExpanded = false

    var body: some View {
        Button("Expand") { isExpanded.toggle() }
            // Animating frame triggers layout on every frame
            .frame(width: isExpanded ? 200 : 100, height: isExpanded ? 60 : 40)
            .animation(.spring(), value: isExpanded)
    }
}
// Layout recalculation can cause frame drops
```

**Correct (scale doesn't trigger layout):**

```swift
struct ExpandingButton: View {
    @State private var isExpanded = false

    var body: some View {
        Button("Expand") { isExpanded.toggle() }
            .frame(width: 100, height: 40)
            // Scale transforms on GPU, no layout needed
            .scaleEffect(isExpanded ? CGSize(width: 2, height: 1.5) : CGSize(width: 1, height: 1))
            .animation(.spring(), value: isExpanded)
    }
}
// Smooth animation without layout thrashing
```

**Fade + Scale for enter/exit:**

```swift
struct AppearingCard: View {
    @State private var isVisible = false

    var body: some View {
        CardContent()
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .animation(.easeOut(duration: 0.2), value: isVisible)
    }
}
// Classic fade+scale is performant and visually pleasing
```

**GPU-accelerated properties:**
- `opacity` - Transparency changes
- `scaleEffect` - Size without layout
- `rotationEffect` - 2D rotation
- `rotation3DEffect` - 3D transforms
- `offset` - Position without layout

**Layout-triggering properties (use sparingly):**
- `frame(width:height:)` - Changes actual size
- `padding()` - Affects layout spacing
- `position()` - Repositions in parent coordinate space

Reference: [SwiftUI Performance](https://developer.apple.com/documentation/swiftui/improving-your-app-s-performance)
