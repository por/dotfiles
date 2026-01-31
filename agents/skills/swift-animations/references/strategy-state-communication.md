---
title: Animate State Changes Clearly
impact: MEDIUM
impactDescription: animation clarifies what changed and why
tags: strategy, state, communication, feedback, change
---

## Animate State Changes Clearly

Animation should help users understand state changes. When something changes, motion can show what happened, why it happened, and what the new state means.

**Loading to success transition:**

```swift
struct SubmitButton: View {
    enum State { case idle, loading, success, error }
    @State private var state: State = .idle

    var body: some View {
        Button(action: submit) {
            ZStack {
                // Idle state
                if state == .idle {
                    Text("Submit")
                        .transition(.opacity.combined(with: .scale))
                }

                // Loading state
                if state == .loading {
                    ProgressView()
                        .transition(.opacity.combined(with: .scale))
                }

                // Success state
                if state == .success {
                    Image(systemName: "checkmark")
                        .transition(.opacity.combined(with: .scale))
                }

                // Error state
                if state == .error {
                    Image(systemName: "xmark")
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .frame(width: 150, height: 44)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .animation(.spring(duration: 0.3), value: state)
    }

    var backgroundColor: Color {
        switch state {
        case .idle, .loading: return .blue
        case .success: return .green
        case .error: return .red
        }
    }

    func submit() {
        state = .loading
        // Simulate network
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            state = .success
        }
    }
}
```

**Toggle with state indication:**

```swift
struct AnimatedToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(isOn ? "Enabled" : "Disabled")
                .foregroundStyle(isOn ? .primary : .secondary)
                .contentTransition(.numericText())

            Spacer()

            Capsule()
                .fill(isOn ? .green : .gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(.white)
                        .padding(2)
                        .shadow(radius: 1)
                }
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isOn)
                .onTapGesture { isOn.toggle() }
        }
    }
}
```

**Selection state change:**

```swift
struct SelectableCards: View {
    @State private var selectedId: UUID?

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(items) { item in
                CardView(item: item, isSelected: selectedId == item.id)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.25)) {
                            selectedId = selectedId == item.id ? nil : item.id
                        }
                    }
            }
        }
    }
}

struct CardView: View {
    let item: Item
    let isSelected: Bool

    var body: some View {
        VStack {
            // Content
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .shadow(radius: isSelected ? 8 : 2)
    }
}
```

**Empty to content state:**

```swift
struct ContentListView: View {
    @State private var items: [Item] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else if items.isEmpty {
                EmptyStateView()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                List(items) { item in
                    ItemRow(item: item)
                        .transition(.slide.combined(with: .opacity))
                }
            }
        }
        .animation(.spring(duration: 0.3), value: isLoading)
        .animation(.spring(duration: 0.3), value: items.isEmpty)
    }
}
```

**Progress indication:**

```swift
struct DownloadProgress: View {
    @State private var progress: Double = 0

    var body: some View {
        VStack {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.2))

                    Capsule()
                        .fill(.blue)
                        .frame(width: geometry.size.width * progress)
                        .animation(.spring(response: 0.3), value: progress)
                }
            }
            .frame(height: 8)

            // Percentage with number transition
            Text("\(Int(progress * 100))%")
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.2), value: progress)
        }
    }
}
```

Reference: [Human Interface Guidelines - Feedback](https://developer.apple.com/design/human-interface-guidelines/feedback)
