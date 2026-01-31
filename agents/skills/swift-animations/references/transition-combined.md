---
title: Combine Transitions for Richer Effects
impact: MEDIUM
impactDescription: layered transitions create polished appearances
tags: transition, combined, compose, layered, multiple
---

## Combine Transitions for Richer Effects

Combining multiple transitions creates more sophisticated enter/exit animations. Use `.combined(with:)` to layer opacity, scale, and movement effects.

**Opacity + Scale (most common):**

```swift
struct FadeScaleTransition: View {
    @State private var showCard = false

    var body: some View {
        VStack {
            Button("Show Card") {
                withAnimation(.spring(duration: 0.3)) {
                    showCard.toggle()
                }
            }

            if showCard {
                CardView()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}
```

**Opacity + Scale + Move:**

```swift
struct FullTransition: View {
    @State private var showContent = false

    var body: some View {
        if showContent {
            ContentView()
                .transition(
                    .opacity
                    .combined(with: .scale(scale: 0.9, anchor: .top))
                    .combined(with: .move(edge: .top))
                )
        }
    }
}
```

**Custom combined transition extension:**

```swift
extension AnyTransition {
    static var slideUp: AnyTransition {
        .opacity
        .combined(with: .offset(y: 20))
    }

    static var popIn: AnyTransition {
        .opacity
        .combined(with: .scale(scale: 0.8))
    }

    static var slideFromTrailing: AnyTransition {
        .opacity
        .combined(with: .move(edge: .trailing))
    }

    static func slide(from edge: Edge) -> AnyTransition {
        .opacity
        .combined(with: .move(edge: edge))
    }
}

// Usage
ContentView()
    .transition(.slideUp)
```

**Chaining with animation:**

```swift
extension AnyTransition {
    static var bouncyAppear: AnyTransition {
        .opacity
        .combined(with: .scale(scale: 0.8))
        .animation(.spring(duration: 0.35, bounce: 0.3))
    }
}
```

**Different combinations for different contexts:**

```swift
struct ContextualTransitions: View {
    @State private var showModal = false
    @State private var showToast = false
    @State private var showDropdown = false

    var body: some View {
        ZStack {
            // Modal: fade + scale from center
            if showModal {
                ModalView()
                    .transition(.opacity.combined(with: .scale))
            }

            // Toast: slide from bottom + fade
            if showToast {
                ToastView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            // Dropdown: scale from top + fade
            if showDropdown {
                DropdownView()
                    .transition(
                        .opacity
                        .combined(with: .scale(scale: 0.95, anchor: .top))
                        .combined(with: .offset(y: -10))
                    )
            }
        }
    }
}
```

**Offset transition for subtle movement:**

```swift
extension AnyTransition {
    static func offset(x: CGFloat = 0, y: CGFloat = 0) -> AnyTransition {
        .modifier(
            active: OffsetModifier(x: x, y: y),
            identity: OffsetModifier(x: 0, y: 0)
        )
    }
}

struct OffsetModifier: ViewModifier {
    let x: CGFloat
    let y: CGFloat

    func body(content: Content) -> some View {
        content.offset(x: x, y: y)
    }
}

// Usage - subtle rise effect
.transition(.opacity.combined(with: .offset(y: 15)))
```

Reference: [AnyTransition.combined](https://developer.apple.com/documentation/swiftui/anytransition/combined(with:))
