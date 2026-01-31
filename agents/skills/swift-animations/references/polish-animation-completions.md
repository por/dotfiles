---
title: Handle Animation Completion
impact: MEDIUM
impactDescription: completion handlers enable sequential logic
tags: polish, completion, callback, sequence, chaining
---

## Handle Animation Completion

Sometimes you need to execute code after an animation completes—triggering a second animation, updating state, or starting a network request. SwiftUI provides several approaches.

**iOS 17+ withAnimation completion:**

```swift
struct CompletionExample: View {
    @State private var step1Complete = false
    @State private var step2Complete = false

    var body: some View {
        VStack {
            Circle()
                .fill(step1Complete ? .green : .blue)
                .frame(width: 100)
                .scaleEffect(step1Complete ? 1.2 : 1.0)

            Circle()
                .fill(step2Complete ? .green : .gray)
                .frame(width: 100)
                .scaleEffect(step2Complete ? 1.2 : 0.8)
                .opacity(step2Complete ? 1 : 0.5)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.3)) {
                step1Complete = true
            } completion: {
                // First animation done, start second
                withAnimation(.spring(duration: 0.3)) {
                    step2Complete = true
                }
            }
        }
    }
}
```

**Transaction-based completion (iOS 17+):**

```swift
struct TransactionCompletion: View {
    @State private var isExpanded = false

    var body: some View {
        CardView()
            .frame(height: isExpanded ? 300 : 100)
            .onTapGesture {
                var transaction = Transaction(animation: .spring(duration: 0.3))
                transaction.addAnimationCompletion {
                    print("Animation completed!")
                    // Perform post-animation logic
                }
                withTransaction(transaction) {
                    isExpanded.toggle()
                }
            }
    }
}
```

**Pre-iOS 17 delay approach:**

```swift
struct DelayedCompletion: View {
    @State private var isAnimating = false
    @State private var animationComplete = false
    let animationDuration: Double = 0.3

    var body: some View {
        Circle()
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .animation(.spring(duration: animationDuration), value: isAnimating)
            .onTapGesture {
                isAnimating = true

                // Approximate completion with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.1) {
                    animationComplete = true
                    // Handle completion
                }
            }
    }
}
```

**Using onChange for state-based completion:**

```swift
struct OnChangeCompletion: View {
    @State private var phase = 0

    var body: some View {
        VStack {
            PhaseIndicator(phase: phase)
                .animation(.spring(duration: 0.3), value: phase)
        }
        .onChange(of: phase) { oldValue, newValue in
            // React to phase changes
            if newValue == 1 {
                // Phase 1 reached, schedule phase 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    phase = 2
                }
            }
        }
    }
}
```

**Chained animations with completion:**

```swift
struct ChainedAnimations: View {
    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1

    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 50)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                startAnimationSequence()
            }
    }

    func startAnimationSequence() {
        // Step 1: Move
        withAnimation(.spring(duration: 0.4)) {
            position = CGPoint(x: 200, y: 200)
        } completion: {
            // Step 2: Scale
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                scale = 1.5
            } completion: {
                // Step 3: Fade
                withAnimation(.easeOut(duration: 0.2)) {
                    opacity = 0.5
                } completion: {
                    // Reset
                    withAnimation(.spring(duration: 0.3)) {
                        position = .zero
                        scale = 1
                        opacity = 1
                    }
                }
            }
        }
    }
}
```

**Repeating with completion awareness:**

```swift
struct RepeatingWithCount: View {
    @State private var bounceCount = 0
    @State private var scale: CGFloat = 1

    var body: some View {
        Circle()
            .scaleEffect(scale)
            .onAppear {
                performBounce()
            }
    }

    func performBounce() {
        guard bounceCount < 3 else { return }

        withAnimation(.spring(duration: 0.2, bounce: 0.5)) {
            scale = 1.2
        } completion: {
            withAnimation(.spring(duration: 0.2)) {
                scale = 1.0
            } completion: {
                bounceCount += 1
                performBounce() // Repeat
            }
        }
    }
}
```

Reference: [withAnimation completion](https://developer.apple.com/documentation/swiftui/withanimation(_:completionCriteria:_:completion:))
