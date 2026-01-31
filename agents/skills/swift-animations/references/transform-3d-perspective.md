---
title: Use rotation3DEffect for Depth
impact: MEDIUM
impactDescription: 3D transforms add dimensionality and realism
tags: transform, 3d, rotation, perspective, depth
---

## Use rotation3DEffect for Depth

The `rotation3DEffect` modifier creates 3D rotation with perspective, adding depth and realism to animations. Use this for card flips, tilt effects, and spatial UI metaphors.

**Card flip animation:**

```swift
struct FlippableCard: View {
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            // Front side
            CardFront()
                .opacity(isFlipped ? 0 : 1)

            // Back side
            CardBack()
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(duration: 0.5, bounce: 0.2), value: isFlipped)
        .onTapGesture { isFlipped.toggle() }
    }
}
```

**Tilt on interaction:**

```swift
struct TiltableCard: View {
    @State private var tilt: CGSize = .zero

    var body: some View {
        CardContent()
            .rotation3DEffect(
                .degrees(Double(tilt.height) * 0.1),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(Double(-tilt.width) * 0.1),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.spring(response: 0.3), value: tilt)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        tilt = value.translation
                    }
                    .onEnded { _ in
                        tilt = .zero
                    }
            )
    }
}
```

**Page curl effect:**

```swift
struct PageCurl: View {
    @State private var curlAmount: Double = 0

    var body: some View {
        PageContent()
            .rotation3DEffect(
                .degrees(curlAmount),
                axis: (x: 0, y: 1, z: 0),
                anchor: .leading,
                anchorZ: 0,
                perspective: 0.3
            )
            .animation(.spring(duration: 0.4), value: curlAmount)
    }
}
```

**Understanding the parameters:**

```swift
.rotation3DEffect(
    .degrees(45),           // Rotation angle
    axis: (x: 0, y: 1, z: 0), // Rotation axis (y = horizontal flip)
    anchor: .center,        // Rotation anchor point
    anchorZ: 0,            // Z-axis anchor for perspective
    perspective: 0.5       // Perspective strength (0 = flat, 1 = extreme)
)
```

**Axis combinations:**
- `(x: 1, y: 0, z: 0)` - Rotates around horizontal axis (flip top-to-bottom)
- `(x: 0, y: 1, z: 0)` - Rotates around vertical axis (flip left-to-right)
- `(x: 0, y: 0, z: 1)` - Rotates in plane (same as `rotationEffect`)
- `(x: 1, y: 1, z: 0)` - Diagonal axis rotation

**Subtle depth for hover:**

```swift
// macOS hover effect
struct HoverCard: View {
    @State private var isHovered = false

    var body: some View {
        CardContent()
            .rotation3DEffect(
                .degrees(isHovered ? 5 : 0),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .animation(.spring(response: 0.25), value: isHovered)
            .onHover { isHovered = $0 }
    }
}
```

Reference: [rotation3DEffect](https://developer.apple.com/documentation/swiftui/view/rotation3deffect(_:axis:anchor:anchorz:perspective:))
