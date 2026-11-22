//
//  ConfigurationAndVivaView.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//  R4 & R5: Interactive Viva & Configuration Reference View
//

import SwiftUI

struct ConfigurationAndVivaView: View {
    var body: some View {
        NavigationStack {
            List {
                // Section 1: Configuration Concepts (R4)
                Section("1. Configuration & App Metadata (R4)") {
                    vivaCard(
                        title: "App Entry Point (@main)",
                        question: "How does the app entry point differ from an individual View?",
                        answer: "The App protocol marks the root execution entry point with the @main attribute. It declares a Scene (such as WindowGroup), which manages app lifecycle, window creation, and global state injection. In contrast, a View is a lightweight, immutable declarative description of a UI piece that gets drawn inside a Scene."
                    )

                    vivaCard(
                        title: "Bundle Identifier",
                        question: "What is the purpose of the Bundle Identifier (e.g. raghav.assessment-m4)?",
                        answer: "A reverse-DNS string uniquely identifying an app throughout the Apple ecosystem. It binds the binary to Apple Developer Team provisioning profiles, App Store Connect records, Keychain Access Groups, Push Notification sandboxes, and App Group storage containers."
                    )

                    vivaCard(
                        title: "Deployment Target",
                        question: "What does the Deployment Target govern?",
                        answer: "The minimum iOS version capable of installing and launching the app (e.g., iOS 17.0). Devices running an older iOS version are blocked by the App Store and SpringBoard. Features from newer SDKs require conditional availability checks using #available(iOS 18.0, *)."
                    )

                    vivaCard(
                        title: "Privacy Usage Descriptions",
                        question: "Why are Info.plist usage descriptions mandatory for sensitive APIs?",
                        answer: "Apple mandates human-readable strings (e.g., NSPhotoLibraryUsageDescription) displayed in system permission prompts. If an app attempts to call a protected API without its corresponding key in Info.plist, the operating system terminates the app immediately with a fatal SIGABRT crash."
                    )
                }

                // Section 2: SwiftUI Architecture Viva (R5)
                Section("2. SwiftUI Viva & State Comparison (R5)") {
                    vivaCard(
                        title: "@State vs @Binding",
                        question: "When do you use @State versus Binding?",
                        answer: "• @State is private, value-type storage allocated on the heap and owned exclusively by a single view. When @State changes, SwiftUI re-evaluates the view's body.\n• @Binding is a reference or two-way connection to state owned elsewhere (e.g., in a parent view or ObservableObject). It contains no data storage of its own; writing to a binding mutates the underlying owner's state."
                    )

                    vivaCard(
                        title: "Role of App vs View Protocols",
                        question: "What is the functional difference between App and View?",
                        answer: "• App represents the entire program container. Its `body` returns a Scene (`some Scene`), which coordinates OS windows, multi-window iPad support, and system events.\n• View represents visible user interface elements. Its `body` returns `some View`, which the SwiftUI layout engine arranges into renderable layout nodes."
                    )
                }
            }
            .navigationTitle("Configuration & Viva")
        }
    }

    private func vivaCard(title: String, question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)

            Text(question)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(answer)
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .padding(.vertical, 6)
    }
}
