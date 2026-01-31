---
title: Express Brand Through Motion
impact: LOW-MEDIUM
impactDescription: consistent motion contributes to brand identity
tags: strategy, brand, identity, personality, consistency
---

## Express Brand Through Motion

Motion can express brand personality when used consistently. A playful app might use bouncier springs; a professional app might use more damped, subtle animations. Define motion principles that align with your brand.

**Defining brand motion constants:**

```swift
// Playful brand: bouncy, energetic
struct PlayfulBrand {
    static let springResponse: Double = 0.4
    static let springBounce: Double = 0.4
    static let standardDuration: Double = 0.35

    static var spring: Animation {
        .spring(duration: springResponse, bounce: springBounce)
    }

    static var emphasizedSpring: Animation {
        .spring(duration: 0.5, bounce: 0.5)
    }
}

// Professional brand: smooth, subtle
struct ProfessionalBrand {
    static let springResponse: Double = 0.3
    static let springDamping: Double = 0.85
    static let standardDuration: Double = 0.25

    static var spring: Animation {
        .spring(response: springResponse, dampingFraction: springDamping)
    }

    static var subtle: Animation {
        .easeOut(duration: 0.2)
    }
}

// Luxury brand: slow, elegant
struct LuxuryBrand {
    static let standardDuration: Double = 0.5
    static let timingCurve = Animation.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.5)

    static var elegant: Animation {
        .easeInOut(duration: standardDuration)
    }

    static var dramatic: Animation {
        timingCurve
    }
}
```

**Using brand animations:**

```swift
struct PlayfulButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Tap Me!") { }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .rotationEffect(.degrees(isPressed ? -5 : 0))
            // Playful bounce on press
            .animation(PlayfulBrand.spring, value: isPressed)
    }
}

struct ProfessionalButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Continue") { }
            .scaleEffect(isPressed ? 0.98 : 1.0)
            // Subtle, professional feel
            .animation(ProfessionalBrand.subtle, value: isPressed)
    }
}
```

**Consistent transitions:**

```swift
// Playful app transitions
extension AnyTransition {
    static var playful: AnyTransition {
        .scale(scale: 0.8)
        .combined(with: .opacity)
        .animation(PlayfulBrand.emphasizedSpring)
    }
}

// Professional app transitions
extension AnyTransition {
    static var professional: AnyTransition {
        .opacity
        .combined(with: .offset(y: 10))
        .animation(ProfessionalBrand.subtle)
    }
}
```

**Scale feedback by brand:**

```swift
// Playful: larger scale change, more bounce
.scaleEffect(isPressed ? 0.85 : 1.0)

// Professional: subtle scale, no bounce
.scaleEffect(isPressed ? 0.97 : 1.0)

// Luxury: minimal scale, slow elegance
.scaleEffect(isPressed ? 0.99 : 1.0)
```

**Loading states by brand:**

```swift
// Playful: bouncing dots
struct PlayfulLoader: View {
    @State private var bouncePhase = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 12, height: 12)
                    .offset(y: bouncePhase == index ? -10 : 0)
                    .animation(
                        .spring(duration: 0.3, bounce: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: bouncePhase
                    )
            }
        }
        .onAppear {
            withAnimation { bouncePhase = 2 }
        }
    }
}

// Professional: smooth spinner
struct ProfessionalLoader: View {
    @State private var isRotating = false

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(lineWidth: 2)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
            .onAppear { isRotating = true }
    }
}
```

**Brand motion guidelines:**
| Brand Type | Spring Bounce | Duration | Scale Change |
|------------|---------------|----------|--------------|
| Playful | 0.3-0.5 | 0.35-0.5s | 10-15% |
| Professional | 0.1-0.2 | 0.2-0.3s | 2-5% |
| Luxury | 0-0.1 | 0.4-0.6s | 1-2% |

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
