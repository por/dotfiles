---
title: Respect accessibilityReduceMotion
impact: HIGH
impactDescription: essential accessibility for motion-sensitive users
tags: polish, accessibility, reduce-motion, a11y, vestibular
---

## Respect accessibilityReduceMotion

Some users experience discomfort, dizziness, or nausea from screen motion due to vestibular disorders. SwiftUI's `accessibilityReduceMotion` environment value lets you adapt animations for these users.

**Basic reduced motion check:**

```swift
struct AnimatedCard: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isVisible = false

    var body: some View {
        CardContent()
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : (reduceMotion ? 1 : 0.9))
            .offset(y: isVisible ? 0 : (reduceMotion ? 0 : 20))
            .animation(
                reduceMotion ? .none : .spring(duration: 0.3),
                value: isVisible
            )
    }
}
```

**Creating adaptive animations:**

```swift
extension Animation {
    static func adaptive(
        animation: Animation,
        reducedMotion: Animation? = nil
    ) -> Animation {
        // Note: This is called with the current reduce motion setting
        reducedMotion ?? animation
    }
}

struct AdaptiveView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ContentView()
            .animation(
                reduceMotion ? .easeOut(duration: 0.1) : .spring(duration: 0.3, bounce: 0.3),
                value: state
            )
    }
}
```

**Don't remove ALL animation:**

```swift
// BAD: Removing all animation is jarring
struct BadReducedMotion: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        if reduceMotion {
            // No animation at all - state changes are confusing
            ContentView()
        } else {
            ContentView()
                .animation(.spring(), value: state)
        }
    }
}

// GOOD: Replace with subtle crossfade
struct GoodReducedMotion: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ContentView()
            .animation(
                reduceMotion
                    ? .easeOut(duration: 0.15) // Simple fade
                    : .spring(duration: 0.3, bounce: 0.2), // Full animation
                value: state
            )
    }
}
```

**Reduced motion alternatives:**

```swift
struct ReducedMotionAlternatives: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        // Instead of: scale + move + fade
        if reduceMotion {
            // Use: simple fade
            ContentView()
                .transition(.opacity.animation(.easeOut(duration: 0.15)))
        } else {
            ContentView()
                .transition(.scale.combined(with: .opacity).combined(with: .move(edge: .bottom)))
        }
    }
}
```

**Transitions for reduced motion:**

```swift
extension AnyTransition {
    static func adaptive(
        full: AnyTransition,
        reduced: AnyTransition = .opacity
    ) -> AnyTransition {
        // Can't access environment here, so use at call site
        full
    }
}

struct TransitionView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        if isVisible {
            ContentView()
                .transition(
                    reduceMotion
                        ? .opacity.animation(.easeOut(duration: 0.15))
                        : .scale.combined(with: .opacity).animation(.spring())
                )
        }
    }
}
```

**Loading indicators:**

```swift
struct AccessibleLoader: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isAnimating = false

    var body: some View {
        if reduceMotion {
            // Static or minimal animation
            ProgressView()
        } else {
            // Full spinner animation
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(lineWidth: 3)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear { isAnimating = true }
        }
    }
}
```

**Key guidelines:**
- Never remove all animation—use simple fades instead
- Reduce or eliminate motion that covers large distances
- Keep small, functional animations (button press feedback)
- Avoid parallax, zooming, and spinning for reduced motion users

Reference: [Accessibility - Motion](https://developer.apple.com/design/human-interface-guidelines/accessibility#Motion)
