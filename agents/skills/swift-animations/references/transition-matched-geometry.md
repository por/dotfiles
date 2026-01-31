---
title: Use matchedGeometryEffect Properly
impact: HIGH
impactDescription: shared element transitions create visual continuity
tags: transition, matched-geometry, shared-element, hero, continuity
---

## Use matchedGeometryEffect Properly

`matchedGeometryEffect` creates shared element transitions where a view appears to morph from one location/size to another. This maintains visual continuity across state changes.

**Basic matched geometry:**

```swift
struct HeroTransition: View {
    @Namespace private var animation
    @State private var isExpanded = false

    var body: some View {
        VStack {
            if isExpanded {
                // Expanded state
                ExpandedCard()
                    .matchedGeometryEffect(id: "card", in: animation)
            } else {
                // Collapsed state
                CollapsedCard()
                    .matchedGeometryEffect(id: "card", in: animation)
            }
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.35)) {
                isExpanded.toggle()
            }
        }
    }
}
```

**List to detail transition:**

```swift
struct PhotoGrid: View {
    @Namespace private var animation
    @State private var selectedPhoto: Photo?

    var body: some View {
        ZStack {
            // Grid view
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(photos) { photo in
                        if selectedPhoto?.id != photo.id {
                            PhotoThumbnail(photo: photo)
                                .matchedGeometryEffect(id: photo.id, in: animation)
                                .onTapGesture {
                                    withAnimation(.spring(duration: 0.3)) {
                                        selectedPhoto = photo
                                    }
                                }
                        }
                    }
                }
            }

            // Detail view overlay
            if let photo = selectedPhoto {
                PhotoDetail(photo: photo)
                    .matchedGeometryEffect(id: photo.id, in: animation)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedPhoto = nil
                        }
                    }
            }
        }
    }
}
```

**Matching specific properties:**

```swift
// Match only frame (position and size)
.matchedGeometryEffect(id: "card", in: animation, properties: .frame)

// Match only position
.matchedGeometryEffect(id: "card", in: animation, properties: .position)

// Match only size
.matchedGeometryEffect(id: "card", in: animation, properties: .size)
```

**Source vs non-source:**

```swift
struct SourceExample: View {
    @Namespace private var animation
    @State private var isInBox = true

    var body: some View {
        HStack {
            if isInBox {
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                    // isSource: true - this view's geometry is the "truth"
                    .matchedGeometryEffect(id: "circle", in: animation, isSource: true)
            }

            Spacer()

            Circle()
                .fill(.clear)
                .frame(width: 100, height: 100)
                // isSource: false - matches to the source's geometry
                .matchedGeometryEffect(id: "circle", in: animation, isSource: false)
                .overlay {
                    if !isInBox {
                        Circle()
                            .fill(.blue)
                            .matchedGeometryEffect(id: "circle", in: animation, isSource: true)
                    }
                }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isInBox.toggle()
            }
        }
    }
}
```

**Tab indicator with matched geometry:**

```swift
struct AnimatedTabs: View {
    @Namespace private var animation
    @State private var selectedTab = 0
    let tabs = ["Home", "Search", "Profile"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(tab) {
                    withAnimation(.spring(duration: 0.25)) {
                        selectedTab = index
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background {
                    if selectedTab == index {
                        Capsule()
                            .fill(.blue.opacity(0.2))
                            .matchedGeometryEffect(id: "tab", in: animation)
                    }
                }
            }
        }
    }
}
```

**Common pitfalls:**
- Both views must exist in hierarchy (one hidden) or use if/else
- IDs must be unique within the namespace
- Don't use with ScrollView child views directly
- Ensure animation is applied with withAnimation

Reference: [matchedGeometryEffect](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:))
