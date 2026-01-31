---
title: Use contentTransition for Text Changes
impact: MEDIUM
impactDescription: smooth text morphing without layout jump
tags: transition, content, text, numeric, morph
---

## Use contentTransition for Text Changes

`contentTransition` animates changes within a view's content, particularly useful for text and numeric values. It creates smooth morphing effects without triggering full view replacement.

**Numeric content transition:**

```swift
struct AnimatedCounter: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 64, weight: .bold))
                .contentTransition(.numericText())

            Button("Increment") {
                withAnimation(.spring(duration: 0.3)) {
                    count += 1
                }
            }
        }
    }
}
```

**Counting direction:**

```swift
// Count up animation
.contentTransition(.numericText(countsDown: false))

// Count down animation
.contentTransition(.numericText(countsDown: true))

// Automatic based on value change
.contentTransition(.numericText())
```

**Text interpolation:**

```swift
struct TextMorph: View {
    @State private var showAlternate = false
    let primary = "Hello"
    let alternate = "World"

    var body: some View {
        Text(showAlternate ? alternate : primary)
            .contentTransition(.interpolate)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showAlternate.toggle()
                }
            }
    }
}
```

**Symbol content transition:**

```swift
struct SymbolTransition: View {
    @State private var isPlaying = false

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                isPlaying.toggle()
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}
```

**Formatted values:**

```swift
struct PriceDisplay: View {
    @State private var price: Double = 99.99

    var body: some View {
        Text(price, format: .currency(code: "USD"))
            .font(.title)
            .contentTransition(.numericText())

        Slider(value: $price, in: 0...200)
            .onChange(of: price) { _, _ in
                // Animation applied via contentTransition
            }
    }
}
```

**Combining with other animations:**

```swift
struct ComplexTextTransition: View {
    @State private var value = 0

    var body: some View {
        Text("\(value)")
            .font(.system(size: 72, weight: .bold, design: .rounded))
            .foregroundStyle(value > 50 ? .green : .primary)
            .contentTransition(.numericText())
            .scaleEffect(value > 50 ? 1.1 : 1.0)
            .animation(.spring(duration: 0.3), value: value)
    }
}
```

**Date/Time display:**

```swift
struct TimeDisplay: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(currentTime, format: .dateTime.hour().minute().second())
            .font(.system(size: 48, design: .monospaced))
            .contentTransition(.numericText())
            .onReceive(timer) { time in
                withAnimation(.linear(duration: 0.2)) {
                    currentTime = time
                }
            }
    }
}
```

**When contentTransition works best:**
- Numeric values changing
- Short text strings changing
- SF Symbols changing
- When you want morphing rather than replacement

**When to use .id() instead:**
- Longer text changes
- When complete replacement animation is desired
- When content type changes significantly

Reference: [contentTransition](https://developer.apple.com/documentation/swiftui/view/contenttransition(_:))
