---
title: Configure Spring Damping for Bounce
impact: MEDIUM
impactDescription: damping controls overshoot and oscillation
tags: ease, spring, damping, bounce, overshoot
---

## Configure Spring Damping for Bounce

The spring `dampingFraction` (or `bounce` in iOS 17) controls how much the animation overshoots and oscillates before settling. Lower damping creates bouncier animations; higher damping creates smoother stops.

**Damping values explained:**

```swift
// High damping (0.8-1.0) - smooth, no bounce
.animation(.spring(response: 0.4, dampingFraction: 0.9), value: state)
// Use for: professional apps, data-heavy interfaces

// Medium damping (0.6-0.8) - subtle bounce
.animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
// Use for: general UI, balanced feel

// Low damping (0.4-0.6) - noticeable bounce
.animation(.spring(response: 0.4, dampingFraction: 0.5), value: state)
// Use for: playful apps, celebratory moments

// Very low damping (<0.4) - excessive bounce
.animation(.spring(response: 0.4, dampingFraction: 0.3), value: state)
// Use sparingly: games, special effects
```

**iOS 17 bounce equivalents:**

```swift
// dampingFraction: 0.9 ≈ bounce: 0.1
.animation(.spring(duration: 0.4, bounce: 0.1), value: state)

// dampingFraction: 0.7 ≈ bounce: 0.3
.animation(.spring(duration: 0.4, bounce: 0.3), value: state)

// dampingFraction: 0.5 ≈ bounce: 0.5
.animation(.spring(duration: 0.4, bounce: 0.5), value: state)
```

**Matching damping to context:**

```swift
struct ActionButton: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: performAction) {
            Text("Save")
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(
            // Subtle bounce for professional feel
            .spring(response: 0.25, dampingFraction: 0.75),
            value: isPressed
        )
    }
}

struct CelebrationBadge: View {
    @State private var isShowing = false

    var body: some View {
        BadgeView()
            .scaleEffect(isShowing ? 1.0 : 0.5)
            .animation(
                // More bounce for celebratory moment
                .spring(response: 0.4, dampingFraction: 0.55),
                value: isShowing
            )
    }
}
```

**When to avoid bounce:**
- Financial/medical apps where precision matters
- Reduced motion accessibility mode
- Frequently repeated interactions

Reference: [Spring Animation](https://developer.apple.com/documentation/swiftui/spring)
