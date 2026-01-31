---
title: Use easeOut as Your Default Easing
impact: CRITICAL
impactDescription: transforms animation feel from sluggish to responsive
tags: ease, easing, ease-out, transitions, responsiveness
---

## Use easeOut as Your Default Easing

The easeOut curve starts fast and slows at the end, creating an impression of quick response while maintaining smooth transitions. This mimics how objects naturally decelerate when coming to rest.

**Incorrect (linear easing feels robotic):**

```swift
struct ModalView: View {
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ContentView()
                .opacity(isPresented ? 1 : 0)
                .animation(.linear(duration: 0.2), value: isPresented)
        }
    }
}
// Animation feels mechanical and disconnected
```

**Correct (easeOut feels responsive):**

```swift
struct ModalView: View {
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ContentView()
                .opacity(isPresented ? 1 : 0)
                .animation(.easeOut(duration: 0.2), value: isPresented)
        }
    }
}
// Starts fast, giving immediate feedback, then settles smoothly
```

**When to use easeOut:**
- Enter animations (elements appearing)
- User-initiated interactions (dropdowns, modals, tooltips)
- Any element responding to user action
- Default choice when unsure

**When NOT to use easeOut:**
- Exit animations (consider easeIn instead)
- Continuous looping animations
- Physics-based interactions (use springs instead)

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
