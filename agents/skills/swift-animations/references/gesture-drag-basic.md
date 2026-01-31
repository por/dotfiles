---
title: Implement Smooth Drag Interactions
impact: HIGH
impactDescription: 1:1 tracking creates direct manipulation feel
tags: gesture, drag, tracking, manipulation, movement
---

## Implement Smooth Drag Interactions

Drag gestures should track the user's finger precisely, creating a sense of direct manipulation. The element should follow the touch point with zero perceptible lag, then animate smoothly when released.

**Basic drag implementation:**

```swift
struct DraggableCard: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .frame(width: 150, height: 200)
            .offset(offset)
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .shadow(radius: isDragging ? 12 : 6)
            // Only animate when NOT dragging (snap back)
            .animation(
                isDragging ? nil : .spring(response: 0.3, dampingFraction: 0.7),
                value: offset
            )
            .animation(.spring(response: 0.2), value: isDragging)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        // 1:1 tracking - no animation during drag
                        offset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        // Snap back with spring
                        offset = .zero
                    }
            )
    }
}
```

**Drag with lift effect:**

```swift
struct LiftableDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        CardContent()
            .offset(offset)
            // "Lift" effect when picked up
            .scaleEffect(isDragging ? 1.03 : 1.0)
            .shadow(
                color: .black.opacity(isDragging ? 0.3 : 0.1),
                radius: isDragging ? 20 : 5,
                y: isDragging ? 10 : 2
            )
            .zIndex(isDragging ? 1 : 0)
            .animation(isDragging ? nil : .spring(response: 0.35), value: offset)
            .animation(.spring(response: 0.25), value: isDragging)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDragging { isDragging = true }
                        offset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        offset = .zero
                    }
            )
    }
}
```

**Horizontal-only drag (swipe action):**

```swift
struct SwipeCard: View {
    @State private var offsetX: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        CardContent()
            .offset(x: offsetX)
            // Slight rotation based on drag
            .rotationEffect(.degrees(Double(offsetX) * 0.02))
            .animation(isDragging ? nil : .spring(), value: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        // Only horizontal movement
                        offsetX = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        // Decide: dismiss or snap back
                        if abs(value.translation.width) > 100 {
                            // Dismiss in direction of swipe
                            offsetX = value.translation.width > 0 ? 400 : -400
                        } else {
                            offsetX = 0
                        }
                    }
            )
    }
}
```

**Key principle:** Never animate during active drag (use `isDragging ? nil : animation`). The drag should feel directly connected to the finger.

Reference: [DragGesture](https://developer.apple.com/documentation/swiftui/draggesture)
