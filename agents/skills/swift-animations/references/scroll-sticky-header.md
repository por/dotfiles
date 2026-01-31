---
title: Implement Animated Sticky Headers
impact: MEDIUM
impactDescription: sticky headers provide context during scroll
tags: scroll, sticky, header, pin, context
---

## Implement Animated Sticky Headers

Sticky headers remain visible while scrolling, often transforming from a large hero state to a compact navigation bar. This maintains context and provides quick access to actions.

**Basic sticky header:**

```swift
struct StickyHeaderView: View {
    @State private var scrollOffset: CGFloat = 0
    let expandedHeight: CGFloat = 200
    let collapsedHeight: CGFloat = 60

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    // Spacer for header
                    Color.clear.frame(height: expandedHeight)

                    // Content with scroll tracking
                    LazyVStack {
                        ForEach(0..<50) { index in
                            ContentRow(index: index)
                        }
                    }
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ScrollOffsetKey.self,
                                value: -geometry.frame(in: .named("scroll")).minY
                            )
                        }
                    )
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }

            // Sticky header
            StickyHeader(
                scrollOffset: scrollOffset,
                expandedHeight: expandedHeight,
                collapsedHeight: collapsedHeight
            )
        }
    }
}

struct StickyHeader: View {
    let scrollOffset: CGFloat
    let expandedHeight: CGFloat
    let collapsedHeight: CGFloat

    var progress: CGFloat {
        min(1, max(0, scrollOffset / (expandedHeight - collapsedHeight)))
    }

    var body: some View {
        VStack {
            Spacer()

            HStack {
                // Title scales and moves
                Text("Profile")
                    .font(.system(size: lerp(32, 18, progress), weight: .bold))
                    .offset(x: lerp(0, 40, progress))

                Spacer()

                // Actions fade in
                if progress > 0.5 {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                    .opacity((progress - 0.5) * 2)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(height: lerp(expandedHeight, collapsedHeight, progress))
        .background(.regularMaterial.opacity(progress))
    }

    func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}
```

**Profile header with avatar:**

```swift
struct ProfileStickyHeader: View {
    @State private var scrollOffset: CGFloat = 0

    var avatarScale: CGFloat {
        let progress = min(1, max(0, scrollOffset / 150))
        return 1 - progress * 0.6
    }

    var avatarOffset: CGFloat {
        let progress = min(1, max(0, scrollOffset / 150))
        return progress * -80
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    Color.clear.frame(height: 200)

                    // Content
                    ProfileContent()
                }
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: -geo.frame(in: .named("scroll")).minY
                        )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }

            // Header
            VStack {
                // Avatar
                Circle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                    .scaleEffect(avatarScale)
                    .offset(y: avatarOffset)

                Text("John Doe")
                    .font(.title2.bold())
                    .opacity(1 - min(1, scrollOffset / 100))
            }
            .frame(height: max(60, 200 - scrollOffset))
            .frame(maxWidth: .infinity)
            .background(.regularMaterial.opacity(min(1, scrollOffset / 150)))
        }
    }
}
```

**Section sticky headers:**

```swift
struct SectionedList: View {
    let sections: [Section]

    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRow(item: item)
                        }
                    } header: {
                        SectionHeader(title: section.title)
                            .background(.regularMaterial)
                    }
                }
            }
        }
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
}
```

Reference: [LazyVStack pinnedViews](https://developer.apple.com/documentation/swiftui/lazyvstack)
