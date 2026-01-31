---
title: Avoid Animating Frame Size Directly
impact: HIGH
impactDescription: frame changes trigger expensive layout passes
tags: props, frame, size, layout, performance
---

## Avoid Animating Frame Size Directly

Animating a view's frame size forces SwiftUI to recalculate layout on every animation frame. This can cause stuttering, especially with complex view hierarchies. Use `scaleEffect` or fixed frames with clipping instead.

**Incorrect (animating frame causes layout thrash):**

```swift
struct CollapsibleSection: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Button("Toggle") { isExpanded.toggle() }

            Text("Content that expands")
                // Changing height triggers layout on every frame
                .frame(height: isExpanded ? 200 : 0)
                .animation(.easeOut(duration: 0.3), value: isExpanded)
        }
    }
}
// Layout recalculated 60 times per second during animation
```

**Correct (fixed frame with clipping):**

```swift
struct CollapsibleSection: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Button("Toggle") { isExpanded.toggle() }

            Text("Content that expands")
                .frame(height: 200) // Fixed internal height
                .frame(height: isExpanded ? 200 : 0, alignment: .top)
                .clipped()
                .animation(.easeOut(duration: 0.3), value: isExpanded)
        }
    }
}
// Only the clipping frame animates, content layout is stable
```

**Better (using scaleEffect for visual expansion):**

```swift
struct CollapsibleSection: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Button("Toggle") { isExpanded.toggle() }

            Text("Content that expands")
                .scaleEffect(y: isExpanded ? 1 : 0, anchor: .top)
                .opacity(isExpanded ? 1 : 0)
                .frame(height: isExpanded ? nil : 0)
                .animation(.easeOut(duration: 0.3), value: isExpanded)
        }
    }
}
// Scale creates visual expansion without layout during animation
```

**For lists with dynamic content:**

```swift
struct AnimatedList: View {
    @State private var items: [Item] = []

    var body: some View {
        VStack {
            ForEach(items) { item in
                ItemRow(item: item)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(), value: items.count)
    }
}
// Transitions handle enter/exit without animating frame sizes
```

**When you must animate size:**
- Use `.drawingGroup()` to rasterize complex hierarchies
- Keep the animating view hierarchy shallow
- Profile with Instruments to identify bottlenecks

Reference: [SwiftUI Performance](https://developer.apple.com/documentation/swiftui/improving-your-app-s-performance)
