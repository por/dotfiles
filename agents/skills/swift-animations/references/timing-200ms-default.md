---
title: Use 200ms as Default UI Animation Duration
impact: CRITICAL
impactDescription: 200ms is the sweet spot for responsive UI
tags: timing, duration, 200ms, responsiveness, default
---

## Use 200ms as Default UI Animation Duration

200 milliseconds (0.2 seconds) is the optimal default duration for most UI animations. It's fast enough to feel responsive but slow enough for the eye to follow the motion. This creates interfaces that feel snappy yet polished.

**Incorrect (too slow):**

```swift
struct DropdownMenu: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Button("Options") {
                isExpanded.toggle()
            }
            if isExpanded {
                MenuContent()
            }
        }
        .animation(.easeOut(duration: 0.5), value: isExpanded)
    }
}
// 500ms feels sluggish, user waits for UI
```

**Correct (snappy 200ms):**

```swift
struct DropdownMenu: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Button("Options") {
                isExpanded.toggle()
            }
            if isExpanded {
                MenuContent()
            }
        }
        .animation(.easeOut(duration: 0.2), value: isExpanded)
    }
}
// Responsive and connected to user action
```

**Spring equivalent:**

```swift
// Spring with similar perceived duration
.animation(.spring(duration: 0.2, bounce: 0.2), value: isExpanded)
// Note: Spring's actual duration may exceed 200ms due to bounce settling
```

**Duration guidelines:**
| Duration | Use Case |
|----------|----------|
| 0.1-0.15s | Micro-feedback (button press, toggle) |
| 0.2s | Standard UI transitions |
| 0.25-0.3s | Larger element changes |
| 0.3s+ | Only for emphasis or reduced frequency |

Reference: [Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
