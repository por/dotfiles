---
title: Use GeometryReader for Scroll Position
impact: MEDIUM
impactDescription: geometry enables scroll-linked animations
tags: scroll, geometry-reader, position, coordinate-space
---

## Use GeometryReader for Scroll Position

`GeometryReader` provides access to a view's position within its coordinate space. Combined with named coordinate spaces, this enables scroll-linked animations and effects.

**Basic scroll position tracking:**

```swift
struct ScrollPositionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<20) { index in
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .named("scroll")).minY

                        CardView(index: index)
                            .opacity(opacityForOffset(minY))
                            .scaleEffect(scaleForOffset(minY))
                    }
                    .frame(height: 150)
                }
            }
        }
        .coordinateSpace(name: "scroll")
    }

    func opacityForOffset(_ offset: CGFloat) -> Double {
        // Fade in as card enters from bottom
        let normalized = max(0, min(1, offset / 200))
        return 1 - normalized * 0.5
    }

    func scaleForOffset(_ offset: CGFloat) -> CGFloat {
        // Scale down slightly as card moves up
        let normalized = max(0, min(1, offset / 300))
        return 1 - normalized * 0.1
    }
}
```

**Scroll progress indicator:**

```swift
struct ScrollProgress: View {
    @State private var scrollProgress: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: -geometry.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 0)

                    // Content
                    ForEach(0..<50) { index in
                        Text("Row \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollProgress = value
            }

            // Progress bar
            GeometryReader { geo in
                Rectangle()
                    .fill(.blue)
                    .frame(width: geo.size.width * min(1, scrollProgress / 1000))
                    .frame(height: 3)
            }
            .frame(height: 3)
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
```

**Card stack effect:**

```swift
struct CardStack: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<10) { index in
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .named("scroll")).minY
                        let isOnTop = minY < 100

                        CardView(index: index)
                            .padding(.horizontal)
                            // Cards stack at top
                            .offset(y: isOnTop ? -minY + CGFloat(index) * 5 : 0)
                            .scaleEffect(isOnTop ? 1 - CGFloat(index) * 0.02 : 1)
                            .zIndex(Double(10 - index))
                    }
                    .frame(height: 200)
                }
            }
            .padding(.top, 100)
        }
        .coordinateSpace(name: "scroll")
    }
}
```

**Performance considerations:**
- GeometryReader causes layout passes
- Use sparingly for scroll-linked effects
- Consider iOS 17+ `scrollTransition` for better performance
- Avoid updating @State on every frame when possible

Reference: [GeometryReader](https://developer.apple.com/documentation/swiftui/geometryreader)
