---
title: Animate Long Press States
impact: MEDIUM
impactDescription: progressive feedback shows long press progress
tags: gesture, long-press, progress, feedback, hold
---

## Animate Long Press States

Long press gestures should provide progressive visual feedback as the user holds. This confirms the gesture is being tracked and shows progress toward activation.

**Basic long press without feedback:**

```swift
struct BasicLongPress: View {
    var body: some View {
        Button("Hold Me") {
            // Triggered after long press
        }
        .onLongPressGesture {
            // Action
        }
    }
}
// User has no idea if gesture is working or how long to hold
```

**Long press with progressive feedback:**

```swift
struct ProgressiveLongPress: View {
    @State private var isDetecting = false
    @State private var didComplete = false

    var body: some View {
        Circle()
            .fill(didComplete ? .green : .blue)
            .frame(width: 80, height: 80)
            .scaleEffect(isDetecting ? 0.9 : 1.0)
            .overlay {
                // Progress ring
                Circle()
                    .trim(from: 0, to: isDetecting ? 1 : 0)
                    .stroke(.white, lineWidth: 3)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: isDetecting)
            }
            .animation(.spring(response: 0.2), value: isDetecting)
            .onLongPressGesture(minimumDuration: 0.5) {
                // Completed
                didComplete = true
            } onPressingChanged: { isPressing in
                isDetecting = isPressing
                if !isPressing {
                    didComplete = false
                }
            }
    }
}
```

**Hold to delete pattern:**

```swift
struct HoldToDelete: View {
    @State private var holdProgress: CGFloat = 0
    @State private var isHolding = false
    let deleteThreshold: CGFloat = 1.0

    var body: some View {
        HStack {
            Text("Item to delete")
            Spacer()
            Image(systemName: "trash")
                .foregroundStyle(holdProgress > 0.5 ? .red : .gray)
        }
        .padding()
        .background {
            GeometryReader { geo in
                Rectangle()
                    .fill(.red.opacity(0.3))
                    .frame(width: geo.size.width * holdProgress)
            }
        }
        .scaleEffect(isHolding ? 0.98 : 1.0)
        .animation(.spring(response: 0.2), value: isHolding)
        .onLongPressGesture(minimumDuration: 1.0) {
            // Delete action
        } onPressingChanged: { isPressing in
            isHolding = isPressing
            withAnimation(.linear(duration: 1.0)) {
                holdProgress = isPressing ? 1.0 : 0
            }
        }
    }
}
```

**Long press with haptic feedback:**

```swift
struct HapticLongPress: View {
    @State private var isHolding = false

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 80, height: 80)
            .scaleEffect(isHolding ? 0.9 : 1.0)
            .animation(.spring(response: 0.2), value: isHolding)
            .onLongPressGesture(minimumDuration: 0.5) {
                // Completed - strong haptic
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } onPressingChanged: { isPressing in
                isHolding = isPressing
                if isPressing {
                    // Started - light haptic
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}
```

Reference: [LongPressGesture](https://developer.apple.com/documentation/swiftui/longpressgesture)
