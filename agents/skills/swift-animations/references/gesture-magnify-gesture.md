---
title: Implement Pinch-to-Zoom
impact: MEDIUM
impactDescription: magnification enables natural content exploration
tags: gesture, magnify, pinch, zoom, scale
---

## Implement Pinch-to-Zoom

`MagnifyGesture` (formerly `MagnificationGesture`) handles pinch-to-zoom interactions. Combine with proper bounds checking and animation for smooth, natural zooming.

**Basic magnification:**

```swift
struct ZoomableImage: View {
    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy: CGFloat = 1.0

    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * magnifyBy)
            .animation(.spring(response: 0.3), value: scale)
            .gesture(
                MagnifyGesture()
                    .updating($magnifyBy) { value, state, _ in
                        state = value.magnification
                    }
                    .onEnded { value in
                        scale *= value.magnification
                        // Clamp to reasonable bounds
                        scale = min(max(scale, 0.5), 4.0)
                    }
            )
    }
}
```

**With double-tap to reset:**

```swift
struct ZoomableWithReset: View {
    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy: CGFloat = 1.0

    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * magnifyBy)
            .animation(.spring(response: 0.3), value: scale)
            .gesture(
                MagnifyGesture()
                    .updating($magnifyBy) { value, state, _ in
                        state = value.magnification
                    }
                    .onEnded { value in
                        scale = min(max(scale * value.magnification, 0.5), 4.0)
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    scale = scale > 1 ? 1 : 2 // Toggle between 1x and 2x
                }
            }
    }
}
```

**Combined pan and zoom:**

```swift
struct PanZoomImage: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureState = GestureState()

    struct GestureState {
        var magnification: CGFloat = 1.0
        var offset: CGSize = .zero
    }

    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * gestureState.magnification)
            .offset(
                x: offset.width + gestureState.offset.width,
                y: offset.height + gestureState.offset.height
            )
            .animation(.spring(response: 0.3), value: scale)
            .animation(.spring(response: 0.3), value: offset)
            .gesture(
                SimultaneousGesture(
                    MagnifyGesture()
                        .updating($gestureState) { value, state, _ in
                            state.magnification = value.magnification
                        },
                    DragGesture()
                        .updating($gestureState) { value, state, _ in
                            state.offset = value.translation
                        }
                )
                .onEnded { value in
                    // Apply magnification
                    if let mag = value.first?.magnification {
                        scale *= mag
                        scale = min(max(scale, 0.5), 4.0)
                    }
                    // Apply offset
                    if let drag = value.second {
                        offset.width += drag.translation.width
                        offset.height += drag.translation.height
                    }
                }
            )
    }
}
```

**Anchor-aware zooming (zoom towards pinch center):**

```swift
struct AnchorZoom: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .center
    @GestureState private var magnifyBy: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            Image("photo")
                .resizable()
                .scaledToFit()
                .scaleEffect(scale * magnifyBy, anchor: anchor)
                .animation(.spring(response: 0.3), value: scale)
                .gesture(
                    MagnifyGesture()
                        .updating($magnifyBy) { value, state, _ in
                            state = value.magnification
                        }
                        .onChanged { value in
                            // Update anchor to gesture location
                            let location = value.startLocation
                            anchor = UnitPoint(
                                x: location.x / geometry.size.width,
                                y: location.y / geometry.size.height
                            )
                        }
                        .onEnded { value in
                            scale *= value.magnification
                            scale = min(max(scale, 0.5), 4.0)
                        }
                )
        }
    }
}
```

Reference: [MagnifyGesture](https://developer.apple.com/documentation/swiftui/magnifygesture)
