---
title: Stagger Child Animations for Orchestration
impact: HIGH
impactDescription: staggering creates rhythm and visual hierarchy
tags: timing, stagger, children, orchestration, sequence
---

## Stagger Child Animations for Orchestration

Staggering child animations creates a cascading effect that guides the eye and adds visual polish. Rather than animating all children simultaneously, introduce small delays (30-50ms) between each element.

**Incorrect (all at once feels flat):**

```swift
struct ItemList: View {
    @State private var isVisible = false
    let items: [Item]

    var body: some View {
        VStack {
            ForEach(items) { item in
                ItemRow(item: item)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
            }
        }
        .animation(.easeOut(duration: 0.3), value: isVisible)
        .onAppear { isVisible = true }
    }
}
// All items animate together, feels mechanical
```

**Correct (staggered creates rhythm):**

```swift
struct ItemList: View {
    @State private var isVisible = false
    let items: [Item]

    var body: some View {
        VStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ItemRow(item: item)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.3)
                        .delay(Double(index) * 0.05), // 50ms stagger
                        value: isVisible
                    )
            }
        }
        .onAppear { isVisible = true }
    }
}
// Items cascade in, creating visual flow
```

**iOS 17+ PhaseAnimator for complex staggering:**

```swift
struct StaggeredList: View {
    let items: [Item]

    var body: some View {
        VStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                PhaseAnimator([false, true], trigger: item.id) { phase in
                    ItemRow(item: item)
                        .opacity(phase ? 1 : 0)
                        .offset(y: phase ? 0 : 20)
                } animation: { _ in
                    .easeOut(duration: 0.3).delay(Double(index) * 0.05)
                }
            }
        }
    }
}
```

**Stagger guidelines:**
| Stagger Delay | Use Case |
|---------------|----------|
| 30-50ms | Lists with many items |
| 50-80ms | Small groups (3-5 items) |
| 100ms+ | Hero sequences, onboarding |

**Cap total stagger time:**

```swift
// Avoid total animation time exceeding ~400-500ms
let maxStagger = min(Double(index) * 0.05, 0.3)
.delay(maxStagger)
```

Reference: [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)
