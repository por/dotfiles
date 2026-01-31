---
title: Use KeyframeAnimator for Complex Paths
impact: HIGH
impactDescription: precise control over animation curves and timing
tags: polish, keyframe-animator, ios17, timeline, precise
---

## Use KeyframeAnimator for Complex Paths

iOS 17's `KeyframeAnimator` provides precise control over animation timing and values. Unlike PhaseAnimator's discrete phases, keyframes define exact values at specific times for smooth, complex motion paths.

**Basic keyframe animation:**

```swift
struct BouncingBall: View {
    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .keyframeAnimator(initialValue: AnimationValues()) { content, value in
                content
                    .offset(y: value.verticalOffset)
                    .scaleEffect(y: value.verticalStretch)
            } keyframes: { _ in
                KeyframeTrack(\.verticalOffset) {
                    SpringKeyframe(0, duration: 0.2)
                    SpringKeyframe(100, duration: 0.4)
                    SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                }

                KeyframeTrack(\.verticalStretch) {
                    LinearKeyframe(1.0, duration: 0.2)
                    LinearKeyframe(0.8, duration: 0.1) // Squash on landing
                    SpringKeyframe(1.0, duration: 0.5)
                }
            }
    }
}

struct AnimationValues {
    var verticalOffset: CGFloat = 0
    var verticalStretch: CGFloat = 1
}
```

**Triggered keyframe animation:**

```swift
struct CelebrationAnimation: View {
    @State private var trigger = false

    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow)
                .keyframeAnimator(
                    initialValue: CelebrationValues(),
                    trigger: trigger
                ) { content, value in
                    content
                        .scaleEffect(value.scale)
                        .rotationEffect(.degrees(value.rotation))
                        .offset(y: value.yOffset)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        LinearKeyframe(1.0, duration: 0)
                        SpringKeyframe(1.5, duration: 0.2, spring: .bouncy)
                        SpringKeyframe(1.0, duration: 0.3)
                    }

                    KeyframeTrack(\.rotation) {
                        LinearKeyframe(0, duration: 0)
                        LinearKeyframe(-15, duration: 0.1)
                        LinearKeyframe(15, duration: 0.2)
                        SpringKeyframe(0, duration: 0.2)
                    }

                    KeyframeTrack(\.yOffset) {
                        SpringKeyframe(0, duration: 0.1)
                        SpringKeyframe(-30, duration: 0.2)
                        SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                    }
                }

            Button("Celebrate!") {
                trigger.toggle()
            }
        }
    }
}

struct CelebrationValues {
    var scale: CGFloat = 1
    var rotation: Double = 0
    var yOffset: CGFloat = 0
}
```

**Different keyframe types:**

```swift
KeyframeTrack(\.value) {
    // Linear interpolation
    LinearKeyframe(100, duration: 0.5)

    // Spring physics
    SpringKeyframe(50, duration: 0.3, spring: .bouncy)

    // Cubic bezier curve
    CubicKeyframe(75, duration: 0.4)

    // Move without animation (instant)
    MoveKeyframe(0)
}
```

**Complex path animation:**

```swift
struct OrbitAnimation: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 20, height: 20)
            .keyframeAnimator(
                initialValue: OrbitValues(),
                repeating: true
            ) { content, value in
                content
                    .offset(x: value.x, y: value.y)
                    .scaleEffect(value.scale)
            } keyframes: { _ in
                KeyframeTrack(\.x) {
                    CubicKeyframe(100, duration: 0.5)
                    CubicKeyframe(0, duration: 0.5)
                    CubicKeyframe(-100, duration: 0.5)
                    CubicKeyframe(0, duration: 0.5)
                }

                KeyframeTrack(\.y) {
                    CubicKeyframe(0, duration: 0.5)
                    CubicKeyframe(100, duration: 0.5)
                    CubicKeyframe(0, duration: 0.5)
                    CubicKeyframe(-100, duration: 0.5)
                }

                KeyframeTrack(\.scale) {
                    LinearKeyframe(0.8, duration: 0.5)
                    LinearKeyframe(1.2, duration: 0.5)
                    LinearKeyframe(0.8, duration: 0.5)
                    LinearKeyframe(1.2, duration: 0.5)
                }
            }
    }
}

struct OrbitValues {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var scale: CGFloat = 1
}
```

**When to use KeyframeAnimator vs PhaseAnimator:**
- KeyframeAnimator: precise timing, smooth curves, complex motion paths
- PhaseAnimator: discrete states, simpler sequences, state-driven animations

Reference: [KeyframeAnimator](https://developer.apple.com/documentation/swiftui/keyframeanimator)
