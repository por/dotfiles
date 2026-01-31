---
title: Use easeIn for Exit Animations
impact: HIGH
impactDescription: creates perception of elements leaving the scene naturally
tags: ease, ease-in, exit, transitions, dismiss
---

## Use easeIn for Exit Animations

The easeIn curve starts slow and accelerates, creating a perception of an element gathering momentum as it leaves. This makes exit animations feel purposeful rather than abrupt, as if the element is moving away into the distance.

**Incorrect (easeOut for exit feels wrong):**

```swift
struct NotificationBanner: View {
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            BannerContent()
                .transition(
                    .move(edge: .top)
                    .animation(.easeOut(duration: 0.3))
                )
        }
    }
}
// Exit feels like it's fighting to stay, then suddenly vanishes
```

**Correct (easeIn for exit feels natural):**

```swift
struct NotificationBanner: View {
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            BannerContent()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top)
                            .animation(.easeOut(duration: 0.3)),
                        removal: .move(edge: .top)
                            .animation(.easeIn(duration: 0.25))
                    )
                )
        }
    }
}
// Exit accelerates away naturally, like it's being dismissed
```

**Alternative with combined opacity:**

```swift
.transition(
    .asymmetric(
        insertion: .opacity.combined(with: .move(edge: .top))
            .animation(.easeOut(duration: 0.3)),
        removal: .opacity.combined(with: .move(edge: .top))
            .animation(.easeIn(duration: 0.2))
    )
)
```

**Duration tip:**
- Make exit animations slightly faster than enter (0.25s vs 0.3s)
- Users want dismissed content gone quickly

Reference: [SwiftUI Transition](https://developer.apple.com/documentation/swiftui/anytransition)
