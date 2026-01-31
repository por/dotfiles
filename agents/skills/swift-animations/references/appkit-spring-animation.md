---
title: Create Spring Animations in AppKit
impact: LOW-MEDIUM
impactDescription: physics-based springs for natural AppKit motion
tags: appkit, spring, physics, caspring, macos
---

## Create Spring Animations in AppKit

CASpringAnimation provides physics-based spring animations in AppKit. Configure mass, stiffness, and damping for natural, interruptible motion.

**Basic spring animation:**

```swift
import AppKit
import QuartzCore

class SpringAnimationView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    func springScale() {
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.fromValue = 1.0
        spring.toValue = 1.2

        // Physics parameters
        spring.mass = 1.0
        spring.stiffness = 100.0
        spring.damping = 10.0
        spring.initialVelocity = 0.0

        // Duration is calculated from physics
        spring.duration = spring.settlingDuration

        layer?.add(spring, forKey: "springScale")

        // Set final value
        layer?.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
    }
}
```

**Spring presets:**

```swift
extension CASpringAnimation {
    // Snappy spring (quick, minimal bounce)
    static func snappy(keyPath: String) -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: keyPath)
        spring.mass = 1.0
        spring.stiffness = 300.0
        spring.damping = 20.0
        spring.duration = spring.settlingDuration
        return spring
    }

    // Bouncy spring (playful)
    static func bouncy(keyPath: String) -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: keyPath)
        spring.mass = 1.0
        spring.stiffness = 150.0
        spring.damping = 8.0
        spring.duration = spring.settlingDuration
        return spring
    }

    // Smooth spring (no overshoot)
    static func smooth(keyPath: String) -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: keyPath)
        spring.mass = 1.0
        spring.stiffness = 200.0
        spring.damping = 28.0 // Critically damped
        spring.duration = spring.settlingDuration
        return spring
    }
}

// Usage
func animateWithPreset() {
    let spring = CASpringAnimation.bouncy(keyPath: "position")
    spring.toValue = NSValue(point: CGPoint(x: 200, y: 100))

    layer?.add(spring, forKey: "springPosition")
    layer?.position = CGPoint(x: 200, y: 100)
}
```

**Spring with initial velocity:**

```swift
func springWithVelocity(velocity: CGFloat) {
    let spring = CASpringAnimation(keyPath: "position.x")
    spring.fromValue = layer?.position.x ?? 0
    spring.toValue = 200

    spring.mass = 1.0
    spring.stiffness = 100.0
    spring.damping = 10.0
    spring.initialVelocity = velocity // Carry momentum into animation

    spring.duration = spring.settlingDuration

    layer?.add(spring, forKey: "springX")
    layer?.position.x = 200
}
```

**Multiple properties with spring:**

```swift
func multiPropertySpring() {
    // Scale spring
    let scaleSpring = CASpringAnimation(keyPath: "transform.scale")
    scaleSpring.toValue = 1.1
    scaleSpring.mass = 1.0
    scaleSpring.stiffness = 150.0
    scaleSpring.damping = 10.0
    scaleSpring.duration = scaleSpring.settlingDuration

    // Position spring (same physics for consistency)
    let positionSpring = CASpringAnimation(keyPath: "position")
    positionSpring.toValue = NSValue(point: CGPoint(x: 200, y: 100))
    positionSpring.mass = 1.0
    positionSpring.stiffness = 150.0
    positionSpring.damping = 10.0
    positionSpring.duration = positionSpring.settlingDuration

    // Group them
    let group = CAAnimationGroup()
    group.animations = [scaleSpring, positionSpring]
    group.duration = max(scaleSpring.settlingDuration, positionSpring.settlingDuration)

    layer?.add(group, forKey: "multiSpring")

    // Set final values
    layer?.transform = CATransform3DMakeScale(1.1, 1.1, 1)
    layer?.position = CGPoint(x: 200, y: 100)
}
```

**Converting SwiftUI spring parameters:**

```swift
extension CASpringAnimation {
    // Convert SwiftUI-style response/dampingFraction to Core Animation parameters
    static func fromSwiftUI(
        keyPath: String,
        response: Double,
        dampingFraction: Double
    ) -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: keyPath)

        // Approximate conversion (not exact but close)
        let angularFrequency = 2 * .pi / response
        spring.stiffness = CGFloat(angularFrequency * angularFrequency)
        spring.damping = CGFloat(4 * .pi * dampingFraction / response)
        spring.mass = 1.0

        spring.duration = spring.settlingDuration
        return spring
    }
}

// Usage
let spring = CASpringAnimation.fromSwiftUI(
    keyPath: "position",
    response: 0.3,
    dampingFraction: 0.7
)
```

**Spring parameter guide:**
| Feel | Stiffness | Damping | Mass |
|------|-----------|---------|------|
| Snappy | 300 | 20 | 1 |
| Default | 100 | 10 | 1 |
| Bouncy | 150 | 8 | 1 |
| Heavy | 100 | 10 | 2 |
| Light | 100 | 10 | 0.5 |

Reference: [CASpringAnimation](https://developer.apple.com/documentation/quartzcore/caspringanimation)
