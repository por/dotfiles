---
title: Create Parallax Scroll Effects
impact: MEDIUM
impactDescription: parallax adds depth and visual interest
tags: scroll, parallax, depth, layers, movement
---

## Create Parallax Scroll Effects

Parallax effects create depth by moving layers at different speeds. Background elements move slower than foreground, creating an illusion of depth as users scroll.

**Basic parallax header:**

```swift
struct ParallaxHeader: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Parallax image
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY
                    let height: CGFloat = 300

                    Image("header")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: height + (minY > 0 ? minY : 0)
                        )
                        // Move slower than scroll (parallax)
                        .offset(y: minY > 0 ? -minY * 0.5 : 0)
                        .clipped()
                }
                .frame(height: 300)

                // Content
                VStack {
                    ForEach(0..<20) { index in
                        ContentRow(index: index)
                    }
                }
                .background(Color(.systemBackground))
            }
        }
        .ignoresSafeArea()
    }
}
```

**Multi-layer parallax:**

```swift
struct MultiLayerParallax: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY

                    ZStack {
                        // Back layer - moves slowest
                        Image("mountains")
                            .resizable()
                            .scaledToFill()
                            .offset(y: -minY * 0.2)

                        // Middle layer
                        Image("trees")
                            .resizable()
                            .scaledToFill()
                            .offset(y: -minY * 0.4)

                        // Front layer - moves fastest
                        Image("grass")
                            .resizable()
                            .scaledToFill()
                            .offset(y: -minY * 0.6)
                    }
                    .frame(width: geometry.size.width, height: 400)
                    .clipped()
                }
                .frame(height: 400)

                // Content
                ContentSection()
            }
        }
    }
}
```

**Card parallax on scroll:**

```swift
struct ParallaxCards: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(0..<10) { index in
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .named("scroll")).minY
                        let parallaxOffset = (minY - 200) * 0.1

                        CardView(index: index)
                            .background(
                                Image("cardBg\(index % 3)")
                                    .resizable()
                                    .scaledToFill()
                                    // Background moves at different rate
                                    .offset(y: parallaxOffset)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(height: 200)
                }
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
    }
}
```

**Sticky header with parallax:**

```swift
struct StickyParallaxHeader: View {
    @State private var scrollOffset: CGFloat = 0
    let headerHeight: CGFloat = 300
    let stickyHeight: CGFloat = 60

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY

                    ZStack(alignment: .bottom) {
                        // Parallax background
                        Image("header")
                            .resizable()
                            .scaledToFill()
                            .offset(y: minY > 0 ? -minY * 0.5 : 0)

                        // Title that becomes sticky
                        Text("Title")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial.opacity(minY < -headerHeight + stickyHeight ? 1 : 0))
                    }
                    .frame(
                        width: geometry.size.width,
                        height: max(headerHeight + minY, stickyHeight)
                    )
                    .offset(y: minY < 0 ? -minY : 0)
                }
                .frame(height: headerHeight)

                // Content
                LazyVStack {
                    ForEach(0..<50) { index in
                        Text("Row \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
```

**Performance tip:** Use `drawingGroup()` on complex parallax layers to improve rendering performance.

Reference: [GeometryReader](https://developer.apple.com/documentation/swiftui/geometryreader)
