---
title: Use NSAnimationContext for Grouping
impact: LOW-MEDIUM
impactDescription: groups related animations with shared timing
tags: appkit, nsanimation-context, grouping, macos, timing
---

## Use NSAnimationContext for Grouping

`NSAnimationContext` groups related animations and provides completion handlers. It's the AppKit equivalent of `withAnimation` for coordinating multiple property changes.

**Basic animation context:**

```swift
import AppKit

class AnimatedViewController: NSViewController {
    @IBOutlet weak var targetView: NSView!

    func animateView() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)

            // All changes here animate together
            targetView.animator().alphaValue = 0.5
            targetView.animator().frame.origin.x += 100
        }
    }
}
```

**With completion handler:**

```swift
func animateWithCompletion() {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.3
        context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        targetView.animator().alphaValue = 0
    } completionHandler: {
        // Called when animation completes
        self.targetView.removeFromSuperview()
    }
}
```

**Nested contexts for sequencing:**

```swift
func sequencedAnimations() {
    // First animation
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.2
        firstView.animator().alphaValue = 0
    } completionHandler: {
        // Second animation after first completes
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.secondView.animator().alphaValue = 1
            self.secondView.animator().frame.origin.y -= 20
        }
    }
}
```

**Disabling implicit animations:**

```swift
func instantChange() {
    NSAnimationContext.runAnimationGroup { context in
        // Duration 0 = instant, no animation
        context.duration = 0
        context.allowsImplicitAnimation = false

        targetView.animator().frame = newFrame
    }
}
```

**Custom timing functions:**

```swift
func customTimingAnimation() {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.4

        // Custom cubic bezier (like CSS cubic-bezier)
        context.timingFunction = CAMediaTimingFunction(
            controlPoints: 0.32, 0.72, 0, 1  // iOS sheet curve
        )

        targetView.animator().frame.origin.y = 0
    }
}
```

**Grouping multiple views:**

```swift
func animateMultipleViews(_ views: [NSView]) {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.3
        context.timingFunction = CAMediaTimingFunction(name: .easeOut)

        for (index, view) in views.enumerated() {
            // Stagger each view's animation
            let delay = Double(index) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                NSAnimationContext.runAnimationGroup { innerContext in
                    innerContext.duration = 0.25
                    view.animator().alphaValue = 1
                    view.animator().frame.origin.y -= 20
                }
            }
        }
    }
}
```

**Current context for implicit animations:**

```swift
func configureCurrentContext() {
    // Access the current implicit context
    NSAnimationContext.current.duration = 0.25
    NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: .easeOut)

    // Now any animator() calls use this timing
    view.animator().alphaValue = 0.5
}
```

**Available timing functions:**
- `.linear` - Constant speed
- `.easeIn` - Accelerates
- `.easeOut` - Decelerates
- `.easeInEaseOut` - S-curve
- `.default` - System default
- Custom `CAMediaTimingFunction(controlPoints:)` for cubic bezier

Reference: [NSAnimationContext](https://developer.apple.com/documentation/appkit/nsanimationcontext)
