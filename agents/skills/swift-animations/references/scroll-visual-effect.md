---
title: Use iOS 17 visualEffect Modifier
impact: MEDIUM
impactDescription: geometry-aware effects without layout impact
tags: scroll, visual-effect, ios17, geometry, performance
---

## Use iOS 17 visualEffect Modifier

iOS 17's `visualEffect` modifier provides geometry-aware transformations without triggering layout passes. It's ideal for scroll-linked effects where you need position information but want optimal performance.

**Basic visual effect:**

```swift
struct VisualEffectDemo: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<30) { index in
                    CardView(index: index)
                        .visualEffect { content, geometryProxy in
                            let frame = geometryProxy.frame(in: .scrollView)
                            let distance = abs(frame.midY - 400) // Distance from center

                            content
                                .scaleEffect(1 - distance / 2000)
                                .opacity(1 - distance / 1000)
                        }
                }
            }
            .padding()
        }
    }
}
```

**Coordinate space options:**

```swift
.visualEffect { content, proxy in
    // Different coordinate spaces
    let scrollFrame = proxy.frame(in: .scrollView)    // Relative to scroll view
    let globalFrame = proxy.frame(in: .global)        // Screen coordinates
    let localFrame = proxy.frame(in: .local)          // View's own coordinate space

    content
        .offset(y: scrollFrame.minY * 0.1)
}
```

**Parallax with visualEffect:**

```swift
struct ParallaxVisualEffect: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Parallax header
                Image("header")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                    .visualEffect { content, proxy in
                        let scrollY = proxy.frame(in: .scrollView).minY

                        content
                            // Parallax movement
                            .offset(y: scrollY > 0 ? -scrollY * 0.5 : 0)
                            // Scale up when pulling down
                            .scaleEffect(scrollY > 0 ? 1 + scrollY / 500 : 1)
                    }

                // Content
                ContentSection()
            }
        }
    }
}
```

**3D rotation based on position:**

```swift
struct RotatingCards: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(0..<10) { index in
                    CardView(index: index)
                        .frame(width: 250, height: 350)
                        .visualEffect { content, proxy in
                            let frame = proxy.frame(in: .scrollView)
                            let centerX = frame.midX
                            let screenCenter = UIScreen.main.bounds.width / 2
                            let distance = centerX - screenCenter
                            let rotation = distance / 20

                            content
                                .rotation3DEffect(
                                    .degrees(rotation),
                                    axis: (x: 0, y: 1, z: 0),
                                    perspective: 0.5
                                )
                                .scaleEffect(1 - abs(distance) / 1000)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
```

**Blur based on scroll position:**

```swift
struct BlurOnScroll: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    CardView(index: index)
                        .visualEffect { content, proxy in
                            let scrollY = proxy.frame(in: .scrollView).minY
                            let blurAmount = max(0, -scrollY / 50)

                            content
                                .blur(radius: min(blurAmount, 10))
                                .opacity(1 - blurAmount / 20)
                        }
                }
            }
        }
    }
}
```

**Comparison with other approaches:**

```swift
// GeometryReader: Triggers layout, can cause performance issues
GeometryReader { proxy in
    CardView()
        .offset(y: proxy.frame(in: .named("scroll")).minY * 0.1)
}

// visualEffect: No layout impact, better performance
CardView()
    .visualEffect { content, proxy in
        content.offset(y: proxy.frame(in: .scrollView).minY * 0.1)
    }

// scrollTransition: Best for simple enter/exit effects
CardView()
    .scrollTransition { content, phase in
        content.opacity(phase.isIdentity ? 1 : 0.5)
    }
```

**When to use visualEffect:**
- Need precise geometry information
- Complex position-based calculations
- When scrollTransition's phases aren't sufficient
- Parallax and 3D effects

Reference: [visualEffect](https://developer.apple.com/documentation/swiftui/view/visualeffect(_:))
