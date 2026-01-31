---
title: Use Asymmetric for Different Enter/Exit
impact: HIGH
impactDescription: different animations for appear vs disappear
tags: transition, asymmetric, enter, exit, insertion, removal
---

## Use Asymmetric for Different Enter/Exit

`AnyTransition.asymmetric` allows different animations for when a view appears versus when it disappears. This creates more nuanced, context-appropriate transitions.

**Basic asymmetric transition:**

```swift
struct NotificationBanner: View {
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            BannerContent()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    )
                )
        }
    }
}
```

**Different timing for enter/exit:**

```swift
struct TimedTransition: View {
    @State private var showContent = false

    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation {
                    showContent.toggle()
                }
            }

            if showContent {
                ContentView()
                    .transition(
                        .asymmetric(
                            // Slower entrance - user notices new content
                            insertion: .scale(scale: 0.9)
                                .combined(with: .opacity)
                                .animation(.spring(duration: 0.35)),
                            // Faster exit - dismissed content leaves quickly
                            removal: .scale(scale: 0.95)
                                .combined(with: .opacity)
                                .animation(.easeIn(duration: 0.2))
                        )
                    )
            }
        }
    }
}
```

**Slide in from one direction, fade out:**

```swift
struct SlideInFadeOut: View {
    @Binding var showDetail: Bool

    var body: some View {
        if showDetail {
            DetailView()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .opacity
                    )
                )
        }
    }
}
```

**Context-aware transitions:**

```swift
struct ContextTransition: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0

    var direction: Edge {
        selectedTab > previousTab ? .trailing : .leading
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0..<3) { index in
                TabContent(index: index)
                    .tag(index)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: direction),
                            removal: .move(edge: direction == .trailing ? .leading : .trailing)
                        )
                    )
            }
        }
        .onChange(of: selectedTab) { old, _ in
            previousTab = old
        }
    }
}
```

**Toast notification pattern:**

```swift
struct Toast: View {
    @Binding var message: String?

    var body: some View {
        if let message = message {
            Text(message)
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .transition(
                    .asymmetric(
                        // Slide up from bottom with spring
                        insertion: .move(edge: .bottom)
                            .combined(with: .opacity)
                            .animation(.spring(duration: 0.3, bounce: 0.2)),
                        // Fade out quickly
                        removal: .opacity
                            .animation(.easeOut(duration: 0.15))
                    )
                )
        }
    }
}
```

Reference: [AnyTransition.asymmetric](https://developer.apple.com/documentation/swiftui/anytransition/asymmetric(insertion:removal:))
