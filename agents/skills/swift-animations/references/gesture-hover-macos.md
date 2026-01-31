---
title: Handle Hover on macOS
impact: MEDIUM
impactDescription: hover provides preview feedback on desktop
tags: gesture, hover, macos, desktop, preview
---

## Handle Hover on macOS

The `.onHover` modifier enables hover interactions on macOS (and iPadOS with pointer). Hover feedback helps users understand interactivity before they click.

**Basic hover effect:**

```swift
struct HoverableCard: View {
    @State private var isHovered = false

    var body: some View {
        VStack {
            Text("Hover Me")
        }
        .padding()
        .background(isHovered ? Color.blue.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
```

**Hover with 3D tilt effect:**

```swift
struct TiltOnHover: View {
    @State private var isHovered = false
    @State private var hoverLocation: CGPoint = .zero
    @State private var cardSize: CGSize = .zero

    var body: some View {
        CardContent()
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear { cardSize = geo.size }
                }
            }
            .rotation3DEffect(
                .degrees(isHovered ? tiltX : 0),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(isHovered ? -tiltY : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.spring(response: 0.25), value: isHovered)
            .animation(.spring(response: 0.15), value: hoverLocation)
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    isHovered = true
                    hoverLocation = location
                case .ended:
                    isHovered = false
                }
            }
    }

    private var tiltX: Double {
        let centerY = cardSize.height / 2
        return (hoverLocation.y - centerY) / centerY * 5
    }

    private var tiltY: Double {
        let centerX = cardSize.width / 2
        return (hoverLocation.x - centerX) / centerX * 5
    }
}
```

**Hover reveal pattern:**

```swift
struct HoverReveal: View {
    @State private var isHovered = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("thumbnail")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 150)
                .clipped()

            // Action buttons revealed on hover
            HStack {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(8)
            .opacity(isHovered ? 1 : 0)
            .offset(y: isHovered ? 0 : 10)
            .animation(.easeOut(duration: 0.2), value: isHovered)
        }
        .onHover { isHovered = $0 }
    }
}
```

**List row hover:**

```swift
struct HoverableList: View {
    let items: [Item]

    var body: some View {
        List(items) { item in
            HoverableRow(item: item)
        }
    }
}

struct HoverableRow: View {
    let item: Item
    @State private var isHovered = false

    var body: some View {
        HStack {
            Text(item.title)
            Spacer()
            Image(systemName: "chevron.right")
                .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.vertical, 4)
        .background(isHovered ? Color.accentColor.opacity(0.1) : Color.clear)
        .animation(.easeOut(duration: 0.15), value: isHovered)
        .onHover { isHovered = $0 }
    }
}
```

**Custom cursor on hover:**

```swift
struct CustomCursorHover: View {
    var body: some View {
        Text("Hover for pointer cursor")
            .padding()
            .onHover { isHovered in
                if isHovered {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
    }
}
```

Reference: [onHover](https://developer.apple.com/documentation/swiftui/view/onhover(perform:))
