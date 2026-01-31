---
title: Use iOS 17 scrollTransition Modifier
impact: HIGH
impactDescription: optimized scroll-linked animations without GeometryReader
tags: scroll, scroll-transition, ios17, performance, modern
---

## Use iOS 17 scrollTransition Modifier

iOS 17 introduced `scrollTransition`, a highly optimized way to create scroll-linked animations. It's more performant than `GeometryReader` and provides a cleaner API for common scroll effects.

**Basic scroll transition:**

```swift
struct ScrollTransitionDemo: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<30) { index in
                    CardView(index: index)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                        }
                }
            }
            .padding()
        }
    }
}
```

**Understanding phases:**

```swift
.scrollTransition { content, phase in
    // phase.isIdentity - view is fully visible in scroll area
    // phase.value - -1 to 1 representing position (-1 = top edge, 1 = bottom edge)

    content
        .opacity(phase.isIdentity ? 1 : 0.3)
        .offset(x: phase.value * 50) // Slides based on position
        .rotationEffect(.degrees(phase.value * 10))
}
```

**Different transitions for top/bottom:**

```swift
.scrollTransition(.animated(.spring(duration: 0.3)), axis: .vertical) { content, phase in
    content
        .opacity(phase.isIdentity ? 1 : 0.5)
        .offset(y: phase.value > 0 ? phase.value * 20 : 0) // Only offset entering from bottom
}
```

**Interactive scroll transition:**

```swift
.scrollTransition(.interactive) { content, phase in
    // Interactive means animation follows scroll exactly
    content
        .scaleEffect(1 - abs(phase.value) * 0.1)
        .blur(radius: abs(phase.value) * 5)
}
```

**Configuring transition behavior:**

```swift
// With custom animation
.scrollTransition(.animated(.spring(duration: 0.4, bounce: 0.2))) { content, phase in
    content.opacity(phase.isIdentity ? 1 : 0.5)
}

// Interactive (tracks scroll directly)
.scrollTransition(.interactive) { content, phase in
    content.scaleEffect(phase.isIdentity ? 1 : 0.95)
}

// Specific axis
.scrollTransition(.animated, axis: .horizontal) { content, phase in
    content.rotation3DEffect(.degrees(phase.value * 30), axis: (x: 0, y: 1, z: 0))
}
```

**Card stack effect:**

```swift
struct CardStackScroll: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(0..<10) { index in
                    CardView(index: index)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                        .scrollTransition(.interactive) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                .opacity(phase.isIdentity ? 1 : 0.7)
                                .rotation3DEffect(
                                    .degrees(phase.value * 15),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}
```

**Comparison with GeometryReader:**

```swift
// Old way with GeometryReader (more verbose, less performant)
GeometryReader { geometry in
    let minY = geometry.frame(in: .named("scroll")).minY
    CardView()
        .opacity(minY > 0 ? 1 : 0.5)
}

// New way with scrollTransition (cleaner, optimized)
CardView()
    .scrollTransition { content, phase in
        content.opacity(phase.isIdentity ? 1 : 0.5)
    }
```

**When to use scrollTransition:**
- iOS 17+ only
- Simple fade/scale/offset effects
- When performance matters
- Replacing GeometryReader-based scroll effects

Reference: [scrollTransition](https://developer.apple.com/documentation/swiftui/view/scrolltransition(_:axis:transition:))
