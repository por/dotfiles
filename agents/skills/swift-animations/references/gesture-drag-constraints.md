---
title: Constrain Drag Within Bounds
impact: HIGH
impactDescription: boundaries with resistance create natural feel
tags: gesture, drag, constraints, bounds, resistance
---

## Constrain Drag Within Bounds

Drag gestures should respect boundaries while providing elastic resistance when the user drags beyond limits. This mimics real-world physics where objects resist being pushed past barriers.

**Hard constraint (stops at boundary):**

```swift
struct HardConstraintDrag: View {
    @State private var offset: CGSize = .zero
    let bounds: CGRect = CGRect(x: -100, y: -100, width: 200, height: 200)

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Clamp to bounds
                        offset = CGSize(
                            width: min(max(value.translation.width, bounds.minX), bounds.maxX),
                            height: min(max(value.translation.height, bounds.minY), bounds.maxY)
                        )
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
    }
}
```

**Elastic resistance (rubber-band effect):**

```swift
struct ElasticDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    let maxDrag: CGFloat = 100
    let rubberBandFactor: CGFloat = 0.3

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .offset(constrainedOffset)
            .animation(isDragging ? nil : .spring(response: 0.35, dampingFraction: 0.7), value: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        offset = .zero
                    }
            )
    }

    private var constrainedOffset: CGSize {
        CGSize(
            width: rubberBand(offset.width, limit: maxDrag),
            height: rubberBand(offset.height, limit: maxDrag)
        )
    }

    private func rubberBand(_ value: CGFloat, limit: CGFloat) -> CGFloat {
        if abs(value) <= limit {
            return value
        }
        // Rubber band: diminishing returns past limit
        let excess = abs(value) - limit
        let resistance = limit + excess * rubberBandFactor
        return value > 0 ? resistance : -resistance
    }
}
```

**One-directional constraint (like pull-to-refresh):**

```swift
struct PullDownOnly: View {
    @State private var pullAmount: CGFloat = 0
    @State private var isDragging = false
    let maxPull: CGFloat = 150

    var body: some View {
        VStack {
            // Pull indicator
            ProgressView()
                .scaleEffect(min(pullAmount / 80, 1))
                .opacity(min(pullAmount / 60, 1))
                .frame(height: max(pullAmount, 0))

            // Content
            ScrollView {
                ContentView()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    // Only allow downward drag, with rubber band
                    if value.translation.height > 0 {
                        pullAmount = rubberBand(value.translation.height, limit: maxPull)
                    }
                }
                .onEnded { _ in
                    isDragging = false
                    if pullAmount > 80 {
                        // Trigger refresh
                    }
                    withAnimation(.spring(response: 0.3)) {
                        pullAmount = 0
                    }
                }
        )
    }

    private func rubberBand(_ value: CGFloat, limit: CGFloat) -> CGFloat {
        limit * (1 - exp(-value / limit))
    }
}
```

**Sheet with snap points:**

```swift
struct SnapSheet: View {
    @State private var offsetY: CGFloat = 0
    @State private var isDragging = false
    let snapPoints: [CGFloat] = [0, 200, 400] // Collapsed, half, full

    var body: some View {
        SheetContent()
            .offset(y: offsetY)
            .animation(isDragging ? nil : .spring(response: 0.35), value: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offsetY = max(0, value.translation.height)
                    }
                    .onEnded { value in
                        isDragging = false
                        // Snap to nearest point
                        let nearest = snapPoints.min(by: {
                            abs($0 - offsetY) < abs($1 - offsetY)
                        }) ?? 0
                        offsetY = nearest
                    }
            )
    }
}
```

Reference: [DragGesture](https://developer.apple.com/documentation/swiftui/draggesture)
