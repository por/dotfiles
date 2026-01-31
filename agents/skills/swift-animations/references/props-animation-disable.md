---
title: Use animation(nil) to Prevent Unwanted Animations
impact: HIGH
impactDescription: blocks animation inheritance for specific properties
tags: props, animation, nil, disable, inheritance
---

## Use animation(nil) to Prevent Unwanted Animations

SwiftUI's implicit animation system can cause unexpected animations when parent views have `.animation()` modifiers. Use `.animation(nil, value:)` to explicitly block animation for specific properties.

**Incorrect (unintended animation inheritance):**

```swift
struct ProfileHeader: View {
    @State private var isEditing = false
    @State private var avatarURL: URL?

    var body: some View {
        HStack {
            AsyncImage(url: avatarURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            // This animates when isEditing changes due to parent animation

            Text(isEditing ? "Editing..." : "Profile")
        }
        .animation(.spring(), value: isEditing)
    }
}
// Avatar crossfades when editing state changes - looks wrong
```

**Correct (block animation for image):**

```swift
struct ProfileHeader: View {
    @State private var isEditing = false
    @State private var avatarURL: URL?

    var body: some View {
        HStack {
            AsyncImage(url: avatarURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            // Explicitly block animation inheritance
            .animation(nil, value: isEditing)

            Text(isEditing ? "Editing..." : "Profile")
        }
        .animation(.spring(), value: isEditing)
    }
}
// Avatar stays static, only text animates
```

**Selective animation blocking:**

```swift
struct AnimatedCard: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            // Animate size
            Rectangle()
                .frame(height: isExpanded ? 200 : 100)

            // Don't animate color change
            Rectangle()
                .fill(isExpanded ? .blue : .gray)
                .animation(nil, value: isExpanded) // Block color animation
                .frame(height: 50)
        }
        .animation(.spring(), value: isExpanded)
    }
}
```

**Transaction-based approach for more control:**

```swift
struct PreciseAnimationControl: View {
    @State private var state = ViewState()

    var body: some View {
        ContentView(state: state)
            .transaction { transaction in
                // Disable all animations in this subtree
                transaction.animation = nil
            }
    }
}

// Or selectively:
var body: some View {
    Button("Update") {
        var transaction = Transaction()
        transaction.animation = nil
        withTransaction(transaction) {
            // This state change won't animate
            instantValue = newValue
        }
        withAnimation(.spring()) {
            // This state change will animate
            animatedValue = newValue
        }
    }
}
```

**Common scenarios for animation(nil):**
- Loading indicators that shouldn't fade
- Data that updates without visual change
- Third-party views with internal state
- Breaking animation inheritance chains

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
