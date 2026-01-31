---
title: Use SF Symbol Effects
impact: MEDIUM
impactDescription: built-in symbol animations for common patterns
tags: polish, sf-symbols, symbol-effect, ios17, icons
---

## Use SF Symbol Effects

iOS 17 introduced built-in animation effects for SF Symbols. These provide consistent, Apple-designed animations for common interaction patterns without custom animation code.

**Basic symbol effects:**

```swift
struct SymbolEffectExamples: View {
    @State private var isBouncing = false
    @State private var isPulsing = false
    @State private var isRotating = false

    var body: some View {
        VStack(spacing: 40) {
            // Bounce effect
            Image(systemName: "bell.fill")
                .font(.largeTitle)
                .symbolEffect(.bounce, value: isBouncing)
                .onTapGesture { isBouncing.toggle() }

            // Pulse effect
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .symbolEffect(.pulse, isActive: isPulsing)
                .onTapGesture { isPulsing.toggle() }

            // Variable color
            Image(systemName: "wifi")
                .font(.largeTitle)
                .symbolEffect(.variableColor.iterative, isActive: isRotating)
                .onTapGesture { isRotating.toggle() }
        }
    }
}
```

**Replace effect for state changes:**

```swift
struct ReplaceEffect: View {
    @State private var isPlaying = false

    var body: some View {
        Button {
            isPlaying.toggle()
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}
```

**Effect options:**

```swift
struct EffectOptions: View {
    @State private var trigger = false

    var body: some View {
        VStack(spacing: 30) {
            // Bounce options
            Image(systemName: "star.fill")
                .symbolEffect(.bounce.up, value: trigger)

            Image(systemName: "star.fill")
                .symbolEffect(.bounce.down, value: trigger)

            // Pulse options
            Image(systemName: "circle.fill")
                .symbolEffect(.pulse.byLayer, isActive: trigger)

            // Scale effect
            Image(systemName: "heart.fill")
                .symbolEffect(.scale.up, isActive: trigger)

            // Appear/Disappear
            Image(systemName: "checkmark")
                .symbolEffect(.appear, isActive: trigger)
        }
        .font(.largeTitle)
        .onTapGesture { trigger.toggle() }
    }
}
```

**Replace with direction:**

```swift
struct DirectionalReplace: View {
    @State private var currentIcon = "house"
    let icons = ["house", "gear", "person", "bell"]
    @State private var iconIndex = 0

    var body: some View {
        Button {
            iconIndex = (iconIndex + 1) % icons.count
        } label: {
            Image(systemName: icons[iconIndex])
                .font(.system(size: 50))
                .contentTransition(.symbolEffect(.replace.downUp))
        }
    }
}
```

**Continuous effects:**

```swift
struct ContinuousEffects: View {
    var body: some View {
        VStack(spacing: 30) {
            // Continuous pulse
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.largeTitle)
                .symbolEffect(.pulse.byLayer, options: .repeating)

            // Variable color animation
            Image(systemName: "waveform.path")
                .font(.largeTitle)
                .symbolEffect(.variableColor.iterative.reversing, options: .repeating)

            // Breathing effect
            Image(systemName: "lungs.fill")
                .font(.largeTitle)
                .symbolEffect(.breathe, options: .repeating)
        }
    }
}
```

**Combining with other animations:**

```swift
struct CombinedSymbolAnimation: View {
    @State private var isActive = false

    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 50))
            .foregroundStyle(isActive ? .yellow : .gray)
            .symbolEffect(.bounce, value: isActive)
            .scaleEffect(isActive ? 1.2 : 1.0)
            .animation(.spring(duration: 0.3), value: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}
```

**Available effects (iOS 17+):**
- `.bounce` - Quick bounce up or down
- `.pulse` - Subtle pulsing glow
- `.variableColor` - Animate multi-color symbols
- `.scale` - Scale up or down
- `.appear` / `.disappear` - Fade in/out
- `.replace` - Morph between symbols
- `.breathe` - Gentle breathing effect
- `.rotate` - Rotation animation
- `.wiggle` - Shake/wiggle effect

Reference: [SF Symbol Effects](https://developer.apple.com/documentation/symbols/symbol-effects)
