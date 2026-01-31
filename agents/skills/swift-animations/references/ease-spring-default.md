---
title: Prefer Springs for Natural Motion
impact: CRITICAL
impactDescription: spring physics creates organic, interruptible movement
tags: ease, spring, physics, natural-motion, interruptible
---

## Prefer Springs for Natural Motion

Nothing in the real world moves with perfect easing curves. Spring animations create organic, lifelike movement and are inherently interruptible—they handle mid-animation changes gracefully without jarring transitions.

**Incorrect (abrupt easing transition):**

```swift
struct ToggleButton: View {
    @State private var isOn = false

    var body: some View {
        Circle()
            .fill(isOn ? .green : .gray)
            .frame(width: 30, height: 30)
            .offset(x: isOn ? 20 : -20)
            .animation(.easeInOut(duration: 0.2), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}
// Rapid toggles create jarring direction changes
```

**Correct (spring handles interruptions):**

```swift
struct ToggleButton: View {
    @State private var isOn = false

    var body: some View {
        Circle()
            .fill(isOn ? .green : .gray)
            .frame(width: 30, height: 30)
            .offset(x: isOn ? 20 : -20)
            .animation(.spring(), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}
// Mid-animation toggles blend smoothly into new direction
```

**iOS 17+ Spring with explicit parameters:**

```swift
.animation(.spring(duration: 0.3, bounce: 0.2), value: isOn)
// duration: perceived duration
// bounce: 0 = no overshoot, 0.5 = bouncy
```

**When NOT to use springs:**
- Progress indicators where linear motion shows progress
- Time-critical UI where exact duration matters
- Reduced motion accessibility contexts

Reference: [Spring Animation](https://developer.apple.com/documentation/swiftui/spring)
