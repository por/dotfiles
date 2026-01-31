---
title: Use .updating for Live Feedback
impact: MEDIUM
impactDescription: updating provides frame-by-frame gesture data
tags: gesture, updating, live, feedback, continuous
---

## Use .updating for Live Feedback

The `.updating(_:body:)` modifier provides continuous updates during a gesture, perfect for live visual feedback. Unlike `.onChanged`, it works with `@GestureState` for automatic reset.

**Basic updating pattern:**

```swift
struct LiveFeedbackDrag: View {
    @GestureState private var dragState = DragState.inactive

    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .dragging(let translation): return translation
            default: return .zero
            }
        }

        var isActive: Bool {
            switch self {
            case .inactive: return false
            default: return true
            }
        }
    }

    var body: some View {
        Circle()
            .fill(dragState.isActive ? .blue : .gray)
            .frame(width: 50, height: 50)
            .offset(dragState.translation)
            .scaleEffect(dragState.isActive ? 1.1 : 1.0)
            .animation(.spring(response: 0.2), value: dragState.isActive)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragState) { value, state, _ in
                        if value.translation == .zero {
                            state = .pressing
                        } else {
                            state = .dragging(translation: value.translation)
                        }
                    }
            )
    }
}
```

**Updating with transaction control:**

```swift
struct TransactionDrag: View {
    @GestureState private var offset: CGSize = .zero

    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 100, height: 100)
            .offset(offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, state, transaction in
                        state = value.translation
                        // Control the reset animation
                        transaction.animation = .spring(
                            response: 0.5,
                            dampingFraction: 0.6,
                            blendDuration: 0
                        )
                    }
            )
    }
}
```

**Multiple @GestureState updates:**

```swift
struct MultiStateDrag: View {
    @GestureState private var translation: CGSize = .zero
    @GestureState private var isDragging = false
    @GestureState private var startLocation: CGPoint? = nil

    var body: some View {
        Circle()
            .fill(isDragging ? .blue : .gray)
            .frame(width: 50, height: 50)
            .offset(translation)
            .animation(.spring(response: 0.15), value: isDragging)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation
                    }
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .updating($startLocation) { value, state, _ in
                        state = state ?? value.startLocation
                    }
            )
    }
}
```

**Comparing updating vs onChanged:**

```swift
// onChanged - use with @State
.onChanged { value in
    offset = value.translation  // Must manually reset in onEnded
}

// updating - use with @GestureState
.updating($offset) { value, state, transaction in
    state = value.translation  // Automatically resets when gesture ends
}
```

**When to use .updating:**
- Live visual feedback during gestures
- When you need automatic reset behavior
- Complex gesture states with multiple values

**When to use .onChanged:**
- When you need to persist values after gesture ends
- When combining with other state updates
- When you need access to the full gesture value

Reference: [Gesture updating](https://developer.apple.com/documentation/swiftui/gesture/updating(_:body:))
