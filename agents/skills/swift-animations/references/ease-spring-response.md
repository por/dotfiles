---
title: Configure Spring Response for Duration Feel
impact: MEDIUM
impactDescription: response controls perceived animation speed
tags: ease, spring, response, duration, tuning
---

## Configure Spring Response for Duration Feel

The spring `response` parameter controls how quickly the spring reaches its target—essentially its perceived duration. Lower values create snappier animations; higher values create more leisurely motion.

**Understanding response:**

```swift
// Snappy response (0.2-0.3 seconds)
.animation(.spring(response: 0.25, dampingFraction: 0.8), value: state)
// Quick, responsive feel for small UI elements

// Medium response (0.3-0.5 seconds)
.animation(.spring(response: 0.4, dampingFraction: 0.8), value: state)
// Balanced feel for general UI animations

// Slow response (0.5+ seconds)
.animation(.spring(response: 0.6, dampingFraction: 0.8), value: state)
// Leisurely, dramatic feel for large transitions
```

**Matching response to element size:**

```swift
struct AnimatedCard: View {
    @State private var isExpanded = false
    let cardSize: CGFloat

    var body: some View {
        CardContent()
            .frame(height: isExpanded ? cardSize * 2 : cardSize)
            .animation(
                // Larger elements need slightly longer response
                .spring(
                    response: cardSize > 200 ? 0.5 : 0.35,
                    dampingFraction: 0.75
                ),
                value: isExpanded
            )
    }
}
```

**iOS 17+ equivalent with duration:**

```swift
// response: 0.35 ≈ duration: 0.35
.animation(.spring(duration: 0.35, bounce: 0.25), value: state)
// duration parameter is more intuitive for most developers
```

**Response guidelines:**
| Response | Use Case |
|----------|----------|
| 0.2-0.25 | Micro-interactions (buttons, toggles) |
| 0.3-0.4 | Standard UI (cards, modals) |
| 0.5-0.6 | Large transitions (full-screen, sheets) |
| 0.7+ | Dramatic emphasis (onboarding, marketing) |

Reference: [Spring Animation](https://developer.apple.com/documentation/swiftui/spring)
