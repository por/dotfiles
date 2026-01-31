---
title: Create Custom Transition Modifiers
impact: MEDIUM
impactDescription: custom modifiers enable unique brand transitions
tags: transition, custom, modifier, brand, unique
---

## Create Custom Transition Modifiers

For transitions beyond built-in types, create custom transitions using `AnyTransition.modifier(active:identity:)`. This enables unique brand-specific animations.

**Basic custom transition:**

```swift
struct BlurModifier: ViewModifier {
    let active: Bool

    func body(content: Content) -> some View {
        content
            .blur(radius: active ? 10 : 0)
            .opacity(active ? 0 : 1)
    }
}

extension AnyTransition {
    static var blur: AnyTransition {
        .modifier(
            active: BlurModifier(active: true),
            identity: BlurModifier(active: false)
        )
    }
}

// Usage
if showContent {
    ContentView()
        .transition(.blur)
}
```

**Flip transition:**

```swift
struct FlipModifier: ViewModifier {
    let angle: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                anchor: anchor
            )
            .opacity(abs(angle) < 90 ? 1 : 0)
    }
}

extension AnyTransition {
    static var flip: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: FlipModifier(angle: -90, anchor: .leading),
                identity: FlipModifier(angle: 0, anchor: .leading)
            ),
            removal: .modifier(
                active: FlipModifier(angle: 90, anchor: .trailing),
                identity: FlipModifier(angle: 0, anchor: .trailing)
            )
        )
    }
}
```

**Iris/Circle reveal transition:**

```swift
struct IrisModifier: ViewModifier {
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .scaleEffect(scale)
    }
}

extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: IrisModifier(scale: 0),
            identity: IrisModifier(scale: 1.5) // Larger than 1 to cover corners
        )
    }
}
```

**Slide with rotation:**

```swift
struct SlideRotateModifier: ViewModifier {
    let offset: CGFloat
    let rotation: Double

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .rotationEffect(.degrees(rotation))
            .opacity(offset == 0 ? 1 : 0)
    }
}

extension AnyTransition {
    static var slideRotate: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: SlideRotateModifier(offset: 200, rotation: 15),
                identity: SlideRotateModifier(offset: 0, rotation: 0)
            ),
            removal: .modifier(
                active: SlideRotateModifier(offset: -200, rotation: -15),
                identity: SlideRotateModifier(offset: 0, rotation: 0)
            )
        )
    }
}
```

**Bounce scale transition:**

```swift
struct BounceScaleModifier: ViewModifier {
    let scale: CGFloat
    let yOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .offset(y: yOffset)
            .opacity(scale < 0.5 ? 0 : 1)
    }
}

extension AnyTransition {
    static var bounceIn: AnyTransition {
        .modifier(
            active: BounceScaleModifier(scale: 0.3, yOffset: -50),
            identity: BounceScaleModifier(scale: 1, yOffset: 0)
        )
        .animation(.spring(duration: 0.4, bounce: 0.4))
    }
}
```

**Parameterized custom transition:**

```swift
extension AnyTransition {
    static func slideAndFade(from edge: Edge, offset: CGFloat = 50) -> AnyTransition {
        .modifier(
            active: SlideAndFadeModifier(edge: edge, offset: offset, opacity: 0),
            identity: SlideAndFadeModifier(edge: edge, offset: 0, opacity: 1)
        )
    }
}

struct SlideAndFadeModifier: ViewModifier {
    let edge: Edge
    let offset: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .offset(
                x: edge == .leading ? -offset : (edge == .trailing ? offset : 0),
                y: edge == .top ? -offset : (edge == .bottom ? offset : 0)
            )
            .opacity(opacity)
    }
}

// Usage
.transition(.slideAndFade(from: .bottom, offset: 30))
```

Reference: [AnyTransition.modifier](https://developer.apple.com/documentation/swiftui/anytransition/modifier(active:identity:))
