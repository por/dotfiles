---
title: Maintain Spatial Relationships
impact: MEDIUM
impactDescription: spatial continuity helps users track context
tags: strategy, spatial, continuity, navigation, context
---

## Maintain Spatial Relationships

Animation should preserve spatial relationships so users understand where content comes from and goes to. When navigating, elements should move in consistent directions that reinforce the mental model.

**Navigation direction consistency:**

```swift
struct NavigationExample: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ListView(path: $path)
                .navigationDestination(for: Item.self) { item in
                    DetailView(item: item)
                }
        }
    }
}
// Forward: content slides from trailing (right)
// Back: content slides from leading (left)
// This matches physical page metaphor
```

**Drill-down expansion:**

```swift
struct DrillDownList: View {
    @Namespace private var animation
    @State private var selectedItem: Item?

    var body: some View {
        ZStack {
            // List view
            if selectedItem == nil {
                ScrollView {
                    ForEach(items) { item in
                        ItemRow(item: item)
                            .matchedGeometryEffect(id: item.id, in: animation)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.35)) {
                                    selectedItem = item
                                }
                            }
                    }
                }
            }

            // Detail expands FROM the item's position
            if let item = selectedItem {
                DetailView(item: item)
                    .matchedGeometryEffect(id: item.id, in: animation)
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

**Tab switching direction:**

```swift
struct DirectionalTabs: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0

    var body: some View {
        VStack {
            // Tab bar
            HStack {
                ForEach(0..<4) { index in
                    TabButton(index: index, isSelected: selectedTab == index) {
                        previousTab = selectedTab
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedTab = index
                        }
                    }
                }
            }

            // Content with directional transition
            TabContent(index: selectedTab)
                .id(selectedTab)
                .transition(
                    .asymmetric(
                        // Moving right: content comes from right
                        // Moving left: content comes from left
                        insertion: .move(edge: selectedTab > previousTab ? .trailing : .leading),
                        removal: .move(edge: selectedTab > previousTab ? .leading : .trailing)
                    )
                )
        }
    }
}
```

**Modal from source element:**

```swift
struct SourceModal: View {
    @Namespace private var animation
    @State private var showModal = false

    var body: some View {
        ZStack {
            // Source button
            Button("Open Settings") {
                withAnimation(.spring(duration: 0.35)) {
                    showModal = true
                }
            }
            .matchedGeometryEffect(id: "modal", in: animation, isSource: !showModal)

            // Modal expands from button
            if showModal {
                ModalContent()
                    .matchedGeometryEffect(id: "modal", in: animation, isSource: true)
                    .transition(.opacity)
            }
        }
    }
}
```

**Card to detail expansion:**

```swift
struct CardExpansion: View {
    @Namespace private var namespace
    @State private var expandedCard: Card?

    var body: some View {
        ZStack {
            // Grid of cards
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(cards) { card in
                        if expandedCard?.id != card.id {
                            CardThumbnail(card: card)
                                .matchedGeometryEffect(id: card.id, in: namespace)
                                .onTapGesture {
                                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                                        expandedCard = card
                                    }
                                }
                        } else {
                            // Placeholder to maintain grid layout
                            Color.clear.frame(height: 200)
                        }
                    }
                }
            }
            .opacity(expandedCard == nil ? 1 : 0.3)

            // Expanded card
            if let card = expandedCard {
                CardDetail(card: card)
                    .matchedGeometryEffect(id: card.id, in: namespace)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.35)) {
                            expandedCard = nil
                        }
                    }
            }
        }
    }
}
```

**Key principles:**
- Forward navigation: content enters from direction of travel
- Back navigation: content enters from opposite direction
- Expansion: detail expands from source element
- Collapse: detail returns to source element
- Hierarchy: children come from parent's position

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
