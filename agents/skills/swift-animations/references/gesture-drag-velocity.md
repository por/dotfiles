---
title: Use Velocity for Momentum Effects
impact: HIGH
impactDescription: velocity-aware gestures feel physically realistic
tags: gesture, drag, velocity, momentum, physics
---

## Use Velocity for Momentum Effects

The velocity at the end of a drag gesture determines momentum. Fast swipes should carry further than slow releases. This creates physically believable interactions.

**Velocity-aware dismissal:**

```swift
struct VelocityDismiss: View {
    @State private var offsetX: CGFloat = 0
    @State private var isDragging = false
    let dismissThreshold: CGFloat = 100
    let velocityThreshold: CGFloat = 500 // points per second

    var body: some View {
        CardContent()
            .offset(x: offsetX)
            .animation(isDragging ? nil : .spring(response: 0.3), value: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offsetX = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        let velocity = value.predictedEndLocation.x - value.location.x

                        // Dismiss if: dragged far enough OR flicked fast enough
                        if abs(offsetX) > dismissThreshold || abs(velocity) > velocityThreshold {
                            // Exit in direction of movement
                            offsetX = velocity > 0 ? 400 : -400
                        } else {
                            offsetX = 0
                        }
                    }
            )
    }
}
```

**Momentum scroll simulation:**

```swift
struct MomentumDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .offset(offset)
            .animation(isDragging ? nil : .spring(response: 0.5, dampingFraction: 0.8), value: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { value in
                        isDragging = false
                        // Use predicted end location for momentum
                        let predicted = CGSize(
                            width: value.predictedEndTranslation.width * 0.5, // Scale down
                            height: value.predictedEndTranslation.height * 0.5
                        )
                        // Animate to momentum position, then settle
                        offset = predicted
                        // After settling, return home
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(response: 0.4)) {
                                offset = .zero
                            }
                        }
                    }
            )
    }
}
```

**Velocity-based snap points:**

```swift
struct VelocitySnap: View {
    @State private var selectedIndex = 0
    @State private var offsetX: CGFloat = 0
    @State private var isDragging = false
    let cardWidth: CGFloat = 300
    let cardCount = 5

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(index: index)
                    .frame(width: cardWidth)
            }
        }
        .offset(x: -CGFloat(selectedIndex) * (cardWidth + 20) + offsetX)
        .animation(isDragging ? nil : .spring(response: 0.35, dampingFraction: 0.8), value: selectedIndex)
        .animation(isDragging ? nil : .spring(response: 0.35), value: offsetX)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    offsetX = value.translation.width
                }
                .onEnded { value in
                    isDragging = false
                    let velocity = value.predictedEndLocation.x - value.location.x

                    // High velocity = skip to next/previous
                    if velocity > 200 && selectedIndex > 0 {
                        selectedIndex -= 1
                    } else if velocity < -200 && selectedIndex < cardCount - 1 {
                        selectedIndex += 1
                    } else {
                        // Low velocity = snap based on position
                        let draggedCards = Int((-offsetX / (cardWidth + 20)).rounded())
                        selectedIndex = max(0, min(cardCount - 1, selectedIndex + draggedCards))
                    }
                    offsetX = 0
                }
        )
    }
}
```

**Accessing velocity:**
- `value.velocity` - Current velocity (CGSize)
- `value.predictedEndTranslation` - Where the gesture would end with momentum
- `value.predictedEndLocation` - Final location with momentum

Reference: [DragGesture.Value](https://developer.apple.com/documentation/swiftui/draggesture/value)
