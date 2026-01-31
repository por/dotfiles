---
title: Enable Layer Backing for Performance
impact: LOW-MEDIUM
impactDescription: layer-backed views enable GPU acceleration
tags: appkit, layer-backed, performance, gpu, wantslayer
---

## Enable Layer Backing for Performance

By default, AppKit views are not layer-backed. Setting `wantsLayer = true` enables Core Animation backing, which improves animation performance and enables additional effects.

**Enabling layer backing:**

```swift
import AppKit

class AnimatableView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }

    private func setupLayer() {
        // Enable layer backing
        wantsLayer = true

        // Optional: configure layer properties
        layer?.backgroundColor = NSColor.blue.cgColor
        layer?.cornerRadius = 8
        layer?.masksToBounds = true
    }
}
```

**Layer-backed vs non-layer-backed:**

```swift
// WITHOUT layer backing: animations may be choppy
class NonLayerView: NSView {
    func animate() {
        // Uses display-based animation, can be slower
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.animator().alphaValue = 0.5
        }
    }
}

// WITH layer backing: smooth GPU-accelerated animations
class LayerBackedView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    func animate() {
        // Uses Core Animation, GPU-accelerated
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.animator().alphaValue = 0.5
        }
    }
}
```

**Layer hosting for custom layers:**

```swift
class CustomLayerView: NSView {
    private let customLayer = CAGradientLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        // Use layerContentsRedrawPolicy for hosting
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay

        // Configure custom layer
        customLayer.colors = [
            NSColor.blue.cgColor,
            NSColor.purple.cgColor
        ]
        customLayer.frame = bounds
        layer?.addSublayer(customLayer)
    }

    override func layout() {
        super.layout()
        customLayer.frame = bounds
    }
}
```

**Sublayer configuration:**

```swift
class ConfiguredLayerView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    override func makeBackingLayer() -> CALayer {
        // Customize the backing layer type
        let layer = CALayer()
        layer.backgroundColor = NSColor.windowBackgroundColor.cgColor
        layer.cornerRadius = 12
        layer.shadowColor = NSColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 8
        return layer
    }
}
```

**Performance considerations:**

```swift
class PerformantView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        wantsLayer = true

        // Rasterize complex content
        layer?.shouldRasterize = true
        layer?.rasterizationScale = NSScreen.main?.backingScaleFactor ?? 2.0

        // Disable actions for instant updates when needed
        layer?.actions = ["position": NSNull(), "bounds": NSNull()]
    }

    func instantUpdate() {
        // Bypass implicit animations
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer?.position = newPosition
        CATransaction.commit()
    }
}
```

**When to use layer backing:**
- Views with animations
- Views with shadows, corner radius, or borders
- Views that need GPU acceleration
- Complex view hierarchies

**When NOT to use layer backing:**
- Simple text views (can blur text)
- Views requiring precise drawing
- Memory-constrained situations

Reference: [Layer-Backed Views](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/SettingUpLayerObjects/SettingUpLayerObjects.html)
