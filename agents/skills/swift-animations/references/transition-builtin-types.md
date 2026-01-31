---
title: Use Built-in Transition Types
impact: MEDIUM-HIGH
impactDescription: built-in transitions are optimized and consistent
tags: transition, builtin, opacity, scale, slide, move
---

## Use Built-in Transition Types

SwiftUI provides optimized built-in transitions for common patterns. These are well-tested, performant, and consistent with platform conventions.

**Available built-in transitions:**

```swift
// Opacity (fade in/out)
.transition(.opacity)

// Scale (grow/shrink from center)
.transition(.scale)

// Scale with custom parameters
.transition(.scale(scale: 0.9, anchor: .top))

// Slide (from leading edge)
.transition(.slide)

// Move from specific edge
.transition(.move(edge: .bottom))
.transition(.move(edge: .top))
.transition(.move(edge: .leading))
.transition(.move(edge: .trailing))

// Push (new in iOS 17) - pushes existing content
.transition(.push(from: .trailing))

// Blur replace (new in iOS 17)
.transition(.blurReplace)
```

**Basic usage pattern:**

```swift
struct TransitionDemo: View {
    @State private var showContent = false

    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation(.spring(duration: 0.3)) {
                    showContent.toggle()
                }
            }

            if showContent {
                ContentView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}
```

**Conditional transitions:**

```swift
struct ConditionalTransition: View {
    @State private var items: [Item] = []
    @State private var lastAction: Action = .none

    enum Action { case none, add, remove }

    var body: some View {
        ForEach(items) { item in
            ItemRow(item: item)
                .transition(lastAction == .add ? .move(edge: .trailing) : .move(edge: .leading))
        }
    }

    func addItem() {
        lastAction = .add
        withAnimation { items.append(Item()) }
    }

    func removeItem(_ item: Item) {
        lastAction = .remove
        withAnimation { items.removeAll { $0.id == item.id } }
    }
}
```

**Transition with animation:**

```swift
if showContent {
    ContentView()
        .transition(
            .scale(scale: 0.8)
            .animation(.spring(duration: 0.3, bounce: 0.2))
        )
}
```

**Important:** Transitions only work when views are added/removed from the hierarchy. They don't animate property changes on existing views.

```swift
// WORKS: View is added/removed
if showContent {
    ContentView()
        .transition(.opacity)
}

// DOESN'T WORK: View exists, only opacity changes
ContentView()
    .opacity(showContent ? 1 : 0) // Use .animation() instead
```

Reference: [Transition](https://developer.apple.com/documentation/swiftui/anytransition)
