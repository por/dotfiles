---
title: Match Easing to Animation Context
impact: MEDIUM
impactDescription: appropriate easing reinforces meaning and intent
tags: ease, context, semantic, ux, meaning
---

## Match Easing to Animation Context

Different animation contexts call for different easing. A notification entering should feel different from one being dismissed. Match your easing choice to the semantic meaning of the interaction.

**Easing selection guide:**

```swift
enum AnimationContext {
    case userInitiated    // User triggered the action
    case systemInitiated  // System triggered (notification)
    case dismissal        // Content leaving
    case emphasis         // Drawing attention
    case continuous       // Ongoing state
}

extension Animation {
    static func forContext(_ context: AnimationContext) -> Animation {
        switch context {
        case .userInitiated:
            // Fast response to feel connected to user action
            return .spring(response: 0.3, dampingFraction: 0.7)
        case .systemInitiated:
            // Slightly slower, less urgent
            return .easeOut(duration: 0.35)
        case .dismissal:
            // Accelerates away
            return .easeIn(duration: 0.25)
        case .emphasis:
            // Symmetric for attention
            return .easeInOut(duration: 0.5)
        case .continuous:
            // Linear for progress indication
            return .linear(duration: 1.0)
        }
    }
}
```

**Practical example - toast notification:**

```swift
struct ToastView: View {
    @Binding var isPresented: Bool
    let message: String

    var body: some View {
        if isPresented {
            Text(message)
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .transition(
                    .asymmetric(
                        // Enters smoothly from system
                        insertion: .move(edge: .top).combined(with: .opacity)
                            .animation(.easeOut(duration: 0.3)),
                        // User dismisses - accelerates away
                        removal: .move(edge: .top).combined(with: .opacity)
                            .animation(.easeIn(duration: 0.2))
                    )
                )
        }
    }
}
```

**Context-aware button:**

```swift
struct ContextAwareButton: View {
    @State private var isPressed = false
    @State private var isLoading = false

    var body: some View {
        Button(action: { /* ... */ }) {
            Label("Submit", systemImage: isLoading ? "arrow.2.circlepath" : "checkmark")
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        // User press: spring for responsiveness
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        // Loading state: linear for progress feel
        .rotationEffect(isLoading ? .degrees(360) : .zero)
        .animation(
            isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default,
            value: isLoading
        )
    }
}
```

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
