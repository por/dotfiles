# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Timing Curves & Easing (ease)

**Impact:** CRITICAL
**Description:** Easing is the most important part of any animation—it can make a bad animation feel great and vice versa. SwiftUI provides `.easeOut`, `.easeIn`, `.easeInOut`, `.linear`, and highly customizable `.spring()` and `.timingCurve()` options.

## 2. Duration & Timing (timing)

**Impact:** CRITICAL
**Description:** Animations over 300ms feel slow and disconnected from user actions. Duration directly affects perceived performance and interface responsiveness. SwiftUI's default spring animations are generally well-tuned but explicit durations matter for non-spring animations.

## 3. Animation Properties (props)

**Impact:** HIGH
**Description:** SwiftUI animates view modifiers efficiently, but some properties are more performant than others. Prefer animating `opacity`, `scaleEffect`, `rotationEffect`, and `offset` over properties that trigger layout recalculation.

## 4. Transforms & Effects (transform)

**Impact:** HIGH
**Description:** SwiftUI transforms via `scaleEffect`, `rotationEffect`, `offset`, and `rotation3DEffect` are the foundation of most animations. Proper anchor points and transform ordering defines animation quality.

## 5. Gesture & Interaction (gesture)

**Impact:** HIGH
**Description:** SwiftUI's gesture system with `DragGesture`, `TapGesture`, `LongPressGesture`, and `@GestureState` enables responsive, interruptible interactions. Proper gesture composition and state management creates fluid experiences.

## 6. Transitions & Navigation (transition)

**Impact:** MEDIUM-HIGH
**Description:** SwiftUI transitions (`.opacity`, `.scale`, `.slide`, `.asymmetric`) control how views enter and exit the hierarchy. `matchedGeometryEffect` enables shared element transitions. iOS 17+ brings `NavigationTransition` for custom navigation animations.

## 7. Scroll & Parallax (scroll)

**Impact:** MEDIUM
**Description:** Scroll-linked animations using `GeometryReader`, `PreferenceKey`, and iOS 17+ `scrollTransition` create engaging parallax and reveal effects. Proper implementation maintains 60fps performance.

## 8. Strategic Animation (strategy)

**Impact:** MEDIUM
**Description:** Knowing when NOT to animate is as important as knowing how. Over-animation and animating high-frequency actions destroys user experience. Animation should serve purpose, hierarchy, and spatial continuity.

## 9. Accessibility & Polish (polish)

**Impact:** MEDIUM
**Description:** Respecting `accessibilityReduceMotion`, using iOS 17+ `PhaseAnimator` and `KeyframeAnimator` for complex sequences, pairing animations with haptics, and ensuring interruptibility elevate good animations to great ones.

## 10. AppKit Specific (appkit)

**Impact:** LOW-MEDIUM
**Description:** macOS AppKit animations via `NSAnimationContext`, Core Animation layers, and the animator proxy provide platform-specific capabilities. These rules cover macOS-specific patterns not available in SwiftUI.
