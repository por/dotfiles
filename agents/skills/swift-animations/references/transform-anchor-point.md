---
title: Set Anchor for Rotation/Scale Origin
impact: HIGH
impactDescription: anchor determines the fixed point during transforms
tags: transform, anchor, origin, rotation, scale
---

## Set Anchor for Rotation/Scale Origin

The anchor point is the fixed position around which rotations and scales occur. Changing the anchor dramatically affects how animations look and feel.

**Default center anchor:**

```swift
struct CenterRotation: View {
    @State private var isRotated = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 50)
            // Default anchor is .center
            .rotationEffect(.degrees(isRotated ? 45 : 0))
            .animation(.spring(), value: isRotated)
    }
}
// Rectangle rotates around its center point
```

**Corner anchor for door-like rotation:**

```swift
struct DoorRotation: View {
    @State private var isOpen = false

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 200)
            // Anchor at leading edge like a door hinge
            .rotationEffect(
                .degrees(isOpen ? -90 : 0),
                anchor: .leading
            )
            .animation(.spring(duration: 0.4), value: isOpen)
    }
}
// Rectangle swings open like a door
```

**Scale from corner for menu reveal:**

```swift
struct MenuReveal: View {
    @State private var isOpen = false

    var body: some View {
        MenuContent()
            // Scale from top-trailing (where menu button is)
            .scaleEffect(
                isOpen ? 1 : 0.9,
                anchor: .topTrailing
            )
            .opacity(isOpen ? 1 : 0)
            .animation(.spring(duration: 0.25), value: isOpen)
    }
}
// Menu appears to grow from the button location
```

**Different anchors for scale:**

```swift
struct AnchorComparison: View {
    @State private var scale: CGFloat = 1

    var body: some View {
        VStack(spacing: 40) {
            // Top-leading anchor
            Rectangle()
                .frame(width: 100, height: 50)
                .scaleEffect(scale, anchor: .topLeading)

            // Center anchor (default)
            Rectangle()
                .frame(width: 100, height: 50)
                .scaleEffect(scale, anchor: .center)

            // Bottom-trailing anchor
            Rectangle()
                .frame(width: 100, height: 50)
                .scaleEffect(scale, anchor: .bottomTrailing)
        }
        .animation(.spring(), value: scale)
    }
}
```

**Custom anchor with UnitPoint:**

```swift
struct CustomAnchor: View {
    @State private var isRotated = false
    @State private var tapLocation: CGPoint = .zero
    let size: CGSize = CGSize(width: 200, height: 200)

    var body: some View {
        Rectangle()
            .frame(width: size.width, height: size.height)
            .rotationEffect(
                .degrees(isRotated ? 15 : 0),
                // Rotate around tap location
                anchor: UnitPoint(
                    x: tapLocation.x / size.width,
                    y: tapLocation.y / size.height
                )
            )
            .animation(.spring(), value: isRotated)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        tapLocation = value.location
                        isRotated.toggle()
                    }
            )
    }
}
```

**Anchor reference:**

| Anchor | UnitPoint | Description |
|--------|-----------|-------------|
| `.topLeading` | (0, 0) | Top-left corner |
| `.top` | (0.5, 0) | Top center |
| `.topTrailing` | (1, 0) | Top-right corner |
| `.leading` | (0, 0.5) | Left center |
| `.center` | (0.5, 0.5) | Center (default) |
| `.trailing` | (1, 0.5) | Right center |
| `.bottomLeading` | (0, 1) | Bottom-left |
| `.bottom` | (0.5, 1) | Bottom center |
| `.bottomTrailing` | (1, 1) | Bottom-right |

Reference: [UnitPoint](https://developer.apple.com/documentation/swiftui/unitpoint)
