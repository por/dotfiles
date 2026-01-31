---
title: Use drawingGroup for Complex Hierarchies
impact: MEDIUM-HIGH
impactDescription: rasterizes view tree for GPU compositing
tags: props, drawing-group, performance, rasterization, gpu
---

## Use drawingGroup for Complex Hierarchies

The `.drawingGroup()` modifier flattens a view hierarchy into a single Metal texture before compositing. This can dramatically improve animation performance for complex views with many subviews, gradients, or blending effects.

**Incorrect (complex hierarchy animates slowly):**

```swift
struct ParticleCloud: View {
    @State private var scale: CGFloat = 1.0
    let particles: [Particle]

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.gradient)
                    .frame(width: particle.size)
                    .blur(radius: 2)
                    .offset(x: particle.x, y: particle.y)
            }
        }
        .scaleEffect(scale)
        .animation(.spring(), value: scale)
    }
}
// Each particle is composited separately - expensive
```

**Correct (drawingGroup rasterizes hierarchy):**

```swift
struct ParticleCloud: View {
    @State private var scale: CGFloat = 1.0
    let particles: [Particle]

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.gradient)
                    .frame(width: particle.size)
                    .blur(radius: 2)
                    .offset(x: particle.x, y: particle.y)
            }
        }
        // Flatten to single texture before animating
        .drawingGroup()
        .scaleEffect(scale)
        .animation(.spring(), value: scale)
    }
}
// Single texture scales smoothly
```

**When to use drawingGroup:**

```swift
// Complex gradients
LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
    .mask(ComplexShape())
    .drawingGroup()

// Many overlapping elements
ZStack {
    ForEach(0..<50) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(.ultraThinMaterial)
            .frame(width: 100, height: 100)
            .offset(x: CGFloat(index) * 2, y: CGFloat(index) * 2)
    }
}
.drawingGroup()

// Blur effects
VStack {
    // Complex content
}
.blur(radius: isBlurred ? 10 : 0)
.drawingGroup() // Rasterize before blur
.animation(.easeOut, value: isBlurred)
```

**When NOT to use drawingGroup:**
- Simple view hierarchies (overhead outweighs benefit)
- When you need crisp text at all scales
- When subviews need independent interactivity
- Views that change frequently (rasterization has cost)

**Trade-offs:**
- Pros: Better animation performance, reduced compositing
- Cons: Higher memory usage, potential blur at extreme scales

Reference: [drawingGroup](https://developer.apple.com/documentation/swiftui/view/drawinggroup(opaque:colormode:))
