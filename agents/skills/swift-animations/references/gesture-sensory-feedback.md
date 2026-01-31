---
title: Pair Gestures with Haptic Feedback
impact: HIGH
impactDescription: haptics reinforce gesture recognition physically
tags: gesture, haptic, feedback, sensory, tactile
---

## Pair Gestures with Haptic Feedback

Haptic feedback creates a physical connection between gestures and animations. A subtle vibration when snapping, selecting, or completing an action makes interactions feel more substantial.

**iOS 17+ sensoryFeedback modifier:**

```swift
struct HapticButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Tap Me") {
            // Action
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.15), value: isPressed)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

**Feedback types:**

```swift
// Light feedback for subtle interactions
.sensoryFeedback(.impact(weight: .light), trigger: value)

// Medium for standard interactions
.sensoryFeedback(.impact(weight: .medium), trigger: value)

// Heavy for significant actions
.sensoryFeedback(.impact(weight: .heavy), trigger: value)

// Selection feedback for picker-like interactions
.sensoryFeedback(.selection, trigger: selectedIndex)

// Success/warning/error for completion states
.sensoryFeedback(.success, trigger: didComplete)
.sensoryFeedback(.warning, trigger: showWarning)
.sensoryFeedback(.error, trigger: showError)
```

**Snap point haptics:**

```swift
struct SnapWithHaptics: View {
    @State private var offsetY: CGFloat = 0
    @State private var snapIndex = 0
    let snapPoints: [CGFloat] = [0, 200, 400]

    var body: some View {
        SheetContent()
            .offset(y: offsetY)
            .sensoryFeedback(.impact(weight: .medium), trigger: snapIndex)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offsetY = value.translation.height
                    }
                    .onEnded { value in
                        let nearest = snapPoints.enumerated().min {
                            abs($0.element - offsetY) < abs($1.element - offsetY)
                        }
                        if let nearest = nearest {
                            withAnimation(.spring(response: 0.3)) {
                                offsetY = nearest.element
                            }
                            // Trigger haptic when snapping
                            snapIndex = nearest.offset
                        }
                    }
            )
    }
}
```

**Pre-iOS 17 UIKit haptics:**

```swift
struct LegacyHapticButton: View {
    @State private var isPressed = false
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        Button("Tap Me") {
            // Action
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        impactGenerator.impactOccurred()
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
```

**Toggle with selection feedback:**

```swift
struct HapticToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle("Feature", isOn: $isOn)
            .sensoryFeedback(.selection, trigger: isOn)
    }
}
```

**Drag threshold feedback:**

```swift
struct ThresholdDrag: View {
    @State private var offset: CGFloat = 0
    @State private var crossedThreshold = false
    let threshold: CGFloat = 100

    var body: some View {
        Rectangle()
            .fill(crossedThreshold ? .red : .blue)
            .frame(width: 100, height: 100)
            .offset(x: offset)
            .sensoryFeedback(.impact(weight: .heavy), trigger: crossedThreshold)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation.width
                        let newCrossed = abs(offset) > threshold
                        if newCrossed != crossedThreshold {
                            crossedThreshold = newCrossed
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = 0
                            crossedThreshold = false
                        }
                    }
            )
    }
}
```

Reference: [sensoryFeedback](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:))
