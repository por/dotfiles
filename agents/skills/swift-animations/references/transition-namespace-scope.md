---
title: Manage @Namespace Lifecycle
impact: MEDIUM
impactDescription: proper namespace scoping prevents animation glitches
tags: transition, namespace, scope, lifecycle, matched-geometry
---

## Manage @Namespace Lifecycle

`@Namespace` must be declared in a view that persists across the transition. If the namespace owner disappears, matched geometry animations break. Understand scoping rules to avoid glitches.

**Correct: Namespace in parent view:**

```swift
struct ParentView: View {
    // Namespace declared here - persists during child transitions
    @Namespace private var animation
    @State private var showDetail = false
    @State private var selectedItem: Item?

    var body: some View {
        ZStack {
            // List view
            ListView(
                selectedItem: $selectedItem,
                namespace: animation
            )

            // Detail view
            if let item = selectedItem {
                DetailView(
                    item: item,
                    namespace: animation,
                    onDismiss: { selectedItem = nil }
                )
            }
        }
    }
}

struct ListView: View {
    @Binding var selectedItem: Item?
    var namespace: Namespace.ID

    var body: some View {
        ForEach(items) { item in
            ItemRow(item: item)
                .matchedGeometryEffect(id: item.id, in: namespace)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedItem = item
                    }
                }
        }
    }
}

struct DetailView: View {
    let item: Item
    var namespace: Namespace.ID
    let onDismiss: () -> Void

    var body: some View {
        ItemDetail(item: item)
            .matchedGeometryEffect(id: item.id, in: namespace)
            .onTapGesture {
                withAnimation(.spring()) {
                    onDismiss()
                }
            }
    }
}
```

**Wrong: Namespace in disappearing view:**

```swift
// BAD: Namespace disappears with the view
struct ProblematicView: View {
    @State private var showDetail = false

    var body: some View {
        if showDetail {
            DetailWithNamespace() // Has its own @Namespace - breaks!
        } else {
            ListWithNamespace()   // Has its own @Namespace - breaks!
        }
    }
}
```

**Passing namespace to child views:**

```swift
struct ContainerView: View {
    @Namespace private var heroAnimation

    var body: some View {
        NavigationStack {
            ChildView(namespace: heroAnimation)
        }
    }
}

struct ChildView: View {
    // Accept namespace as parameter
    var namespace: Namespace.ID

    var body: some View {
        ItemView()
            .matchedGeometryEffect(id: "item", in: namespace)
    }
}
```

**Multiple namespaces for different animation groups:**

```swift
struct MultiNamespaceView: View {
    @Namespace private var cardAnimation
    @Namespace private var headerAnimation
    @State private var expandedCard: Card?

    var body: some View {
        VStack {
            // Header animates separately
            HeaderView()
                .matchedGeometryEffect(id: "header", in: headerAnimation)

            // Cards animate in their own namespace
            ForEach(cards) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: cardAnimation)
            }
        }
    }
}
```

**NavigationStack considerations:**

```swift
struct NavigationExample: View {
    @Namespace private var animation
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            // Source view
            SourceList(namespace: animation, path: $path)
                .navigationDestination(for: Item.self) { item in
                    // Destination view
                    DetailView(item: item, namespace: animation)
                }
        }
    }
}
// Note: matchedGeometryEffect works with NavigationStack
// but the namespace must be in a view that persists
```

**Debugging namespace issues:**
- Animation not working? Check namespace is in persistent parent
- Glitchy animation? Ensure only one view uses each ID at a time
- No animation? Verify withAnimation wraps state change

Reference: [Namespace](https://developer.apple.com/documentation/swiftui/namespace)
