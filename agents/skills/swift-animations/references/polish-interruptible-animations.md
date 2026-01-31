---
title: Make Animations Interruptible
impact: HIGH
impactDescription: interruptible animations feel responsive to user
tags: polish, interruptible, responsive, spring, interruption
---

## Make Animations Interruptible

Animations should respond to new user input even while in progress. Spring animations are inherently interruptible—they smoothly redirect when the target changes mid-animation. This creates responsive, living interfaces.

**Spring animations are interruptible:**

```swift
struct InterruptibleToggle: View {
    @State private var isOn = false

    var body: some View {
        // Rapidly tapping interrupts and redirects smoothly
        Circle()
            .fill(isOn ? .green : .gray)
            .frame(width: 30)
            .offset(x: isOn ? 30 : -30)
            // Spring handles interruption gracefully
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}
```

**Non-interruptible animations feel broken:**

```swift
// BAD: Linear/easeOut with long duration
struct NonInterruptible: View {
    @State private var position: CGFloat = 0

    var body: some View {
        Circle()
            .offset(x: position)
            // Long ease animation: mid-tap creates jarring jump
            .animation(.easeOut(duration: 1.0), value: position)
            .onTapGesture {
                position = position == 0 ? 200 : 0
            }
    }
}
// Tapping rapidly causes abrupt direction changes

// GOOD: Spring handles interruption
struct Interruptible: View {
    @State private var position: CGFloat = 0

    var body: some View {
        Circle()
            .offset(x: position)
            // Spring smoothly redirects
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: position)
            .onTapGesture {
                position = position == 0 ? 200 : 0
            }
    }
}
```

**Gesture interruption:**

```swift
struct InterruptibleDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Circle()
            .frame(width: 80)
            .offset(offset)
            // During drag: no animation (direct tracking)
            // After drag: spring back (interruptible)
            .animation(
                isDragging ? nil : .spring(response: 0.35, dampingFraction: 0.7),
                value: offset
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        offset = .zero
                        // New drag during spring-back interrupts smoothly
                    }
            )
    }
}
```

**Maintaining velocity on interruption:**

```swift
struct VelocityPreserving: View {
    @State private var targetPosition: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        Circle()
            .frame(width: 50)
            .offset(x: targetPosition + dragOffset)
            // Spring preserves momentum when interrupted
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: targetPosition)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        // Include velocity in final position
                        let predictedEnd = value.predictedEndTranslation.width
                        targetPosition += predictedEnd * 0.3
                    }
            )
    }
}
```

**Button with interruptible press state:**

```swift
struct InterruptibleButton: View {
    @GestureState private var isPressed = false

    var body: some View {
        Text("Press Me")
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            // Quick spring allows rapid press/release
            .animation(.spring(response: 0.15, dampingFraction: 0.6), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
            )
    }
}
```

**Key principles:**
- Use springs for most interactive animations
- Keep response times short (0.2-0.4s) for better interruption feel
- Avoid completion handlers that assume animation finished
- Test by rapidly triggering state changes

Reference: [Spring Animation](https://developer.apple.com/documentation/swiftui/spring)
