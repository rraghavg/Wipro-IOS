//
//  Course.swift
//  lab-8b
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 8B: Course model conforming to Identifiable and Hashable for NavigationStack
//

import Foundation

struct Course: Identifiable, Hashable {
    let id: UUID
    let title: String
    let category: String
    let duration: String
    let instructor: String
    let overview: String
    let syllabus: [String]
    let iconName: String

    init(id: UUID = UUID(),
         title: String,
         category: String,
         duration: String,
         instructor: String,
         overview: String,
         syllabus: [String],
         iconName: String) {
        self.id = id
        self.title = title
        self.category = category
        self.duration = duration
        self.instructor = instructor
        self.overview = overview
        self.syllabus = syllabus
        self.iconName = iconName
    }

    static let samples: [Course] = [
        Course(
            title: "SwiftUI NavigationStack Architecture",
            category: "SwiftUI",
            duration: "6 Hours",
            instructor: "Raghav Gupta",
            overview: "Deep dive into programmatic navigation paths, type-safe navigationDestination, deep-link handling, and toolbar customization in iOS 16+.",
            syllabus: ["NavigationStack vs NavigationView", "NavigationLink(value:)", "navigationDestination(for:)", "Custom Toolbar Actions"],
            iconName: "point.topleft.down.curvedto.point.filled.bottomright.up"
        ),
        Course(
            title: "Swift Concurrency & Async/Await",
            category: "Swift",
            duration: "8 Hours",
            instructor: "Raghav Gupta",
            overview: "Learn structured concurrency, Task hierarchies, cooperative cancellation, and thread-safe data flow using actors.",
            syllabus: ["async/await coroutines", "Task & Task.detached", "withThrowingTaskGroup", "@MainActor synchronization"],
            iconName: "bolt.horizontal.fill"
        ),
        Course(
            title: "UIKit Interoperability in SwiftUI",
            category: "UIKit",
            duration: "5 Hours",
            instructor: "Raghav Gupta",
            overview: "Bridge imperative UIKit views into declarative SwiftUI hierarchies using UIViewRepresentable and UIViewControllerRepresentable.",
            syllabus: ["UIViewRepresentable protocol", "makeUIView & updateUIView", "Coordinators for delegates", "Lifecycle bridging"],
            iconName: "arrow.triangle.swap"
        ),
        Course(
            title: "Combine Reactive Data Streams",
            category: "Architecture",
            duration: "7 Hours",
            instructor: "Raghav Gupta",
            overview: "Manage asynchronous event-driven pipelines using Publishers, Subscribers, Operators, and Combine-to-SwiftUI bindings.",
            syllabus: ["Publishers & Subscribers", "Subject types (Passthrough, CurrentValue)", "Transforming & filtering operators", "Integrating with @Published"],
            iconName: "waveform.path.ecg"
        )
    ]
}
