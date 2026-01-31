---
title: Customize Navigation Transitions
impact: MEDIUM
impactDescription: custom navigation adds polish and brand identity
tags: transition, navigation, stack, push, pop
---

## Customize Navigation Transitions

iOS 18+ introduces `NavigationTransition` for custom push/pop animations. Earlier versions can use matched geometry or workarounds for custom navigation effects.

**iOS 18+ Custom Navigation Transition:**

```swift
struct CustomNavigationView: View {
    var body: some View {
        NavigationStack {
            ContentView()
                .navigationDestination(for: Item.self) { item in
                    DetailView(item: item)
                }
        }
        .navigationTransition(.zoom(sourceID: "item", in: namespace))
    }

    @Namespace private var namespace
}
```

**Built-in iOS 18+ transitions:**

```swift
// Zoom from source element
.navigationTransition(.zoom(sourceID: id, in: namespace))

// Slide (default)
.navigationTransition(.slide)

// Automatic (system decides)
.navigationTransition(.automatic)
```

**Pre-iOS 18 workaround with full-screen cover:**

```swift
struct CustomNavigation: View {
    @Namespace private var animation
    @State private var selectedItem: Item?

    var body: some View {
        ZStack {
            // List view (always present)
            ScrollView {
                ForEach(items) { item in
                    ItemRow(item: item)
                        .matchedGeometryEffect(
                            id: item.id,
                            in: animation,
                            isSource: selectedItem != item
                        )
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.35)) {
                                selectedItem = item
                            }
                        }
                }
            }
            .opacity(selectedItem == nil ? 1 : 0)

            // Detail view (overlay when selected)
            if let item = selectedItem {
                DetailView(item: item)
                    .matchedGeometryEffect(id: item.id, in: animation)
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.35)) {
                            selectedItem = nil
                        }
                    }
            }
        }
    }
}
```

**Slide direction based on hierarchy:**

```swift
struct DirectionalNavigation: View {
    @State private var currentLevel = 0

    var body: some View {
        ZStack {
            ForEach(0..<3) { level in
                if currentLevel == level {
                    LevelView(level: level)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: level > previousLevel ? .trailing : .leading),
                                removal: .move(edge: level > previousLevel ? .leading : .trailing)
                            )
                        )
                }
            }
        }
        .animation(.spring(duration: 0.3), value: currentLevel)
    }

    @State private var previousLevel = 0

    func navigate(to level: Int) {
        previousLevel = currentLevel
        currentLevel = level
    }
}
```

**Sheet with custom presentation:**

```swift
struct CustomSheetPresentation: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            SheetContent()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(20)
                .presentationBackground(.ultraThinMaterial)
        }
    }
}
```

**Interruptible navigation:**

```swift
struct InterruptibleNav: View {
    @State private var detailItem: Item?
    @State private var isTransitioning = false

    var body: some View {
        // Content
    }

    func showDetail(_ item: Item) {
        guard !isTransitioning else { return }
        isTransitioning = true

        withAnimation(.spring(duration: 0.35)) {
            detailItem = item
        }

        // Allow interruption after animation starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isTransitioning = false
        }
    }
}
```

Reference: [NavigationTransition](https://developer.apple.com/documentation/swiftui/navigationtransition)
