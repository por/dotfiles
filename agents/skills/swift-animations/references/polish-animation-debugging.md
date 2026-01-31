---
title: Debug Animations Effectively
impact: MEDIUM
impactDescription: debugging tools identify animation issues
tags: polish, debug, troubleshoot, instruments, slow-motion
---

## Debug Animations Effectively

When animations don't behave as expected, systematic debugging helps identify the issue. SwiftUI and Xcode provide tools to slow down, inspect, and profile animations.

**Slow motion in Simulator:**

```swift
// In Simulator menu: Debug → Slow Animations (Cmd + T)
// Or programmatically in debug builds:

#if DEBUG
extension Animation {
    static var debugSlowSpring: Animation {
        .spring(response: 1.5, dampingFraction: 0.7)
    }
}
#endif
```

**Print debugging animation values:**

```swift
struct DebugAnimation: View {
    @State private var value: CGFloat = 0

    var body: some View {
        Circle()
            .scaleEffect(value)
            .onChange(of: value) { old, new in
                print("Animation value: \(old) -> \(new)")
            }
            .animation(.spring(), value: value)
    }
}
```

**Visual debugging with overlays:**

```swift
struct AnimationDebugOverlay: View {
    let value: CGFloat
    let label: String

    var body: some View {
        VStack {
            Text("\(label): \(value, specifier: "%.2f")")
                .font(.caption)
                .padding(4)
                .background(.black.opacity(0.7))
                .foregroundStyle(.white)
        }
    }
}

// Usage
struct DebuggableView: View {
    @State private var scale: CGFloat = 1
    @State private var showDebug = true

    var body: some View {
        Circle()
            .scaleEffect(scale)
            .overlay(alignment: .bottom) {
                if showDebug {
                    AnimationDebugOverlay(value: scale, label: "Scale")
                }
            }
    }
}
```

**Identifying animation source:**

```swift
// When animation triggers unexpectedly, isolate the cause:

struct DiagnosticView: View {
    @State private var stateA = false
    @State private var stateB = false

    var body: some View {
        VStack {
            // Test each animation independently
            Circle()
                .fill(stateA ? .green : .gray)
                .animation(.spring(), value: stateA) // Only animates on stateA
                .animation(nil, value: stateB) // Block stateB animations

            Circle()
                .fill(stateB ? .blue : .gray)
                .animation(nil, value: stateA)
                .animation(.spring(), value: stateB)
        }
    }
}
```

**Transaction inspection:**

```swift
struct TransactionDebug: View {
    @State private var isActive = false

    var body: some View {
        Circle()
            .scaleEffect(isActive ? 1.5 : 1.0)
            .transaction { transaction in
                print("Animation: \(String(describing: transaction.animation))")
                print("Disables animations: \(transaction.disablesAnimations)")
            }
            .animation(.spring(), value: isActive)
    }
}
```

**Using Instruments for animation profiling:**

1. Open Instruments (Cmd + I from Xcode)
2. Choose "Animation Hitches" template
3. Record while interacting with your app
4. Look for:
   - Commit hitches (CPU-bound)
   - Render hitches (GPU-bound)
   - Frame drops below 60fps

**Common animation issues and fixes:**

```swift
// Issue: Animation not happening
// Check: Is the value actually changing?
print("Before: \(value), After: \(newValue)")

// Issue: Wrong animation timing
// Check: Is animation modifier in correct position?
.scaleEffect(scale)
.animation(.spring(), value: scale) // Animation AFTER the property

// Issue: Unexpected animations
// Fix: Block inheritance
.animation(nil, value: unrelatedState)

// Issue: Janky animation
// Check: Are you animating layout properties?
// Prefer: transform, opacity over frame, padding

// Issue: Animation doesn't complete
// Check: Is state changing mid-animation?
// Springs handle this; ease animations don't
```

**Debug view modifier:**

```swift
extension View {
    func debugAnimation(_ label: String = "") -> some View {
        self.onChange(of: UUID()) { _, _ in } // Never triggers, just for breakpoints
            .onAppear { print("[\(label)] View appeared") }
            .onDisappear { print("[\(label)] View disappeared") }
    }
}
```

Reference: [Instruments](https://developer.apple.com/documentation/xcode/improving-your-app-s-performance)
