---
title: Animate Sheet Presentations
impact: MEDIUM
impactDescription: customized sheets enhance user experience
tags: transition, sheet, modal, presentation, detents
---

## Animate Sheet Presentations

Sheets and modals can be customized with presentation modifiers. Control detents, background, and interaction while leveraging system-provided smooth animations.

**Basic sheet with detents:**

```swift
struct SheetExample: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            SheetContent()
                .presentationDetents([.medium, .large])
        }
    }
}
```

**Custom detent heights:**

```swift
.presentationDetents([
    .height(200),           // Fixed height
    .fraction(0.4),         // Percentage of screen
    .medium,                // System medium
    .large                  // System large (full)
])
```

**Custom detent with calculation:**

```swift
struct ContentSizedDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        // Return calculated height based on content
        return min(context.maxDetentValue, 400)
    }
}

// Usage
.presentationDetents([.height(200), .custom(ContentSizedDetent.self)])
```

**Sheet background and styling:**

```swift
.sheet(isPresented: $showSheet) {
    SheetContent()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .presentationBackground(.ultraThinMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .interactiveDismissDisabled(isEditing) // Prevent accidental dismiss
}
```

**Animated content based on detent:**

```swift
struct AdaptiveSheet: View {
    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        VStack {
            // Compact content at medium
            HeaderView()

            // Expanded content at large
            if selectedDetent == .large {
                ExpandedContent()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .animation(.spring(duration: 0.3), value: selectedDetent)
    }
}
```

**Full-screen cover with custom transition:**

```swift
struct FullScreenExample: View {
    @Namespace private var animation
    @State private var showFullScreen = false

    var body: some View {
        Button("Expand") {
            withAnimation(.spring(duration: 0.4)) {
                showFullScreen = true
            }
        }
        .matchedGeometryEffect(id: "button", in: animation)
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenContent()
                .matchedGeometryEffect(id: "button", in: animation)
                .onTapGesture {
                    withAnimation(.spring(duration: 0.3)) {
                        showFullScreen = false
                    }
                }
        }
    }
}
```

**Popover on iPad/Mac:**

```swift
struct PopoverExample: View {
    @State private var showPopover = false

    var body: some View {
        Button("Show Options") {
            showPopover = true
        }
        .popover(isPresented: $showPopover, arrowEdge: .top) {
            PopoverContent()
                .frame(width: 300, height: 400)
                .presentationCompactAdaptation(.popover)
        }
    }
}
```

**Confirmation dialog animation:**

```swift
struct DialogExample: View {
    @State private var showDialog = false

    var body: some View {
        Button("Delete") {
            showDialog = true
        }
        .confirmationDialog("Delete Item?", isPresented: $showDialog) {
            Button("Delete", role: .destructive) {
                // Delete action
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
```

Reference: [Sheet presentation modifiers](https://developer.apple.com/documentation/swiftui/view/presentationdetents(_:))
