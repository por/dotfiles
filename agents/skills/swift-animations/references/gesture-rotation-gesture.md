---
title: Implement Rotation Gestures
impact: MEDIUM
impactDescription: rotation enables natural object manipulation
tags: gesture, rotation, rotate, twist, manipulation
---

## Implement Rotation Gestures

`RotateGesture` (formerly `RotationGesture`) handles two-finger rotation. Combine with magnification and drag for complete object manipulation.

**Basic rotation:**

```swift
struct RotatableView: View {
    @State private var angle: Angle = .zero
    @GestureState private var rotationAngle: Angle = .zero

    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 150, height: 150)
            .rotationEffect(angle + rotationAngle)
            .animation(.spring(response: 0.3), value: angle)
            .gesture(
                RotateGesture()
                    .updating($rotationAngle) { value, state, _ in
                        state = value.rotation
                    }
                    .onEnded { value in
                        angle += value.rotation
                    }
            )
    }
}
```

**Rotation with snap points:**

```swift
struct SnapRotation: View {
    @State private var angle: Angle = .zero
    @GestureState private var rotationAngle: Angle = .zero

    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 150, height: 150)
            .rotationEffect(snappedAngle)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: angle)
            .gesture(
                RotateGesture()
                    .updating($rotationAngle) { value, state, _ in
                        state = value.rotation
                    }
                    .onEnded { value in
                        let newAngle = angle + value.rotation
                        // Snap to nearest 90 degrees
                        let snapped = round(newAngle.degrees / 90) * 90
                        angle = .degrees(snapped)
                    }
            )
    }

    private var snappedAngle: Angle {
        // During gesture, show actual rotation
        angle + rotationAngle
    }
}
```

**Combined rotation, scale, and drag:**

```swift
struct FullManipulation: View {
    @State private var rotation: Angle = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    @GestureState private var gestureRotation: Angle = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureOffset: CGSize = .zero

    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 100))
            .foregroundStyle(.yellow)
            .rotationEffect(rotation + gestureRotation)
            .scaleEffect(scale * gestureScale)
            .offset(
                x: offset.width + gestureOffset.width,
                y: offset.height + gestureOffset.height
            )
            .animation(.spring(response: 0.3), value: rotation)
            .animation(.spring(response: 0.3), value: scale)
            .animation(.spring(response: 0.3), value: offset)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        RotateGesture()
                            .updating($gestureRotation) { value, state, _ in
                                state = value.rotation
                            },
                        MagnifyGesture()
                            .updating($gestureScale) { value, state, _ in
                                state = value.magnification
                            }
                    ),
                    DragGesture()
                        .updating($gestureOffset) { value, state, _ in
                            state = value.translation
                        }
                )
                .onEnded { value in
                    if let rotation = value.first?.first?.rotation {
                        self.rotation += rotation
                    }
                    if let scale = value.first?.second?.magnification {
                        self.scale *= scale
                        self.scale = min(max(self.scale, 0.5), 3.0)
                    }
                    if let drag = value.second {
                        offset.width += drag.translation.width
                        offset.height += drag.translation.height
                    }
                }
            )
    }
}
```

**Double-tap to reset rotation:**

```swift
struct ResettableRotation: View {
    @State private var angle: Angle = .zero
    @GestureState private var rotationAngle: Angle = .zero

    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 150, height: 150)
            .rotationEffect(angle + rotationAngle)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: angle)
            .gesture(
                RotateGesture()
                    .updating($rotationAngle) { value, state, _ in
                        state = value.rotation
                    }
                    .onEnded { value in
                        angle += value.rotation
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    angle = .zero
                }
            }
    }
}
```

Reference: [RotateGesture](https://developer.apple.com/documentation/swiftui/rotategesture)
