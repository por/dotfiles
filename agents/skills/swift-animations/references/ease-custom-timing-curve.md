---
title: Create Custom Curves with timingCurve
impact: HIGH
impactDescription: enables precise control over animation character
tags: ease, timing-curve, cubic-bezier, custom-easing
---

## Create Custom Curves with timingCurve

When built-in easing curves don't match your design intent, use `timingCurve(_:_:_:_:duration:)` to create custom cubic Bézier curves. This is the SwiftUI equivalent of CSS `cubic-bezier()`.

**Standard easeOut may be too generic:**

```swift
struct SheetView: View {
    @State private var offset: CGFloat = 300

    var body: some View {
        ContentView()
            .offset(y: offset)
            .animation(.easeOut(duration: 0.3), value: offset)
    }
}
// Works but doesn't match iOS system sheet feel
```

**Custom iOS-style sheet curve:**

```swift
struct SheetView: View {
    @State private var offset: CGFloat = 300

    var body: some View {
        ContentView()
            .offset(y: offset)
            .animation(
                .timingCurve(0.32, 0.72, 0, 1, duration: 0.5),
                value: offset
            )
    }
}
// Matches the native iOS sheet animation feel
```

**Common custom curves:**

```swift
extension Animation {
    // iOS sheet/drawer feel
    static let sheet = Animation.timingCurve(0.32, 0.72, 0, 1, duration: 0.5)

    // Snappy entrance
    static let snappyIn = Animation.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.2)

    // Dramatic emphasis
    static let dramatic = Animation.timingCurve(0.7, 0, 0.3, 1, duration: 0.4)
}
```

**Understanding the parameters:**
- Parameters map to control points: `(0, 0)` → `(x1, y1)` → `(x2, y2)` → `(1, 1)`
- First pair `(x1, y1)`: controls acceleration at start
- Second pair `(x2, y2)`: controls deceleration at end

**When to use custom curves:**
- Matching platform-specific animation feel
- Brand-specific motion design
- Unique interaction feedback

Reference: [Animation timingCurve](https://developer.apple.com/documentation/swiftui/animation/timingcurve(_:_:_:_:duration:))
