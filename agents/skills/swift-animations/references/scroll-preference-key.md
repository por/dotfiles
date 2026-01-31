---
title: Use PreferenceKey for Scroll Data
impact: MEDIUM
impactDescription: preferences bubble scroll data to parent views
tags: scroll, preference-key, data, parent, propagation
---

## Use PreferenceKey for Scroll Data

`PreferenceKey` passes data from child views up to ancestors. Combined with `GeometryReader`, this enables parent views to react to scroll position without direct observation.

**Basic scroll offset preference:**

```swift
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollTrackingView: View {
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack {
                // Invisible tracker at top
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY
                        )
                }
                .frame(height: 0)

                // Content
                ForEach(0..<30) { index in
                    ContentRow(index: index)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .overlay(alignment: .top) {
            // React to scroll offset
            HeaderView()
                .opacity(scrollOffset < -50 ? 0 : 1)
        }
    }
}
```

**Multiple preferences for different data:**

```swift
struct VisibleItemsPreferenceKey: PreferenceKey {
    static var defaultValue: Set<Int> = []

    static func reduce(value: inout Set<Int>, nextValue: () -> Set<Int>) {
        value.formUnion(nextValue())
    }
}

struct VisibilityTracker: View {
    @State private var visibleItems: Set<Int> = []

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<100) { index in
                    GeometryReader { geometry in
                        let frame = geometry.frame(in: .named("scroll"))
                        let isVisible = frame.minY < UIScreen.main.bounds.height &&
                                        frame.maxY > 0

                        Color.clear
                            .preference(
                                key: VisibleItemsPreferenceKey.self,
                                value: isVisible ? [index] : []
                            )
                    }
                    .frame(height: 100)
                    .background {
                        ItemContent(index: index, isVisible: visibleItems.contains(index))
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(VisibleItemsPreferenceKey.self) { items in
            visibleItems = items
        }
    }
}
```

**Anchor preferences for complex layouts:**

```swift
struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGRect>] = [:]

    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

struct AnchorTrackingView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    ItemRow(index: index)
                        .anchorPreference(
                            key: BoundsPreferenceKey.self,
                            value: .bounds
                        ) { anchor in
                            [index: anchor]
                        }
                }
            }
        }
        .overlayPreferenceValue(BoundsPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                // Use anchors to position overlays
                ForEach(Array(preferences.keys), id: \.self) { index in
                    if let anchor = preferences[index] {
                        let rect = geometry[anchor]
                        OverlayView()
                            .position(x: rect.midX, y: rect.midY)
                    }
                }
            }
        }
    }
}
```

**Debouncing preference updates:**

```swift
struct DebouncedScrollView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var debouncedOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            // Content with preference
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .onChange(of: scrollOffset) { _, newValue in
            // Debounce heavy updates
            Task {
                try? await Task.sleep(for: .milliseconds(16))
                debouncedOffset = newValue
            }
        }
    }
}
```

Reference: [PreferenceKey](https://developer.apple.com/documentation/swiftui/preferencekey)
