---
title: Use Core Animation Layers
impact: LOW-MEDIUM
impactDescription: CALayer provides advanced animation capabilities
tags: appkit, core-animation, calayer, macos, advanced
---

## Use Core Animation Layers

Core Animation's CALayer provides powerful animation capabilities beyond what `animator()` offers. Use it for complex animations, custom timing, and keyframe sequences.

**Adding explicit layer animations:**

```swift
import AppKit
import QuartzCore

class LayerAnimationView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    func animateWithCABasicAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.5
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        // Apply animation
        layer?.add(animation, forKey: "fadeAnimation")

        // Set final value (animation is additive by default)
        layer?.opacity = 0.5
    }
}
```

**Spring animation with CASpringAnimation:**

```swift
func springAnimation() {
    let spring = CASpringAnimation(keyPath: "transform.scale")
    spring.fromValue = 1.0
    spring.toValue = 1.2
    spring.damping = 10
    spring.stiffness = 100
    spring.mass = 1
    spring.initialVelocity = 0

    // Duration is calculated from physics
    spring.duration = spring.settlingDuration

    layer?.add(spring, forKey: "springScale")
    layer?.transform = CATransform3DMakeScale(1.2, 1.2, 1)
}
```

**Keyframe animation:**

```swift
func keyframeAnimation() {
    let keyframe = CAKeyframeAnimation(keyPath: "position")

    // Define the path
    keyframe.values = [
        NSValue(point: NSPoint(x: 0, y: 0)),
        NSValue(point: NSPoint(x: 100, y: 50)),
        NSValue(point: NSPoint(x: 200, y: 0)),
        NSValue(point: NSPoint(x: 200, y: 100))
    ]

    // Timing for each keyframe
    keyframe.keyTimes = [0, 0.3, 0.6, 1.0]

    keyframe.duration = 1.0
    keyframe.timingFunctions = [
        CAMediaTimingFunction(name: .easeOut),
        CAMediaTimingFunction(name: .easeInEaseOut),
        CAMediaTimingFunction(name: .easeIn)
    ]

    layer?.add(keyframe, forKey: "pathAnimation")
}
```

**Animation groups:**

```swift
func groupedAnimation() {
    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.fromValue = 1.0
    fadeOut.toValue = 0.0

    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 1.0
    scaleDown.toValue = 0.8

    let group = CAAnimationGroup()
    group.animations = [fadeOut, scaleDown]
    group.duration = 0.3
    group.timingFunction = CAMediaTimingFunction(name: .easeIn)

    layer?.add(group, forKey: "dismissAnimation")

    // Set final values
    layer?.opacity = 0
    layer?.transform = CATransform3DMakeScale(0.8, 0.8, 1)
}
```

**Animation with completion:**

```swift
func animateWithCompletion(completion: @escaping () -> Void) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    let animation = CABasicAnimation(keyPath: "opacity")
    animation.toValue = 0
    animation.duration = 0.3
    layer?.add(animation, forKey: "fade")
    layer?.opacity = 0

    CATransaction.commit()
}
```

**3D transforms:**

```swift
func flip3D() {
    var perspective = CATransform3DIdentity
    perspective.m34 = -1.0 / 500.0 // Perspective

    let rotation = CABasicAnimation(keyPath: "transform")
    rotation.toValue = NSValue(caTransform3D:
        CATransform3DRotate(perspective, .pi, 0, 1, 0)
    )
    rotation.duration = 0.5
    rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

    layer?.add(rotation, forKey: "flip")
}
```

**Removing/pausing animations:**

```swift
// Remove specific animation
layer?.removeAnimation(forKey: "fadeAnimation")

// Remove all animations
layer?.removeAllAnimations()

// Pause animations
func pauseAnimations() {
    let pausedTime = layer?.convertTime(CACurrentMediaTime(), from: nil) ?? 0
    layer?.speed = 0
    layer?.timeOffset = pausedTime
}

// Resume animations
func resumeAnimations() {
    let pausedTime = layer?.timeOffset ?? 0
    layer?.speed = 1
    layer?.timeOffset = 0
    layer?.beginTime = 0
    let timeSincePause = layer?.convertTime(CACurrentMediaTime(), from: nil) ?? 0 - pausedTime
    layer?.beginTime = timeSincePause
}
```

Reference: [Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/)
