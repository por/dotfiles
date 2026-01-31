---
title: Translate in Meaningful Directions
impact: MEDIUM
impactDescription: motion direction reinforces spatial relationships
tags: transform, translate, offset, direction, spatial
---

## Translate in Meaningful Directions

Translation direction should reinforce spatial relationships and user expectations. Elements should enter from where they logically originate and exit toward where they're going.

**Directional enter/exit:**

```swift
// Toast enters from top (where notifications come from)
struct TopToast: View {
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            ToastContent()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    )
                )
        }
    }
}

// Bottom sheet enters from bottom (physical metaphor)
struct BottomSheet: View {
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            SheetContent()
                .transition(.move(edge: .bottom))
        }
    }
}

// Side menu enters from its edge
struct SideMenu: View {
    @Binding var isOpen: Bool

    var body: some View {
        if isOpen {
            MenuContent()
                .transition(.move(edge: .leading))
        }
    }
}
```

**Offset for subtle feedback:**

```swift
// Items fade in with slight upward motion
struct FadeInList: View {
    @State private var isVisible = false
    let items: [Item]

    var body: some View {
        VStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ItemRow(item: item)
                    .opacity(isVisible ? 1 : 0)
                    // Slight upward motion creates "rising" effect
                    .offset(y: isVisible ? 0 : 15)
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                        value: isVisible
                    )
            }
        }
        .onAppear { isVisible = true }
    }
}
```

**Direction matches action:**

```swift
// Delete swipes away in direction of gesture
struct SwipeToDelete: View {
    @State private var offset: CGFloat = 0
    @State private var isDeleted = false

    var body: some View {
        ItemRow()
            .offset(x: offset)
            .opacity(isDeleted ? 0 : 1)
            .animation(.spring(response: 0.3), value: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            // Exit in same direction as swipe
                            withAnimation(.easeIn(duration: 0.2)) {
                                offset = -400
                                isDeleted = true
                            }
                        } else {
                            offset = 0
                        }
                    }
            )
    }
}
```

**Avoid directionless motion:**

```swift
// BAD: Random offset adds no meaning
.offset(y: isActive ? 10 : 0)
// Why is it moving down?

// GOOD: Offset indicates hierarchy
.offset(y: isSelected ? -5 : 0)
.shadow(radius: isSelected ? 8 : 2)
// Rising up indicates selection/prominence
```

Reference: [offset](https://developer.apple.com/documentation/swiftui/view/offset(x:y:))
