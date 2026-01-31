---
title: Use Subtle Scale Values (0.95-0.98)
impact: HIGH
impactDescription: subtle scale creates polished micro-feedback
tags: transform, scale, subtle, feedback, press
---

## Use Subtle Scale Values (0.95-0.98)

Scale feedback for button presses and taps should be subtle—typically between 0.95 and 0.98. Larger scale changes feel exaggerated and cartoonish, while values closer to 1.0 provide elegant, professional feedback.

**Incorrect (too much scale feels cheap):**

```swift
struct OverscaledButton: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: { /* action */ }) {
            Text("Submit")
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        // 0.8 is way too much - feels like a cartoon
        .scaleEffect(isPressed ? 0.8 : 1.0)
        .animation(.spring(response: 0.2), value: isPressed)
    }
}
```

**Correct (subtle scale feels premium):**

```swift
struct RefinedButton: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: { /* action */ }) {
            Text("Submit")
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        // 0.97 is subtle but noticeable
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.15, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

**Scale guidelines by element type:**

```swift
// Small buttons, icons: 0.95
.scaleEffect(isPressed ? 0.95 : 1.0)

// Medium buttons: 0.97
.scaleEffect(isPressed ? 0.97 : 1.0)

// Large cards, tiles: 0.98
.scaleEffect(isPressed ? 0.98 : 1.0)

// List rows: 0.99 or no scale
.scaleEffect(isPressed ? 0.99 : 1.0)
```

**Never scale from zero:**

```swift
// BAD: Scale from 0 looks artificial
.scaleEffect(isVisible ? 1.0 : 0.0)

// GOOD: Scale from 0.95 for enter animation
.scaleEffect(isVisible ? 1.0 : 0.95)
.opacity(isVisible ? 1.0 : 0.0)
```

**Combining scale with other effects:**

```swift
struct PolishedCard: View {
    @State private var isPressed = false

    var body: some View {
        CardContent()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(radius: isPressed ? 4 : 8) // Shadow shrinks too
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
    }
}
```

Reference: [scaleEffect](https://developer.apple.com/documentation/swiftui/view/scaleeffect(_:anchor:))
