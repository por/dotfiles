---
title: Use withAnimation for Explicit Control
impact: HIGH
impactDescription: explicit animations give precise control over what animates
tags: props, withAnimation, explicit, state, control
---

## Use withAnimation for Explicit Control

The `withAnimation` function wraps state changes to animate only those specific changes. This gives you precise control over which properties animate and with what timing, avoiding the cascading effects of implicit animations.

**Implicit animation (broad effect):**

```swift
struct ToggleCard: View {
    @State private var isOn = false
    @State private var lastUpdated = Date()

    var body: some View {
        VStack {
            Toggle("Feature", isOn: $isOn)
            Text("Updated: \(lastUpdated.formatted())")
        }
        // This animates EVERYTHING that changes
        .animation(.spring(), value: isOn)
        .onChange(of: isOn) { lastUpdated = Date() }
    }
}
// Both toggle AND timestamp animate - timestamp animation is weird
```

**Explicit animation (precise control):**

```swift
struct ToggleCard: View {
    @State private var isOn = false
    @State private var lastUpdated = Date()

    var body: some View {
        VStack {
            Toggle("Feature", isOn: Binding(
                get: { isOn },
                set: { newValue in
                    // Only animate the toggle change
                    withAnimation(.spring()) {
                        isOn = newValue
                    }
                    // Timestamp updates without animation
                    lastUpdated = Date()
                }
            ))
            Text("Updated: \(lastUpdated.formatted())")
        }
    }
}
// Toggle animates, timestamp changes instantly
```

**Multiple state changes with different animations:**

```swift
struct MultiStateView: View {
    @State private var showContent = false
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Button("Toggle") {
                // Slow spring for content reveal
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    showContent.toggle()
                }
            }

            TabSelector(selection: Binding(
                get: { selectedTab },
                set: { newTab in
                    // Fast easeOut for tab switch
                    withAnimation(.easeOut(duration: 0.15)) {
                        selectedTab = newTab
                    }
                }
            ))
        }
    }
}
```

**Chained animations with completion:**

```swift
struct SequencedAnimation: View {
    @State private var step1 = false
    @State private var step2 = false

    var body: some View {
        VStack {
            Element1()
                .opacity(step1 ? 1 : 0)

            Element2()
                .opacity(step2 ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                step1 = true
            }
            // Delay second animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    step2 = true
                }
            }
        }
    }
}
```

**When to use withAnimation vs .animation():**
- Use `withAnimation` when you need precise control
- Use `.animation()` for simple, single-value animations
- Prefer `withAnimation` in production apps for predictability

Reference: [withAnimation](https://developer.apple.com/documentation/swiftui/withanimation(_:_:))
