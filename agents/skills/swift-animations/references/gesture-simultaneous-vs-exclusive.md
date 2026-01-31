---
title: Choose Gesture Composition Strategy
impact: HIGH
impactDescription: proper composition prevents gesture conflicts
tags: gesture, simultaneous, exclusive, composition, priority
---

## Choose Gesture Composition Strategy

SwiftUI provides different ways to compose gestures: simultaneous, sequential, and exclusive. Choosing the right composition prevents conflicts and creates intuitive interactions.

**simultaneousGesture - both can activate:**

```swift
struct TapAndDrag: View {
    @State private var isPressed = false
    @State private var offset: CGSize = .zero

    var body: some View {
        Circle()
            .fill(isPressed ? .blue : .gray)
            .frame(width: 80, height: 80)
            .offset(offset)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            // Primary: drag
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
            // Simultaneous: press detection alongside drag
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}
```

**highPriorityGesture - this wins:**

```swift
struct HighPriorityExample: View {
    var body: some View {
        Button("Button in Parent") {
            print("Button tapped")
        }
        // Parent's gesture takes priority over child button
        .highPriorityGesture(
            TapGesture()
                .onEnded {
                    print("Parent gesture wins")
                }
        )
    }
}
```

**sequenced - one then another:**

```swift
struct LongPressThenDrag: View {
    @State private var isActivated = false
    @State private var offset: CGSize = .zero

    var body: some View {
        Circle()
            .fill(isActivated ? .blue : .gray)
            .frame(width: 80, height: 80)
            .offset(offset)
            .animation(.spring(), value: offset)
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .sequenced(before: DragGesture())
                    .onChanged { value in
                        switch value {
                        case .first(true):
                            // Long press recognized
                            isActivated = true
                        case .second(true, let drag):
                            // Now dragging
                            if let drag = drag {
                                offset = drag.translation
                            }
                        default:
                            break
                        }
                    }
                    .onEnded { _ in
                        isActivated = false
                        offset = .zero
                    }
            )
    }
}
```

**Exclusive gestures:**

```swift
struct ExclusiveGestures: View {
    @State private var tapCount = 0
    @State private var doubleTapCount = 0

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 100, height: 100)
            .onTapGesture(count: 2) {
                // Double tap (checked first due to count)
                doubleTapCount += 1
            }
            .onTapGesture {
                // Single tap (only if double tap didn't trigger)
                tapCount += 1
            }
    }
}
```

**Gesture masks:**

```swift
struct MaskedGesture: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    ItemRow(index: index)
                        // Only recognize horizontal drags, let vertical scroll through
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Handle horizontal swipe
                                }
                        )
                        .gestureMask(.subviews) // Or .all, .none
                }
            }
        }
    }
}
```

**Decision guide:**
| Scenario | Composition |
|----------|-------------|
| Press feedback + drag | `simultaneousGesture` |
| Parent overrides child | `highPriorityGesture` |
| Long press to enable drag | `.sequenced(before:)` |
| Single vs double tap | Order matters (more taps first) |

Reference: [Composing Gestures](https://developer.apple.com/documentation/swiftui/composing-swiftui-gestures)
