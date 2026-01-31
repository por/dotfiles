---
title: Every Animation Needs Purpose
impact: MEDIUM
impactDescription: purposeless animation distracts and annoys
tags: strategy, purpose, intent, meaning, design
---

## Every Animation Needs Purpose

Before adding animation, ask "what does this communicate?" Animation should serve a functional purpose—providing feedback, guiding attention, explaining relationships, or reinforcing brand. Animation without purpose is noise.

**Valid purposes for animation:**

```swift
// 1. FEEDBACK: Confirm user action was registered
struct FeedbackButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Save") { saveData() }
            .scaleEffect(isPressed ? 0.97 : 1.0) // Purpose: confirms touch
            .animation(.spring(response: 0.15), value: isPressed)
    }
}

// 2. GUIDANCE: Direct attention to important change
struct NotificationBadge: View {
    @State private var hasNew = false

    var body: some View {
        Image(systemName: "bell")
            .overlay(alignment: .topTrailing) {
                if hasNew {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                        // Purpose: draws eye to new notification
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.3), value: hasNew)
    }
}

// 3. RELATIONSHIP: Show connection between elements
struct ExpandingCard: View {
    @Namespace private var animation
    @State private var isExpanded = false

    var body: some View {
        // Purpose: matchedGeometryEffect shows detail came from card
        CardView()
            .matchedGeometryEffect(id: "card", in: animation)
    }
}

// 4. STATE: Communicate system status
struct LoadingState: View {
    @State private var isLoading = false

    var body: some View {
        if isLoading {
            ProgressView()
                // Purpose: shows system is working
                .transition(.opacity)
        }
    }
}
```

**Animations to avoid:**

```swift
// BAD: Gratuitous animation on every state change
struct OverAnimatedView: View {
    @State private var count = 0

    var body: some View {
        Text("\(count)")
            // Why animate a simple counter increment?
            .rotationEffect(.degrees(Double(count) * 10))
            .scaleEffect(1 + CGFloat(count) * 0.01)
            // This adds nothing but distraction
    }
}

// BAD: Animation that fights user intent
struct AnnoyingDelay: View {
    @State private var showContent = false

    var body: some View {
        if showContent {
            ContentView()
                // 1 second delay frustrates users wanting content
                .transition(.opacity.animation(.easeOut(duration: 1)))
        }
    }
}
```

**Decision framework:**

```swift
// Ask before animating:
// 1. Does this help the user understand what happened?
// 2. Does this guide attention to something important?
// 3. Does this make a relationship clearer?
// 4. Does this reinforce brand identity (sparingly)?
// 5. Would removing this animation make the app worse?

// If you can't answer yes to at least one, don't animate
```

**The "no animation" option:**

```swift
// Sometimes instant is better
struct InstantToggle: View {
    @State private var isEnabled = false

    var body: some View {
        // Simple toggle doesn't need animation
        Toggle("Notifications", isOn: $isEnabled)
        // User knows they tapped it - animation adds nothing
    }
}
```

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
