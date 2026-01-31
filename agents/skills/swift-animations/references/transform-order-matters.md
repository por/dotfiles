---
title: Modifier Order Affects Output
impact: HIGH
impactDescription: SwiftUI applies modifiers in order, changing results
tags: transform, order, modifiers, composition, sequence
---

## Modifier Order Affects Output

SwiftUI applies view modifiers in the order they appear. For transforms, this means `scale` then `offset` produces different results than `offset` then `scale`. Understanding this is crucial for predictable animations.

**Order matters - scale then offset:**

```swift
struct ScaleThenOffset: View {
    @State private var isActive = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            // First: scale the view
            .scaleEffect(isActive ? 0.5 : 1.0)
            // Then: offset the scaled view (offset is in original coordinates)
            .offset(x: isActive ? 50 : 0)
            .animation(.spring(), value: isActive)
    }
}
// Offset of 50 moves the scaled-down view 50 points
```

**Offset then scale:**

```swift
struct OffsetThenScale: View {
    @State private var isActive = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            // First: offset the view
            .offset(x: isActive ? 50 : 0)
            // Then: scale (including the offset!)
            .scaleEffect(isActive ? 0.5 : 1.0)
            .animation(.spring(), value: isActive)
    }
}
// The offset is also scaled, so effective offset is 25 points
```

**Rotation and offset:**

```swift
// Rotate then offset - offset in rotated coordinate space
struct RotateThenOffset: View {
    @State private var isActive = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 50)
            .rotationEffect(.degrees(isActive ? 45 : 0))
            .offset(y: isActive ? -50 : 0)
            // Offset is applied after rotation, so "up" is diagonal
    }
}

// Offset then rotate - offset in original space, then rotate
struct OffsetThenRotate: View {
    @State private var isActive = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 50)
            .offset(y: isActive ? -50 : 0)
            .rotationEffect(.degrees(isActive ? 45 : 0))
            // Offset moves up, then entire thing rotates
    }
}
```

**Practical example - button press:**

```swift
// GOOD: Scale applies to entire button including offset position
struct CorrectButtonPress: View {
    @State private var isPressed = false

    var body: some View {
        Button("Press Me") { }
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            // Scale AFTER styling so everything scales uniformly
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.15), value: isPressed)
    }
}

// BAD: Scale before background creates weird effects
struct WeirdButtonPress: View {
    @State private var isPressed = false

    var body: some View {
        Button("Press Me") { }
            .padding()
            // Scale before background - only text scales!
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
```

**Animation and modifier order:**

```swift
// Animation modifier also follows order rules
struct AnimationOrder: View {
    @State private var isActive = false

    var body: some View {
        Rectangle()
            .scaleEffect(isActive ? 1.5 : 1.0)
            .animation(.spring(), value: isActive) // Animates scale
            .opacity(isActive ? 0.5 : 1.0)
            // Opacity NOT animated - animation modifier is above it
    }
}
```

Reference: [SwiftUI View Modifiers](https://developer.apple.com/documentation/swiftui/view-modifiers)
