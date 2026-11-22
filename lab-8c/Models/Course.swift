//
//  Course.swift
//  lab-8c
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 8C: Course model
//

import Foundation

struct Course: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let instructor: String
    let category: String
    let duration: String
    let description: String
    let iconName: String

    static let defaultCourses: [Course] = [
        Course(
            id: "ios-swiftui-state",
            title: "SwiftUI State & Data Flow",
            instructor: "Raghav Gupta",
            category: "SwiftUI",
            duration: "5 Hours",
            description: "Understand source of truth, @State, @Binding, @StateObject, ObservableObject, and how data changes trigger reactive body redraws.",
            iconName: "arrow.triangle.2.circlepath.circle.fill"
        ),
        Course(
            id: "ios-combine-reactive",
            title: "Reactive Programming with Combine",
            instructor: "Raghav Gupta",
            category: "Architecture",
            duration: "8 Hours",
            description: "Build robust reactive publishers, debounce search queries, transform streams, and bind directly to SwiftUI views.",
            iconName: "waveform.path.badge.plus"
        ),
        Course(
            id: "ios-uikit-autolayout",
            title: "Auto Layout & UIKit Engineering",
            instructor: "Raghav Gupta",
            category: "UIKit",
            duration: "7 Hours",
            description: "Constraint systems, layout engine passes, intrinsic sizes, and integrating imperative components into SwiftUI apps.",
            iconName: "rectangle.3.group.fill"
        ),
        Course(
            id: "ios-swift-concurrency",
            title: "Modern Swift Concurrency",
            instructor: "Raghav Gupta",
            category: "Swift",
            duration: "6 Hours",
            description: "Actors, async/await, Task hierarchies, cooperative thread pools, and @MainActor guarantees for UI safety.",
            iconName: "bolt.shield.fill"
        ),
        Course(
            id: "ios-core-data-persistence",
            title: "Local Persistence & Cache",
            instructor: "Raghav Gupta",
            category: "Storage",
            duration: "4 Hours",
            description: "Persisting user preferences, caching network responses, and managing local storage using UserDefaults and SwiftData.",
            iconName: "cylinder.split.1x2.fill"
        )
    ]
}
