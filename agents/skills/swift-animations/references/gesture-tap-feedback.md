---
title: Provide Immediate Tap Feedback
impact: HIGH
impactDescription: instant feedback confirms touch registration
tags: gesture, tap, feedback, press, response
---

## Provide Immediate Tap Feedback

Taps should provide immediate visual feedback to confirm the touch was registered. Even a subtle scale or opacity change tells users their action was recognized, making the interface feel responsive.

**No feedback (feels broken):**

```swift
struct NoFeedbackButton: View {
    var body: some View {
        Button("Submit") {
            // Action
        }
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
// Button action works but feels unresponsive without visual change
```

**With press feedback (feels alive):**

```swift
struct ResponsiveButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Submit") {
            // Action
        }
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .opacity(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.15, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
// Immediate visual response confirms touch
```

**Using ButtonStyle for reusability:**

```swift
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.15, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// Usage
Button("Submit") { }
    .buttonStyle(PressableButtonStyle())
```

**Card tap feedback:**

```swift
struct TappableCard: View {
    @State private var isPressed = false

    var body: some View {
        CardContent()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(radius: isPressed ? 4 : 8)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .onTapGesture {
                // Handle tap
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}
```

**Highlight feedback for list rows:**

```swift
struct TappableRow: View {
    @State private var isPressed = false

    var body: some View {
        HStack {
            Text("Row Content")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(isPressed ? Color.gray.opacity(0.2) : Color.clear)
        .animation(.easeOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

Reference: [Gestures](https://developer.apple.com/documentation/swiftui/gestures)
