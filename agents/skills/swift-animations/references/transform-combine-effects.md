---
title: Combine Transforms Purposefully
impact: MEDIUM
impactDescription: layered transforms create rich, cohesive animations
tags: transform, combine, composition, layered, multi-property
---

## Combine Transforms Purposefully

Combining multiple transforms creates richer animations than single-property changes. Scale + opacity, offset + rotation, or all three together can create sophisticated motion that feels polished and intentional.

**Scale + opacity for fade-scale:**

```swift
struct FadeScaleAppear: View {
    @State private var isVisible = false

    var body: some View {
        CardContent()
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .animation(.easeOut(duration: 0.25), value: isVisible)
    }
}
// Classic appear animation used by Apple
```

**Scale + offset for press effect:**

```swift
struct PressableCard: View {
    @State private var isPressed = false

    var body: some View {
        CardContent()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .offset(y: isPressed ? 2 : 0) // Slight push down
            .shadow(radius: isPressed ? 4 : 8) // Shadow shrinks
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
    }
}
// Multi-property change creates convincing depth
```

**Rotation + offset for shake:**

```swift
struct ShakeAnimation: View {
    @State private var shakePhase = 0

    var body: some View {
        TextField("Email", text: .constant(""))
            .offset(x: shakeOffset)
            .rotationEffect(.degrees(shakeRotation))
            .animation(
                .spring(response: 0.1, dampingFraction: 0.3),
                value: shakePhase
            )
    }

    private var shakeOffset: CGFloat {
        switch shakePhase {
        case 1: return 10
        case 2: return -10
        case 3: return 5
        case 4: return -5
        default: return 0
        }
    }

    private var shakeRotation: Double {
        switch shakePhase {
        case 1: return 2
        case 2: return -2
        case 3: return 1
        case 4: return -1
        default: return 0
        }
    }
}
```

**All three for dramatic reveals:**

```swift
struct HeroReveal: View {
    @State private var isRevealed = false

    var body: some View {
        HeroImage()
            .opacity(isRevealed ? 1 : 0)
            .scaleEffect(isRevealed ? 1 : 1.1)
            .offset(y: isRevealed ? 0 : 30)
            .animation(
                .spring(duration: 0.5, bounce: 0.2),
                value: isRevealed
            )
    }
}
// Image fades in while scaling down and rising up
```

**Staggered combined transforms:**

```swift
struct StaggeredReveal: View {
    @State private var isVisible = false

    var body: some View {
        VStack {
            Image("hero")
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
                .animation(.easeOut(duration: 0.4), value: isVisible)

            Text("Welcome")
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.easeOut(duration: 0.3).delay(0.1), value: isVisible)

            Text("Subtitle")
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 15)
                .animation(.easeOut(duration: 0.3).delay(0.2), value: isVisible)
        }
    }
}
```

**Guidelines for combining:**
- Always include opacity for enter/exit (helps with layout)
- Keep scale changes subtle (0.95-1.05 range)
- Match transform direction to meaning
- Use same animation timing for cohesion

Reference: [SwiftUI View Modifiers](https://developer.apple.com/documentation/swiftui/view-modifiers)
