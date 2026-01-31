---
title: Leverage Implicit Layer Animations
impact: LOW-MEDIUM
impactDescription: automatic animation of layer property changes
tags: appkit, implicit, layer, automatic, calayer
---

## Leverage Implicit Layer Animations

CALayer properties animate implicitly by default. When you change a property, Core Animation automatically creates a 0.25s animation. Understanding this behavior helps control when animations occur.

**Implicit animation in action:**

```swift
import AppKit

class ImplicitAnimationView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    func changeColor() {
        // This automatically animates over 0.25s
        layer?.backgroundColor = NSColor.red.cgColor
    }

    func moveLayer() {
        // Position change also animates implicitly
        layer?.position = CGPoint(x: 200, y: 200)
    }
}
```

**Customizing implicit animation timing:**

```swift
func customImplicitTiming() {
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.5)
    CATransaction.setAnimationTimingFunction(
        CAMediaTimingFunction(name: .easeInEaseOut)
    )

    // These changes use custom timing
    layer?.opacity = 0.5
    layer?.transform = CATransform3DMakeScale(1.2, 1.2, 1)

    CATransaction.commit()
}
```

**Disabling implicit animations:**

```swift
func instantChange() {
    // Method 1: CATransaction
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    layer?.position = newPosition
    CATransaction.commit()

    // Method 2: Set actions dictionary
    layer?.actions = ["position": NSNull()]
    layer?.position = newPosition

    // Method 3: NSAnimationContext with 0 duration
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0
        self.animator().frame = newFrame
    }
}
```

**Custom actions for specific properties:**

```swift
class CustomActionsLayer: CALayer {
    override class func defaultAction(forKey event: String) -> CAAction? {
        if event == "backgroundColor" {
            // Custom animation for background color
            let animation = CABasicAnimation(keyPath: event)
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            return animation
        }

        // Disable animation for position
        if event == "position" {
            return NSNull()
        }

        // Use default for others
        return super.defaultAction(forKey: event)
    }
}
```

**Animatable properties:**

```swift
// Properties that animate implicitly:
layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
layer?.backgroundColor = color.cgColor
layer?.borderColor = color.cgColor
layer?.borderWidth = 2.0
layer?.bounds = newBounds
layer?.cornerRadius = 12
layer?.opacity = 0.8
layer?.position = newPosition
layer?.shadowColor = color.cgColor
layer?.shadowOffset = CGSize(width: 0, height: 2)
layer?.shadowOpacity = 0.3
layer?.shadowRadius = 8
layer?.transform = CATransform3DIdentity
layer?.zPosition = 100
```

**Combining implicit and explicit:**

```swift
func mixedAnimation() {
    // Implicit animation for opacity
    layer?.opacity = 0.5

    // Explicit animation for position (overrides implicit)
    let positionAnimation = CABasicAnimation(keyPath: "position")
    positionAnimation.toValue = NSValue(point: CGPoint(x: 200, y: 100))
    positionAnimation.duration = 0.8
    positionAnimation.timingFunction = CAMediaTimingFunction(
        controlPoints: 0.32, 0.72, 0, 1
    )
    layer?.add(positionAnimation, forKey: "customPosition")
    layer?.position = CGPoint(x: 200, y: 100)
}
```

**Checking current implicit animation:**

```swift
func debugImplicitAnimation() {
    // See what animation would be used
    if let action = layer?.action(forKey: "opacity") {
        print("Action for opacity: \(action)")
    }

    // Check if animations are disabled
    print("Actions disabled: \(CATransaction.disableActions())")
}
```

Reference: [Implicit Animations](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatingLayers/AnimatingLayers.html)
