---
title: Profile Animation Performance
impact: MEDIUM
impactDescription: profiling identifies frame drops and hitches
tags: polish, performance, profiling, instruments, fps
---

## Profile Animation Performance

Smooth 60fps (or 120fps on ProMotion) animations require each frame to render within 16.67ms (or 8.33ms). Use Instruments and SwiftUI's built-in tools to identify and fix performance bottlenecks.

**Instruments Animation Hitches template:**

1. Product → Profile (Cmd + I)
2. Select "Animation Hitches"
3. Record while animating
4. Analyze hitch types:
   - **Commit hitch**: Main thread too slow
   - **Render hitch**: GPU can't keep up

**Common performance issues:**

```swift
// PROBLEM: Animating layout properties
struct SlowAnimation: View {
    @State private var width: CGFloat = 100

    var body: some View {
        Rectangle()
            .frame(width: width, height: 100) // Layout recalc every frame!
            .animation(.spring(), value: width)
    }
}

// FIX: Use transform instead
struct FastAnimation: View {
    @State private var scale: CGFloat = 1

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            .scaleEffect(x: scale, y: 1) // GPU handles this
            .animation(.spring(), value: scale)
    }
}
```

**Complex view hierarchies:**

```swift
// PROBLEM: Deep hierarchy animates slowly
struct DeepHierarchy: View {
    @State private var isActive = false

    var body: some View {
        VStack { // Many nested views
            ForEach(0..<100) { _ in
                ComplexSubview()
            }
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(), value: isActive)
    }
}

// FIX: Use drawingGroup for complex hierarchies
struct OptimizedHierarchy: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            ForEach(0..<100) { _ in
                ComplexSubview()
            }
        }
        .drawingGroup() // Rasterize to texture
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(), value: isActive)
    }
}
```

**Blur performance:**

```swift
// PROBLEM: Animated blur is expensive
struct ExpensiveBlur: View {
    @State private var blurAmount: CGFloat = 0

    var body: some View {
        Image("photo")
            .blur(radius: blurAmount) // Recalculates blur every frame
            .animation(.spring(), value: blurAmount)
    }
}

// FIX: Cross-fade between pre-blurred states
struct OptimizedBlur: View {
    @State private var isBlurred = false

    var body: some View {
        ZStack {
            Image("photo")
                .opacity(isBlurred ? 0 : 1)

            Image("photo")
                .blur(radius: 20)
                .opacity(isBlurred ? 1 : 0)
        }
        .animation(.easeOut(duration: 0.3), value: isBlurred)
    }
}
```

**Measuring frame times:**

```swift
struct FrameTimeMonitor: View {
    @State private var lastFrameTime = Date()
    @State private var frameTime: Double = 0

    var body: some View {
        TimelineView(.animation) { context in
            let now = context.date
            let delta = now.timeIntervalSince(lastFrameTime)

            Text("Frame: \(delta * 1000, specifier: "%.1f")ms")
                .onChange(of: context.date) { _, newValue in
                    frameTime = newValue.timeIntervalSince(lastFrameTime) * 1000
                    lastFrameTime = newValue
                }
                .foregroundStyle(frameTime > 16.67 ? .red : .green)
        }
    }
}
```

**Reducing overdraw:**

```swift
// PROBLEM: Multiple overlapping animated layers
struct Overdraw: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            AnimatedMiddle()
            AnimatedForeground()
            // GPU draws all 3 layers every frame
        }
    }
}

// FIX: Flatten when possible
struct ReducedOverdraw: View {
    var body: some View {
        AnimatedComposite()
            .drawingGroup() // Single composited layer
    }
}
```

**Performance checklist:**
- [ ] Using transform/opacity instead of layout properties
- [ ] drawingGroup() on complex animated hierarchies
- [ ] Avoiding animated blur (use crossfade)
- [ ] Minimizing view body recalculation
- [ ] Testing on older devices (not just Simulator)
- [ ] Checking for 60fps in Instruments

Reference: [Improving App Performance](https://developer.apple.com/documentation/xcode/improving-your-app-s-performance)
