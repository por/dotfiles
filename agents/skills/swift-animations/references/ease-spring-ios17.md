---
title: Use iOS 17 Spring Struct with Duration and Bounce
impact: HIGH
impactDescription: clearer mental model for spring configuration
tags: ease, spring, ios17, bounce, duration
---

## Use iOS 17 Spring Struct with Duration and Bounce

iOS 17 introduced a new `Spring` struct and simplified spring animation parameters. Instead of cryptic `response` and `dampingFraction`, use the intuitive `duration` and `bounce` parameters for easier tuning.

**Legacy approach (harder to understand):**

```swift
struct CardView: View {
    @State private var isFlipped = false

    var body: some View {
        CardContent()
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            // What does dampingFraction: 0.7 mean visually?
            .animation(
                .spring(response: 0.5, dampingFraction: 0.7),
                value: isFlipped
            )
    }
}
```

**iOS 17+ approach (intuitive parameters):**

```swift
struct CardView: View {
    @State private var isFlipped = false

    var body: some View {
        CardContent()
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            // duration: how long it feels, bounce: how much overshoot
            .animation(
                .spring(duration: 0.5, bounce: 0.3),
                value: isFlipped
            )
    }
}
```

**Spring bounce values:**
- `0.0` - No bounce, critically damped (smooth stop)
- `0.2` - Subtle bounce, professional feel
- `0.3-0.4` - Noticeable bounce, playful
- `0.5+` - Very bouncy, use sparingly

**Creating a reusable Spring:**

```swift
extension Spring {
    static let snappy = Spring(duration: 0.3, bounce: 0.15)
    static let bouncy = Spring(duration: 0.4, bounce: 0.35)
    static let smooth = Spring(duration: 0.35, bounce: 0)
}

// Usage
.animation(.spring(.snappy), value: state)
```

Reference: [Spring Struct](https://developer.apple.com/documentation/swiftui/spring)
