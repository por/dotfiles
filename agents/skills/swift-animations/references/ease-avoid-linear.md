---
title: Avoid Linear Easing for UI Animations
impact: CRITICAL
impactDescription: linear motion feels robotic and unnatural
tags: ease, linear, easing, ux, natural-motion
---

## Avoid Linear Easing for UI Animations

Linear easing moves at constant velocity, which looks mechanical and artificial. Real-world objects accelerate and decelerate—your animations should too. Reserve linear easing only for progress indicators or loading bars where constant motion is expected.

**Incorrect (linear feels unnatural):**

```swift
struct CardView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            // Content
        }
        .frame(height: isExpanded ? 300 : 100)
        .animation(.linear(duration: 0.3), value: isExpanded)
    }
}
// Movement feels robotic, like a machine, not a living interface
```

**Correct (easeOut feels natural):**

```swift
struct CardView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            // Content
        }
        .frame(height: isExpanded ? 300 : 100)
        .animation(.easeOut(duration: 0.3), value: isExpanded)
    }
}
// Movement feels responsive and organic
```

**Better (spring feels alive):**

```swift
struct CardView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            // Content
        }
        .frame(height: isExpanded ? 300 : 100)
        .animation(.spring(duration: 0.3, bounce: 0.2), value: isExpanded)
    }
}
// Spring animation creates the most natural, lively motion
```

**When linear IS appropriate:**
- Progress bars and loading indicators
- Continuous rotation animations (spinners)
- Animations where constant speed is intentional (scrolling tickers)

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
