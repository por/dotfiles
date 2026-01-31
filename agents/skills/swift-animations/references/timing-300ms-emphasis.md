---
title: Keep Emphasis Animations Under 300ms
impact: CRITICAL
impactDescription: animations over 300ms feel slow and disconnected
tags: timing, duration, 300ms, maximum, emphasis
---

## Keep Emphasis Animations Under 300ms

300 milliseconds is the upper limit for UI animations before they start feeling slow. Beyond this threshold, users perceive the interface as sluggish and disconnected from their actions. Reserve longer durations only for special cases.

**Incorrect (exceeds threshold):**

```swift
struct ExpandingCard: View {
    @State private var isExpanded = false

    var body: some View {
        CardContent()
            .frame(height: isExpanded ? 400 : 150)
            .animation(.easeInOut(duration: 0.5), value: isExpanded)
            .onTapGesture { isExpanded.toggle() }
    }
}
// Half second feels like waiting, not responding
```

**Correct (within threshold):**

```swift
struct ExpandingCard: View {
    @State private var isExpanded = false

    var body: some View {
        CardContent()
            .frame(height: isExpanded ? 400 : 150)
            .animation(.spring(duration: 0.3, bounce: 0.2), value: isExpanded)
            .onTapGesture { isExpanded.toggle() }
    }
}
// Feels responsive while still visible
```

**Exceptions where longer durations are acceptable:**

```swift
// 1. Full-screen transitions
NavigationStack {
    // iOS default navigation is ~350ms - this is acceptable
}

// 2. Sheets and modals
.sheet(isPresented: $showSheet) {
    // System sheet animation is ~500ms
    SheetContent()
}

// 3. Onboarding/marketing
struct OnboardingAnimation: View {
    @State private var step = 0

    var body: some View {
        OnboardingContent(step: step)
            // 600ms is okay for deliberate, attention-grabbing motion
            .animation(.easeInOut(duration: 0.6), value: step)
    }
}

// 4. Loading states
struct LoadingIndicator: View {
    @State private var isRotating = false

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(lineWidth: 3)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            // Continuous rotation can be slow
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
    }
}
```

**Duration decision tree:**
1. Is it micro-feedback? → 100ms
2. Is it standard UI? → 200ms
3. Is it emphasis/larger? → 250-300ms
4. Is it full-screen/special? → Up to 500ms
5. Is it marketing/onboarding? → Up to 600ms+

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
