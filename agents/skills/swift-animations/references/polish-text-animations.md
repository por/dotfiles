---
title: Animate Text with contentTransition
impact: MEDIUM
impactDescription: smooth text changes without jarring replacements
tags: polish, text, content-transition, numeric, interpolate
---

## Animate Text with contentTransition

Text changes can be animated smoothly using `contentTransition`. This creates professional-looking number counters, morphing text, and smooth label updates.

**Numeric text transition:**

```swift
struct AnimatedCounter: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .contentTransition(.numericText())

            HStack {
                Button("-") { count -= 1 }
                Button("+") { count += 1 }
            }
        }
        .animation(.spring(duration: 0.3), value: count)
    }
}
```

**Counting direction:**

```swift
struct DirectionalCounter: View {
    @State private var value = 50

    var body: some View {
        VStack {
            // Counts up
            Text("\(value)")
                .font(.largeTitle)
                .contentTransition(.numericText(countsDown: false))

            // Counts down
            Text("\(value)")
                .font(.largeTitle)
                .contentTransition(.numericText(countsDown: true))

            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: 0...100)
        }
        .animation(.spring(duration: 0.3), value: value)
    }
}
```

**Formatted values:**

```swift
struct FormattedTransitions: View {
    @State private var price: Double = 99.99
    @State private var percentage: Double = 0.5

    var body: some View {
        VStack(spacing: 20) {
            // Currency
            Text(price, format: .currency(code: "USD"))
                .font(.title)
                .contentTransition(.numericText())

            // Percentage
            Text(percentage, format: .percent)
                .font(.title)
                .contentTransition(.numericText())

            // Number with decimals
            Text(price, format: .number.precision(.fractionLength(2)))
                .font(.title)
                .contentTransition(.numericText())
        }
        .animation(.spring(duration: 0.3), value: price)
        .animation(.spring(duration: 0.3), value: percentage)
    }
}
```

**Text interpolation:**

```swift
struct InterpolatingText: View {
    @State private var showAlternate = false

    var body: some View {
        Text(showAlternate ? "Hello" : "World")
            .font(.largeTitle)
            .contentTransition(.interpolate)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showAlternate.toggle()
                }
            }
    }
}
```

**Timer display:**

```swift
struct TimerDisplay: View {
    @State private var seconds = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(timeString)
            .font(.system(size: 48, design: .monospaced))
            .contentTransition(.numericText())
            .animation(.spring(duration: 0.2), value: seconds)
            .onReceive(timer) { _ in
                seconds += 1
            }
    }

    var timeString: String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
```

**Score animation:**

```swift
struct ScoreDisplay: View {
    @State private var score = 0

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("Score:")
                    .font(.title2)

                Text("\(score)")
                    .font(.system(size: 48, weight: .bold))
                    .contentTransition(.numericText())
                    .foregroundStyle(score > 100 ? .green : .primary)
            }

            Button("Add Points") {
                withAnimation(.spring(duration: 0.3, bounce: 0.2)) {
                    score += Int.random(in: 10...50)
                }
            }
        }
    }
}
```

**Label state changes:**

```swift
struct StatusLabel: View {
    enum Status: String {
        case idle = "Ready"
        case loading = "Loading..."
        case success = "Complete!"
        case error = "Failed"
    }

    @State private var status: Status = .idle

    var body: some View {
        Text(status.rawValue)
            .font(.headline)
            .foregroundStyle(colorFor(status))
            .contentTransition(.interpolate)
            .animation(.easeInOut(duration: 0.25), value: status)
    }

    func colorFor(_ status: Status) -> Color {
        switch status {
        case .idle: return .secondary
        case .loading: return .blue
        case .success: return .green
        case .error: return .red
        }
    }
}
```

Reference: [contentTransition](https://developer.apple.com/documentation/swiftui/view/contenttransition(_:))
