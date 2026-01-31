---
title: Spring Back on Gesture End
impact: HIGH
impactDescription: spring release creates satisfying physical feedback
tags: gesture, spring, release, snap, physics
---

## Spring Back on Gesture End

When a gesture ends, elements should spring back to their resting position rather than snapping instantly. This creates a satisfying physical feedback that makes interactions feel alive.

**Drag with spring release:**

```swift
struct SpringReleaseDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 80, height: 80)
            .offset(offset)
            // No animation during drag, spring on release
            .animation(
                isDragging ? nil : .spring(response: 0.35, dampingFraction: 0.6),
                value: offset
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        offset = .zero // Springs back
                    }
            )
    }
}
```

**Pull-to-refresh spring:**

```swift
struct PullToRefresh: View {
    @State private var pullOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var isRefreshing = false

    var body: some View {
        VStack(spacing: 0) {
            // Refresh indicator
            ProgressView()
                .scaleEffect(min(pullOffset / 60, 1))
                .frame(height: pullOffset)
                .opacity(pullOffset / 60)

            // Content
            ScrollView {
                LazyVStack {
                    ForEach(0..<50) { i in
                        Text("Row \(i)")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
        }
        .animation(
            isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.7),
            value: pullOffset
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    if value.translation.height > 0 {
                        // Rubber band effect
                        pullOffset = rubberBand(value.translation.height, limit: 150)
                    }
                }
                .onEnded { value in
                    isDragging = false
                    if pullOffset > 60 {
                        // Trigger refresh
                        isRefreshing = true
                        pullOffset = 60 // Hold at threshold
                        // Simulate refresh
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isRefreshing = false
                            pullOffset = 0 // Spring back
                        }
                    } else {
                        pullOffset = 0 // Spring back
                    }
                }
        )
    }

    private func rubberBand(_ value: CGFloat, limit: CGFloat) -> CGFloat {
        limit * (1 - exp(-value / limit))
    }
}
```

**Button press spring:**

```swift
struct SpringButton: View {
    @GestureState private var isPressed = false

    var body: some View {
        Text("Press Me")
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            // Spring animation on release (automatic with @GestureState)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, transaction in
                        state = true
                        transaction.animation = .spring(response: 0.2, dampingFraction: 0.5)
                    }
            )
    }
}
```

**Bouncy spring for playful UI:**

```swift
struct BouncyCard: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        CardContent()
            .offset(offset)
            .animation(
                isDragging
                    ? nil
                    // Extra bouncy spring for playful feel
                    : .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0),
                value: offset
            )
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
}
```

**Spring parameters for different feels:**
| Response | Damping | Feel |
|----------|---------|------|
| 0.3 | 0.8 | Quick, professional |
| 0.35 | 0.6 | Balanced, natural |
| 0.4 | 0.5 | Playful, bouncy |
| 0.5 | 0.4 | Dramatic, fun |

Reference: [Spring Animation](https://developer.apple.com/documentation/swiftui/spring)
