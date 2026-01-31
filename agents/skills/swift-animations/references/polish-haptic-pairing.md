---
title: Pair Animations with Haptic Feedback
impact: MEDIUM
impactDescription: haptics reinforce visual feedback physically
tags: polish, haptic, feedback, sensory, tactile
---

## Pair Animations with Haptic Feedback

Haptic feedback creates a physical connection to visual animations. When animation marks an important moment—a selection, completion, or threshold—pair it with appropriate haptics for a more immersive experience.

**iOS 17+ sensoryFeedback:**

```swift
struct HapticButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Tap Me") {
            // Action
        }
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.15), value: isPressed)
        // Haptic triggers with animation
        .sensoryFeedback(.impact(weight: .light), trigger: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

**Feedback intensity matching:**

```swift
struct MatchedFeedback: View {
    enum Action { case light, medium, heavy }
    @State private var lastAction: Action?

    var body: some View {
        VStack(spacing: 20) {
            // Subtle action: light feedback
            Button("Like") {
                lastAction = .light
            }
            .sensoryFeedback(.impact(weight: .light), trigger: lastAction)

            // Standard action: medium feedback
            Button("Add to Cart") {
                lastAction = .medium
            }
            .sensoryFeedback(.impact(weight: .medium), trigger: lastAction)

            // Important action: heavy feedback
            Button("Purchase") {
                lastAction = .heavy
            }
            .sensoryFeedback(.impact(weight: .heavy), trigger: lastAction)
        }
    }
}
```

**Success/Error states:**

```swift
struct SubmissionFeedback: View {
    enum State { case idle, success, error }
    @State private var state: State = .idle

    var body: some View {
        VStack {
            StatusIcon(state: state)
                .scaleEffect(state == .idle ? 1.0 : 1.2)
                .animation(.spring(duration: 0.3, bounce: 0.3), value: state)

            Button("Submit") {
                // Simulate result
                state = Bool.random() ? .success : .error
            }
        }
        .sensoryFeedback(.success, trigger: state == .success ? true : nil)
        .sensoryFeedback(.error, trigger: state == .error ? true : nil)
    }
}
```

**Selection feedback:**

```swift
struct SelectableList: View {
    @State private var selectedId: UUID?

    var body: some View {
        List(items) { item in
            ItemRow(item: item, isSelected: selectedId == item.id)
                .onTapGesture {
                    withAnimation(.spring(duration: 0.2)) {
                        selectedId = item.id
                    }
                }
        }
        // Selection change triggers haptic
        .sensoryFeedback(.selection, trigger: selectedId)
    }
}
```

**Threshold crossing:**

```swift
struct SliderWithThreshold: View {
    @State private var value: Double = 50
    @State private var crossedThreshold = false
    let threshold: Double = 75

    var body: some View {
        VStack {
            Slider(value: $value, in: 0...100)

            Text("Value: \(Int(value))")
                .foregroundStyle(value >= threshold ? .red : .primary)
                .fontWeight(value >= threshold ? .bold : .regular)
        }
        .onChange(of: value) { old, new in
            let wasBelowThreshold = old < threshold
            let isAboveThreshold = new >= threshold

            if wasBelowThreshold && isAboveThreshold {
                crossedThreshold = true
            } else if !wasBelowThreshold && !isAboveThreshold {
                crossedThreshold = false
            }
        }
        // Haptic when crossing threshold
        .sensoryFeedback(.impact(weight: .heavy), trigger: crossedThreshold)
    }
}
```

**Pre-iOS 17 UIKit haptics:**

```swift
struct LegacyHaptics: View {
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let notificationFeedback = UINotificationFeedbackGenerator()

    var body: some View {
        Button("Action") {
            // Prepare for immediate response
            lightImpact.prepare()

            // Trigger with animation
            withAnimation(.spring()) {
                // state change
            }
            lightImpact.impactOccurred()
        }
    }

    func showSuccess() {
        notificationFeedback.notificationOccurred(.success)
    }

    func showError() {
        notificationFeedback.notificationOccurred(.error)
    }
}
```

**Haptic-animation timing:**
- Trigger haptic at the START of the animation, not end
- Match haptic intensity to animation prominence
- Don't over-use haptics—reserve for meaningful moments
- Respect user's haptic settings

Reference: [sensoryFeedback](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:))
