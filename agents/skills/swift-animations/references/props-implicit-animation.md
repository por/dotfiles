---
title: Use .animation Modifier for Implicit Animations
impact: MEDIUM
impactDescription: automatic animation of value changes
tags: props, animation, implicit, modifier, value
---

## Use .animation Modifier for Implicit Animations

The `.animation(_:value:)` modifier automatically animates all changes to a view when the specified value changes. This is convenient for simple cases but requires understanding of animation inheritance.

**Basic implicit animation:**

```swift
struct SimpleToggle: View {
    @State private var isOn = false

    var body: some View {
        Circle()
            .fill(isOn ? .green : .gray)
            .frame(width: 30, height: 30)
            .offset(x: isOn ? 20 : -20)
            // Animate whenever isOn changes
            .animation(.spring(duration: 0.3, bounce: 0.2), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}
// Both fill and offset animate together
```

**Animation modifier placement matters:**

```swift
struct PlacementExample: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Rectangle()
                .fill(.blue)
                .frame(height: isExpanded ? 200 : 100)
                // Animation applies to frame
                .animation(.spring(), value: isExpanded)
                // This opacity change WON'T animate (below animation modifier)
                .opacity(isExpanded ? 1 : 0.5)

            Rectangle()
                .fill(.red)
                .frame(height: isExpanded ? 200 : 100)
                .opacity(isExpanded ? 1 : 0.5)
                // Animation applies to both frame AND opacity (both above)
                .animation(.spring(), value: isExpanded)
        }
    }
}
```

**Multiple animation modifiers for different timings:**

```swift
struct MultiTimingView: View {
    @State private var isActive = false

    var body: some View {
        Circle()
            .fill(isActive ? .green : .gray)
            // Slow color transition
            .animation(.easeOut(duration: 0.5), value: isActive)
            .scaleEffect(isActive ? 1.2 : 1.0)
            // Fast scale
            .animation(.spring(duration: 0.2), value: isActive)
            .onTapGesture { isActive.toggle() }
    }
}
// Color and scale animate with different timings
```

**The value parameter is crucial:**

```swift
// BAD: Deprecated API without value
.animation(.spring()) // Animates everything, unpredictable

// GOOD: Specify what triggers the animation
.animation(.spring(), value: isExpanded)
```

**Implicit animation inheritance:**

```swift
struct ParentChild: View {
    @State private var isOn = false

    var body: some View {
        VStack {
            // Parent animation
            ChildView()
                // Child inherits this animation
        }
        .animation(.spring(), value: isOn)
    }
}
// Child views inherit parent's animation unless blocked with .animation(nil, value:)
```

**When to prefer implicit over explicit:**
- Simple views with single animated state
- Prototyping and quick iterations
- When all properties should animate together
- When animation inheritance is desired

Reference: [View animation modifier](https://developer.apple.com/documentation/swiftui/view/animation(_:value:))
