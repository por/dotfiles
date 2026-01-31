---
title: Use .id() for View Replacement Transitions
impact: HIGH
impactDescription: id changes trigger transitions without if/else
tags: transition, id, replacement, identity, animation
---

## Use .id() for View Replacement Transitions

The `.id()` modifier changes a view's identity, causing SwiftUI to treat it as a new view. This triggers transitions without needing if/else conditionals, useful for content that changes but stays structurally similar.

**Basic id-driven transition:**

```swift
struct ContentSwitcher: View {
    @State private var currentIndex = 0
    let contents = ["First", "Second", "Third"]

    var body: some View {
        VStack {
            Text(contents[currentIndex])
                .font(.largeTitle)
                .id(currentIndex) // New id = new view = transition triggers
                .transition(.opacity.combined(with: .scale))

            Button("Next") {
                withAnimation(.spring()) {
                    currentIndex = (currentIndex + 1) % contents.count
                }
            }
        }
    }
}
```

**Tab content with transitions:**

```swift
struct TabContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            // Tab bar
            HStack {
                ForEach(0..<3) { index in
                    Button("Tab \(index)") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedTab = index
                        }
                    }
                }
            }

            // Content with id-based transition
            TabContent(tab: selectedTab)
                .id(selectedTab)
                .transition(.opacity)
        }
    }
}
```

**Directional transitions with id:**

```swift
struct DirectionalTabs: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0

    var body: some View {
        TabContent(tab: selectedTab)
            .id(selectedTab)
            .transition(
                .asymmetric(
                    insertion: .move(edge: selectedTab > previousTab ? .trailing : .leading),
                    removal: .move(edge: selectedTab > previousTab ? .leading : .trailing)
                )
            )
            .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }

    func selectTab(_ tab: Int) {
        previousTab = selectedTab
        selectedTab = tab
    }
}
```

**Image carousel:**

```swift
struct ImageCarousel: View {
    @State private var currentImage = 0
    let images: [String]

    var body: some View {
        Image(images[currentImage])
            .resizable()
            .scaledToFit()
            .id(currentImage)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                )
            )
            .gesture(
                DragGesture()
                    .onEnded { value in
                        withAnimation(.spring(duration: 0.3)) {
                            if value.translation.width < -50 {
                                currentImage = min(currentImage + 1, images.count - 1)
                            } else if value.translation.width > 50 {
                                currentImage = max(currentImage - 1, 0)
                            }
                        }
                    }
            )
    }
}
```

**Counter with digit transition:**

```swift
struct AnimatedCounter: View {
    let value: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(String(value).map(String.init), id: \.self) { digit in
                Text(digit)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .id("\(value)-\(digit)") // Unique id per position
                    .transition(.push(from: .bottom))
            }
        }
        .animation(.spring(duration: 0.3), value: value)
    }
}
```

**When to use .id() vs if/else:**

```swift
// Use .id() when:
// - Same view type, different content
// - Index-based content switching
// - Simpler code structure

Text(items[index].title)
    .id(index)
    .transition(.opacity)

// Use if/else when:
// - Different view types
// - Need to completely remove view from hierarchy
// - Complex conditional logic

if isExpanded {
    ExpandedView()
        .transition(.scale)
} else {
    CollapsedView()
        .transition(.scale)
}
```

Reference: [View id](https://developer.apple.com/documentation/swiftui/view/id(_:))
