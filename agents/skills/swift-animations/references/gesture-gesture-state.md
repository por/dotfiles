---
title: Use @GestureState for Transient Values
impact: HIGH
impactDescription: automatic reset simplifies gesture handling
tags: gesture, gesturestate, transient, reset, state
---

## Use @GestureState for Transient Values

`@GestureState` automatically resets to its initial value when a gesture ends. This is perfect for transient states like drag offsets or press states that should always return to a default when the user lifts their finger.

**Using @State (manual reset required):**

```swift
struct ManualResetDrag: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        Circle()
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        // Must manually reset
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
    }
}
// Works, but reset logic is separate from state declaration
```

**Using @GestureState (automatic reset):**

```swift
struct AutoResetDrag: View {
    @GestureState private var offset: CGSize = .zero

    var body: some View {
        Circle()
            .offset(offset)
            .animation(.spring(), value: offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, state, _ in
                        state = value.translation
                    }
            )
    }
}
// Automatically springs back when gesture ends
```

**Press state with @GestureState:**

```swift
struct PressableButton: View {
    @GestureState private var isPressed = false

    var body: some View {
        Button("Press Me") { }
            .padding()
            .background(isPressed ? .blue.opacity(0.8) : .blue)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.15), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
            )
    }
}
// isPressed automatically becomes false when finger lifts
```

**Combining with @State for persistent values:**

```swift
struct DragAndDrop: View {
    // Transient: resets automatically
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var isDragging = false

    // Persistent: keeps value after gesture
    @State private var position: CGSize = .zero

    var body: some View {
        Circle()
            .fill(isDragging ? .blue : .gray)
            .frame(width: 50, height: 50)
            .offset(x: position.width + dragOffset.width,
                    y: position.height + dragOffset.height)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(.spring(response: 0.2), value: isDragging)
            .animation(isDragging ? nil : .spring(), value: dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onEnded { value in
                        // Update persistent position
                        position.width += value.translation.width
                        position.height += value.translation.height
                    }
            )
    }
}
```

**Transaction parameter:**

```swift
@GestureState private var offset: CGSize = .zero

.gesture(
    DragGesture()
        .updating($offset) { value, state, transaction in
            state = value.translation
            // Customize the reset animation
            transaction.animation = .spring(response: 0.4, dampingFraction: 0.6)
        }
)
```

**When to use @GestureState vs @State:**
- `@GestureState`: Values that should reset when gesture ends (offsets, isPressed, isDragging)
- `@State`: Values that persist after gesture (final position, selection)

Reference: [GestureState](https://developer.apple.com/documentation/swiftui/gesturestate)
