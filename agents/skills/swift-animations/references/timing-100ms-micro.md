---
title: Use 100ms for Micro-Interactions
impact: CRITICAL
impactDescription: near-instant feedback for small UI changes
tags: timing, duration, 100ms, micro-interaction, feedback
---

## Use 100ms for Micro-Interactions

Micro-interactions like button presses, toggle switches, and hover effects should be nearly instantaneous. 100ms (0.1 seconds) provides just enough animation to feel smooth without any perceptible delay.

**Incorrect (too slow for micro-feedback):**

```swift
struct PressableButton: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: { /* action */ }) {
            Text("Tap Me")
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeOut(duration: 0.3), value: isPressed)
    }
}
// 300ms feels laggy for immediate feedback
```

**Correct (snappy 100ms):**

```swift
struct PressableButton: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: { /* action */ }) {
            Text("Tap Me")
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
// Instant feedback feels connected to finger
```

**Spring for micro-interactions:**

```swift
.animation(.spring(response: 0.15, dampingFraction: 0.7), value: isPressed)
// Quick spring with minimal bounce
```

**Micro-interaction examples:**

```swift
// Toggle switch
struct MicroToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Capsule()
            .fill(isOn ? Color.green : Color.gray)
            .frame(width: 50, height: 30)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(.white)
                    .padding(2)
            }
            .animation(.spring(response: 0.15, dampingFraction: 0.8), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}

// Checkbox
struct MicroCheckbox: View {
    @Binding var isChecked: Bool

    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .font(.title2)
            .scaleEffect(isChecked ? 1.0 : 0.95)
            .animation(.easeOut(duration: 0.1), value: isChecked)
            .onTapGesture { isChecked.toggle() }
    }
}
```

**When NOT to use 100ms:**
- Larger UI changes that need to be tracked
- Content transitions where context matters
- Marketing/onboarding where attention is desired

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
