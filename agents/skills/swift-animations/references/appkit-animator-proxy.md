---
title: Use Animator Proxy for View Animations
impact: LOW-MEDIUM
impactDescription: convenient API for animating NSView properties
tags: appkit, animator, proxy, nsview, convenience
---

## Use Animator Proxy for View Animations

The `animator()` proxy provides a convenient way to animate NSView properties. Instead of creating explicit CAAnimations, set properties on `view.animator()` and they animate automatically.

**Basic animator usage:**

```swift
import AppKit

class AnimatorExampleView: NSView {
    func fadeOut() {
        // Instead of direct property change:
        // self.alphaValue = 0

        // Use animator for animated change:
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.animator().alphaValue = 0
        }
    }

    func move(to point: CGPoint) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.animator().frame.origin = point
        }
    }
}
```

**Animatable properties via animator():**

```swift
func demonstrateAnimatableProperties() {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.3

        // Position and size
        animator().frame = newFrame
        animator().frameOrigin = newOrigin
        animator().frameSize = newSize
        animator().frameCenterRotation = 45 // Degrees

        // Visibility
        animator().alphaValue = 0.5
        animator().isHidden = true

        // For layer-backed views
        if wantsLayer {
            // These work when layer-backed
            animator().layer?.backgroundColor = NSColor.red.cgColor
            animator().layer?.cornerRadius = 12
        }
    }
}
```

**Combining multiple animations:**

```swift
func combinedAnimation() {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.4
        context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // All these animate together
        animator().frame = NSRect(x: 100, y: 100, width: 200, height: 200)
        animator().alphaValue = 0.8
        animator().frameCenterRotation = 15
    }
}
```

**Sequential animations with completion:**

```swift
func sequentialAnimations() {
    // First: fade and scale
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.2
        animator().alphaValue = 0.5
        animator().frame = frame.insetBy(dx: 10, dy: 10)
    } completionHandler: {
        // Then: restore
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.animator().alphaValue = 1.0
            self.animator().frame = self.frame.insetBy(dx: -10, dy: -10)
        }
    }
}
```

**Window animations:**

```swift
class AnimatedWindowController: NSWindowController {
    func fadeInWindow() {
        window?.alphaValue = 0
        window?.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            window?.animator().alphaValue = 1.0
        }
    }

    func slideIn(from edge: NSRectEdge) {
        guard let window = window, let screen = window.screen else { return }

        var startFrame = window.frame
        switch edge {
        case .minX: startFrame.origin.x = -startFrame.width
        case .maxX: startFrame.origin.x = screen.frame.maxX
        case .minY: startFrame.origin.y = -startFrame.height
        case .maxY: startFrame.origin.y = screen.frame.maxY
        @unknown default: break
        }

        window.setFrame(startFrame, display: false)
        window.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.35
            context.timingFunction = CAMediaTimingFunction(
                controlPoints: 0.32, 0.72, 0, 1
            )
            window.animator().setFrame(originalFrame, display: true)
        }
    }
}
```

**View controller transitions:**

```swift
class AnimatedContainerController: NSViewController {
    var currentChild: NSViewController?

    func transition(to newChild: NSViewController) {
        let oldChild = currentChild

        addChild(newChild)
        newChild.view.frame = view.bounds
        newChild.view.alphaValue = 0

        if let oldChild = oldChild {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                oldChild.view.animator().alphaValue = 0
                newChild.view.animator().alphaValue = 1
            } completionHandler: {
                oldChild.view.removeFromSuperview()
                oldChild.removeFromParent()
            }
        } else {
            view.addSubview(newChild.view)
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                newChild.view.animator().alphaValue = 1
            }
        }

        currentChild = newChild
    }
}
```

**Constraints animation:**

```swift
func animateConstraints() {
    // Update constraint constant
    heightConstraint.constant = 200

    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.3
        context.allowsImplicitAnimation = true // Required for constraint animation

        // Force layout update within animation context
        view.layoutSubtreeIfNeeded()
    }
}
```

Reference: [NSAnimatablePropertyContainer](https://developer.apple.com/documentation/appkit/nsanimatablepropertycontainer)
