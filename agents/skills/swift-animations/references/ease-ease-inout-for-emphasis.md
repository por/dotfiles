---
title: Use easeInOut for Emphasis Motion
impact: MEDIUM
impactDescription: symmetric easing draws attention to movement
tags: ease, ease-in-out, emphasis, attention, on-screen
---

## Use easeInOut for Emphasis Motion

The easeInOut curve accelerates then decelerates symmetrically, drawing attention to the entire motion path. Use this for animations where the movement itself communicates meaning, not just the start or end state.

**When to use easeInOut:**

```swift
struct PulsingIndicator: View {
    @State private var isHighlighted = false

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .scaleEffect(isHighlighted ? 1.2 : 1.0)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isHighlighted
            )
            .onAppear { isHighlighted = true }
    }
}
// Smooth breathing effect where the motion path matters
```

**Position shifting (on-screen element movement):**

```swift
struct SlidingContent: View {
    @State private var currentIndex = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                ContentCard(index: index)
                    .frame(width: UIScreen.main.bounds.width)
            }
        }
        .offset(x: -CGFloat(currentIndex) * UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.35), value: currentIndex)
    }
}
// Element moving from one position to another on screen
```

**When NOT to use easeInOut:**
- Enter animations (use easeOut)
- Exit animations (use easeIn)
- User-initiated feedback (use springs)
- Rapid micro-interactions

**Contrast with asymmetric timing:**

```swift
// BAD: easeInOut for enter
.animation(.easeInOut(duration: 0.3), value: isVisible)
// Slow start feels unresponsive to user action

// GOOD: easeOut for enter
.animation(.easeOut(duration: 0.3), value: isVisible)
// Fast start gives immediate feedback
```

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
