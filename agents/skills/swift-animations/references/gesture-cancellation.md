---
title: Handle Gesture Cancellation Gracefully
impact: MEDIUM
impactDescription: cancelled gestures should return to valid state
tags: gesture, cancellation, reset, interrupt, recovery
---

## Handle Gesture Cancellation Gracefully

Gestures can be interrupted by system events (incoming calls, notifications) or user actions (moving finger off view). Always ensure your UI returns to a valid state when gestures are cancelled.

**@GestureState handles cancellation automatically:**

```swift
struct AutoCancelDrag: View {
    // Automatically resets when gesture is cancelled
    @GestureState private var offset: CGSize = .zero
    @GestureState private var isDragging = false

    var body: some View {
        Circle()
            .fill(isDragging ? .blue : .gray)
            .frame(width: 80, height: 80)
            .offset(offset)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: isDragging)
            .animation(.spring(response: 0.3), value: offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, state, _ in
                        state = value.translation
                    }
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
            )
    }
}
// If gesture is cancelled (user moves finger off screen), both offset
// and isDragging automatically reset to initial values
```

**Manual cancellation handling with @State:**

```swift
struct ManualCancelDrag: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Circle()
            .fill(isDragging ? .blue : .gray)
            .frame(width: 80, height: 80)
            .offset(offset)
            .animation(isDragging ? nil : .spring(response: 0.3), value: offset)
            .animation(.spring(response: 0.3), value: isDragging)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { _ in
                        // Reset on normal end
                        isDragging = false
                        offset = .zero
                    }
            )
            // Handle scene phase changes (app backgrounding, etc.)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase != .active {
                    // Reset if app goes to background during gesture
                    withAnimation(.spring(response: 0.3)) {
                        isDragging = false
                        offset = .zero
                    }
                }
            }
    }

    @Environment(\.scenePhase) private var scenePhase
}
```

**Swipe-to-delete with undo opportunity:**

```swift
struct SwipeToDeleteRow: View {
    @State private var offsetX: CGFloat = 0
    @State private var isDragging = false
    @State private var isDeleting = false
    let deleteThreshold: CGFloat = -150

    var body: some View {
        HStack {
            RowContent()
                .frame(maxWidth: .infinity)

            // Delete button revealed behind
            Button("Delete") {
                confirmDelete()
            }
            .frame(width: abs(min(offsetX, 0)))
            .opacity(offsetX < -50 ? 1 : 0)
        }
        .offset(x: max(offsetX, deleteThreshold))
        .animation(isDragging ? nil : .spring(response: 0.3), value: offsetX)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    // Only allow left swipe
                    if value.translation.width < 0 {
                        offsetX = value.translation.width
                    }
                }
                .onEnded { value in
                    isDragging = false

                    if offsetX < deleteThreshold {
                        // Snap to show delete button
                        offsetX = deleteThreshold
                    } else if offsetX < -50 {
                        // Partial swipe - snap to show button
                        offsetX = -80
                    } else {
                        // Not enough - cancel and reset
                        offsetX = 0
                    }
                }
        )
        // Tap elsewhere to cancel
        .onTapGesture {
            if offsetX != 0 {
                withAnimation(.spring(response: 0.3)) {
                    offsetX = 0
                }
            }
        }
    }

    private func confirmDelete() {
        // Implement delete
    }
}
```

**Long press with cancellation feedback:**

```swift
struct CancellableLongPress: View {
    @State private var progress: CGFloat = 0
    @State private var isHolding = false
    @State private var didCancel = false

    var body: some View {
        Circle()
            .fill(didCancel ? .red : (isHolding ? .blue : .gray))
            .frame(width: 80, height: 80)
            .overlay {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.white, lineWidth: 4)
                    .rotationEffect(.degrees(-90))
            }
            .scaleEffect(isHolding ? 0.95 : 1.0)
            .animation(.spring(response: 0.2), value: isHolding)
            .onLongPressGesture(minimumDuration: 1) {
                // Completed
            } onPressingChanged: { isPressing in
                isHolding = isPressing
                if isPressing {
                    didCancel = false
                    withAnimation(.linear(duration: 1)) {
                        progress = 1
                    }
                } else if progress < 1 {
                    // Cancelled before completion
                    didCancel = true
                    withAnimation(.spring(response: 0.3)) {
                        progress = 0
                    }
                    // Reset cancel indicator
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        didCancel = false
                    }
                }
            }
    }
}
```

Reference: [GestureState](https://developer.apple.com/documentation/swiftui/gesturestate)
