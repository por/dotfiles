---
title: Use PhaseAnimator for Sequences
impact: HIGH
impactDescription: declarative multi-phase animations without state
tags: polish, phase-animator, ios17, sequence, modern
---

## Use PhaseAnimator for Sequences

iOS 17's `PhaseAnimator` creates multi-step animation sequences declaratively. Instead of chaining animations with delays or completion handlers, define phases and let SwiftUI handle the transitions.

**Basic phase animation:**

```swift
struct PulsingIcon: View {
    var body: some View {
        PhaseAnimator([false, true]) { phase in
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundStyle(.red)
                .scaleEffect(phase ? 1.2 : 1.0)
        } animation: { _ in
            .easeInOut(duration: 0.5)
        }
    }
}
```

**Multi-phase sequence:**

```swift
enum LoadingPhase: CaseIterable {
    case initial, loading, success

    var scale: CGFloat {
        switch self {
        case .initial: return 1.0
        case .loading: return 0.9
        case .success: return 1.1
        }
    }

    var opacity: Double {
        switch self {
        case .initial: return 1.0
        case .loading: return 0.7
        case .success: return 1.0
        }
    }
}

struct LoadingSequence: View {
    var body: some View {
        PhaseAnimator(LoadingPhase.allCases) { phase in
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .scaleEffect(phase.scale)
                .opacity(phase.opacity)
        } animation: { phase in
            switch phase {
            case .initial: return .spring(duration: 0.3)
            case .loading: return .easeInOut(duration: 0.5)
            case .success: return .spring(duration: 0.3, bounce: 0.4)
            }
        }
    }
}
```

**Triggered phase animation:**

```swift
struct SuccessAnimation: View {
    @State private var showSuccess = false

    var body: some View {
        VStack {
            PhaseAnimator(
                [0, 1, 2],
                trigger: showSuccess
            ) { phase in
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                    .scaleEffect(scaleFor(phase))
                    .opacity(opacityFor(phase))
            } animation: { phase in
                switch phase {
                case 0: return .spring(duration: 0.2)
                case 1: return .spring(duration: 0.3, bounce: 0.5)
                default: return .spring(duration: 0.2)
                }
            }

            Button("Show Success") {
                showSuccess.toggle()
            }
        }
    }

    func scaleFor(_ phase: Int) -> CGFloat {
        switch phase {
        case 0: return 0.5
        case 1: return 1.2
        default: return 1.0
        }
    }

    func opacityFor(_ phase: Int) -> Double {
        switch phase {
        case 0: return 0
        default: return 1
        }
    }
}
```

**Complex notification animation:**

```swift
enum NotificationPhase: CaseIterable {
    case hidden, appearing, visible, dismissing

    var offset: CGFloat {
        switch self {
        case .hidden, .dismissing: return -100
        case .appearing, .visible: return 0
        }
    }

    var scale: CGFloat {
        switch self {
        case .hidden: return 0.8
        case .appearing: return 1.05
        case .visible: return 1.0
        case .dismissing: return 0.9
        }
    }

    var opacity: Double {
        switch self {
        case .hidden, .dismissing: return 0
        case .appearing, .visible: return 1
        }
    }
}

struct NotificationBanner: View {
    let message: String
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            PhaseAnimator(NotificationPhase.allCases) { phase in
                Text(message)
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .offset(y: phase.offset)
                    .scaleEffect(phase.scale)
                    .opacity(phase.opacity)
            } animation: { phase in
                switch phase {
                case .hidden: return .spring(duration: 0.1)
                case .appearing: return .spring(duration: 0.3, bounce: 0.3)
                case .visible: return .spring(duration: 0.2)
                case .dismissing: return .easeIn(duration: 0.2)
                }
            }
        }
    }
}
```

**When to use PhaseAnimator:**
- Multi-step animation sequences
- Looping animations with distinct phases
- Triggered one-shot sequences
- Replacing complex withAnimation chains

Reference: [PhaseAnimator](https://developer.apple.com/documentation/swiftui/phaseanimator)
