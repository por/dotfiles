---
title: Use Motion to Show Hierarchy
impact: MEDIUM
impactDescription: animation emphasizes what matters most
tags: strategy, hierarchy, emphasis, attention, priority
---

## Use Motion to Show Hierarchy

Motion draws attention. Use it strategically to emphasize primary actions and de-emphasize secondary elements. The most important elements should have the most prominent (not necessarily the most) animation.

**Primary vs secondary actions:**

```swift
struct ActionButtons: View {
    @State private var isPrimaryPressed = false
    @State private var isSecondaryPressed = false

    var body: some View {
        HStack(spacing: 16) {
            // Primary: prominent animation
            Button("Continue") { }
                .buttonStyle(.borderedProminent)
                .scaleEffect(isPrimaryPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPrimaryPressed)

            // Secondary: subtle or no animation
            Button("Skip") { }
                .buttonStyle(.bordered)
                .opacity(isSecondaryPressed ? 0.7 : 1.0)
                .animation(.easeOut(duration: 0.1), value: isSecondaryPressed)
        }
    }
}
```

**Draw attention to new content:**

```swift
struct NotificationList: View {
    let notifications: [Notification]

    var body: some View {
        List(notifications) { notification in
            NotificationRow(notification: notification)
                .listRowBackground(
                    notification.isNew
                        ? Color.blue.opacity(0.1)
                        : Color.clear
                )
                // Only new items animate in prominently
                .transition(
                    notification.isNew
                        ? .slide.combined(with: .opacity)
                        : .opacity
                )
        }
    }
}
```

**Hero element emphasis:**

```swift
struct OnboardingScreen: View {
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 24) {
            // Hero: large, prominent animation
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)
                .animation(.spring(duration: 0.5, bounce: 0.3), value: isVisible)

            // Secondary: simpler animation
            Text("Welcome")
                .font(.largeTitle)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.2), value: isVisible)

            // Tertiary: subtle fade only
            Text("Let's get started")
                .opacity(isVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.3), value: isVisible)
        }
        .onAppear { isVisible = true }
    }
}
```

**Reduce animation on supporting elements:**

```swift
struct ProductCard: View {
    @State private var isHovered = false

    var body: some View {
        VStack {
            // Product image: primary, animates
            ProductImage()
                .scaleEffect(isHovered ? 1.02 : 1.0)
                .animation(.spring(response: 0.25), value: isHovered)

            // Price: secondary, subtle animation
            Text("$99.99")
                .opacity(isHovered ? 1 : 0.9)
                .animation(.easeOut(duration: 0.15), value: isHovered)

            // Details: tertiary, no animation
            Text("In stock")
                .foregroundStyle(.secondary)
            // Static - doesn't need attention
        }
        .onHover { isHovered = $0 }
    }
}
```

**Error states deserve attention:**

```swift
struct FormField: View {
    @State private var hasError = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: .constant(""))
                .textFieldStyle(.roundedBorder)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(hasError ? Color.red : Color.clear, lineWidth: 2)
                )
                .offset(x: shakeOffset)
                // Error state gets prominent shake
                .animation(.spring(response: 0.1, dampingFraction: 0.3), value: shakeOffset)

            if hasError {
                Text("Invalid email address")
                    .foregroundStyle(.red)
                    .font(.caption)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeOut(duration: 0.2), value: hasError)
    }

    func shake() {
        shakeOffset = 10
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shakeOffset = -10
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                shakeOffset = 0
            }
        }
    }
}
```

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
