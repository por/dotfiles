---
title: Set Anchor Points for Transforms
impact: HIGH
impactDescription: anchor point defines the pivot for rotation and scale
tags: props, anchor, origin, scale, rotation
---

## Set Anchor Points for Transforms

The anchor point determines where scale and rotation transforms originate. By default, SwiftUI uses `.center`, but many animations look better with different anchors like `.top`, `.leading`, or a custom `UnitPoint`.

**Incorrect (default center anchor for menu):**

```swift
struct DropdownMenu: View {
    @State private var isOpen = false

    var body: some View {
        VStack(alignment: .leading) {
            Button("Menu") { isOpen.toggle() }

            if isOpen {
                MenuContent()
                    .scaleEffect(isOpen ? 1 : 0.8)
                    .opacity(isOpen ? 1 : 0)
                    .animation(.spring(), value: isOpen)
            }
        }
    }
}
// Menu scales from center, feels disconnected from button
```

**Correct (anchor at top for natural connection):**

```swift
struct DropdownMenu: View {
    @State private var isOpen = false

    var body: some View {
        VStack(alignment: .leading) {
            Button("Menu") { isOpen.toggle() }

            if isOpen {
                MenuContent()
                    // Scale from top-leading to connect to button
                    .scaleEffect(isOpen ? 1 : 0.8, anchor: .topLeading)
                    .opacity(isOpen ? 1 : 0)
                    .animation(.spring(), value: isOpen)
            }
        }
    }
}
// Menu appears to grow from button location
```

**Common anchor patterns:**

```swift
// Card flip from center (natural)
.rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
// Default .center anchor is correct

// Notification banner from top
.scaleEffect(isVisible ? 1 : 0.95, anchor: .top)
.offset(y: isVisible ? 0 : -20)

// FAB menu expanding upward
.scaleEffect(isExpanded ? 1 : 0, anchor: .bottom)

// Side panel from edge
.scaleEffect(x: isOpen ? 1 : 0, anchor: .leading)
```

**Custom anchor points:**

```swift
struct ContextMenu: View {
    @State private var isOpen = false
    let tapLocation: CGPoint
    let containerSize: CGSize

    var anchor: UnitPoint {
        UnitPoint(
            x: tapLocation.x / containerSize.width,
            y: tapLocation.y / containerSize.height
        )
    }

    var body: some View {
        MenuContent()
            .scaleEffect(isOpen ? 1 : 0.8, anchor: anchor)
            .opacity(isOpen ? 1 : 0)
            .animation(.spring(duration: 0.2), value: isOpen)
    }
}
// Menu opens from exact tap location
```

**Anchor reference:**
| Anchor | Location |
|--------|----------|
| `.topLeading` | Top-left corner |
| `.top` | Top center |
| `.topTrailing` | Top-right corner |
| `.leading` | Left center |
| `.center` | Center (default) |
| `.trailing` | Right center |
| `.bottomLeading` | Bottom-left |
| `.bottom` | Bottom center |
| `.bottomTrailing` | Bottom-right |

Reference: [UnitPoint](https://developer.apple.com/documentation/swiftui/unitpoint)
