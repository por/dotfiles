---
title: Use Delay Strategically for Sequencing
impact: MEDIUM
impactDescription: delays orchestrate multi-element animations
tags: timing, delay, sequence, orchestration, coordination
---

## Use Delay Strategically for Sequencing

Animation delays create sequenced effects where elements animate in a coordinated order. Use delays to direct attention, establish relationships, and create narrative flow in your animations.

**Sequential reveal pattern:**

```swift
struct WelcomeScreen: View {
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 24) {
            // Logo appears first
            Image("logo")
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.8)
                .animation(.spring(duration: 0.4), value: isVisible)

            // Headline follows
            Text("Welcome Back")
                .font(.largeTitle)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.easeOut(duration: 0.3).delay(0.15), value: isVisible)

            // Subtitle after headline
            Text("Pick up where you left off")
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 15)
                .animation(.easeOut(duration: 0.3).delay(0.25), value: isVisible)

            // CTA last
            Button("Continue") { }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
                .animation(.easeOut(duration: 0.3).delay(0.35), value: isVisible)
        }
        .onAppear { isVisible = true }
    }
}
```

**Delayed feedback for secondary elements:**

```swift
struct SuccessState: View {
    @State private var showSuccess = false

    var body: some View {
        VStack {
            // Primary: checkmark appears immediately
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
                .scaleEffect(showSuccess ? 1 : 0.5)
                .opacity(showSuccess ? 1 : 0)
                .animation(.spring(duration: 0.35, bounce: 0.3), value: showSuccess)

            // Secondary: message appears after
            Text("Payment Successful")
                .opacity(showSuccess ? 1 : 0)
                .animation(.easeOut(duration: 0.2).delay(0.2), value: showSuccess)

            // Tertiary: details appear last
            Text("Receipt sent to email")
                .font(.caption)
                .foregroundStyle(.secondary)
                .opacity(showSuccess ? 1 : 0)
                .animation(.easeOut(duration: 0.2).delay(0.35), value: showSuccess)
        }
    }
}
```

**Avoid excessive delays:**

```swift
// BAD: Too many delays make it feel slow
.animation(.easeOut.delay(0.5), value: state) // Half second wait is too long

// GOOD: Keep delays short and purposeful
.animation(.easeOut.delay(0.1), value: state) // Just enough to sequence
```

**Delay best practices:**
- Keep individual delays under 200ms
- Total sequence should complete within 500-600ms
- Earlier elements get shorter/no delays
- Later elements get progressively longer delays

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
