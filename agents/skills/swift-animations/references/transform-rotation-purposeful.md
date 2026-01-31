---
title: Apply Rotation with Purpose
impact: MEDIUM
impactDescription: rotation conveys meaning like direction or state
tags: transform, rotation, purpose, semantics, meaning
---

## Apply Rotation with Purpose

Rotation should communicate meaning—indicating direction, representing state changes, or mimicking real-world behavior. Arbitrary rotation distracts without adding value.

**Purposeful rotation examples:**

```swift
// Chevron indicating expandable state
struct ExpandableHeader: View {
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            Text("Details")
            Spacer()
            Image(systemName: "chevron.right")
                // Rotates to point down when expanded
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
                .animation(.spring(duration: 0.2), value: isExpanded)
        }
        .onTapGesture { isExpanded.toggle() }
    }
}

// Refresh indicator rotation
struct RefreshButton: View {
    @State private var isRefreshing = false

    var body: some View {
        Button(action: refresh) {
            Image(systemName: "arrow.clockwise")
                // Continuous rotation during refresh
                .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                .animation(
                    isRefreshing
                        ? .linear(duration: 1).repeatForever(autoreverses: false)
                        : .spring(duration: 0.3),
                    value: isRefreshing
                )
        }
    }
}
```

**Rotation for physical metaphors:**

```swift
// Card flip
struct FlippableCard: View {
    @State private var isFlipped = false

    var body: some View {
        CardContent(showBack: isFlipped)
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.spring(duration: 0.5, bounce: 0.2), value: isFlipped)
            .onTapGesture { isFlipped.toggle() }
    }
}

// Shake for error
struct ShakeableField: View {
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        TextField("Email", text: .constant(""))
            .offset(x: shakeOffset)
            .animation(
                .spring(response: 0.1, dampingFraction: 0.3),
                value: shakeOffset
            )
    }

    func shake() {
        shakeOffset = 10
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shakeOffset = -10
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                shakeOffset = 0
            }
        }
    }
}
```

**Avoid meaningless rotation:**

```swift
// BAD: Random rotation adds no meaning
.rotationEffect(.degrees(isActive ? 15 : 0))
// Why is this rotating? What does it communicate?

// GOOD: Rotation indicates toggle state
Image(systemName: isOn ? "checkmark" : "xmark")
    .rotationEffect(.degrees(isOn ? 0 : 180))
// Rotation reinforces the state change
```

**Small rotations for playfulness (sparingly):**

```swift
// Notification badge wiggle
struct WigglingBadge: View {
    @State private var rotation: Double = 0

    var body: some View {
        Badge()
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
                    rotation = 5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    rotation = 0
                }
            }
    }
}
// Small wiggle draws attention without being obnoxious
```

Reference: [rotationEffect](https://developer.apple.com/documentation/swiftui/view/rotationeffect(_:anchor:))
