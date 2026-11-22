//
//  Course.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 8A: Course data model with sample catalog data
//

import Foundation

enum CourseCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case swiftUI = "SwiftUI"
    case uikit = "UIKit"
    case swift = "Swift"
    case architecture = "Architecture"

    var id: String { rawValue }
}

enum CourseLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct Course: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let category: CourseCategory
    let level: CourseLevel
    let durationHours: Int
    let instructor: String
    let summary: String
    let topics: [String]
    let iconName: String

    init(id: UUID = UUID(),
         title: String,
         subtitle: String,
         category: CourseCategory,
         level: CourseLevel,
         durationHours: Int,
         instructor: String,
         summary: String,
         topics: [String],
         iconName: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.level = level
        self.durationHours = durationHours
        self.instructor = instructor
        self.summary = summary
        self.topics = topics
        self.iconName = iconName
    }

    static let sampleCourses: [Course] = [
        Course(
            title: "SwiftUI Fundamentals",
            subtitle: "Declarative UI layout & component architecture",
            category: .swiftUI,
            level: .beginner,
            durationHours: 18,
            instructor: "Raghav Gupta",
            summary: "Learn the core declarative primitives of SwiftUI: stacks, lists, scroll views, state binding, and custom subviews.",
            topics: ["View Layout (VStack, HStack, ZStack)", "State & Binding", "NavigationStack", "Declarative Forms"],
            iconName: "square.stack.3d.up.fill"
        ),
        Course(
            title: "UIKit Views & Auto Layout",
            subtitle: "Imperative view hierarchy and constraint solver",
            category: .uikit,
            level: .intermediate,
            durationHours: 15,
            instructor: "Raghav Gupta",
            summary: "Master manual layout with NSLayoutConstraint, intrinsic content size, priority resolution, and scroll view inset handling.",
            topics: ["Auto Layout Anchors", "Content Hugging & Compression", "Custom UITableViewCell", "Dynamic Type"],
            iconName: "rectangle.3.group.fill"
        ),
        Course(
            title: "Swift Concurrency & Networking",
            subtitle: "URLSession, async/await, and Codable pipelines",
            category: .swift,
            level: .advanced,
            durationHours: 12,
            instructor: "Raghav Gupta",
            summary: "Explore asynchronous programming in modern Swift: coroutines, actor isolation, cooperative cancellation, and JSON decoding.",
            topics: ["async / await", "Task & Task Groups", "JSONDecoder & Codable", "@MainActor Isolation"],
            iconName: "network"
        ),
        Course(
            title: "iOS Architecture Patterns",
            subtitle: "MVC, MVVM, and clean separation of concerns",
            category: .architecture,
            level: .intermediate,
            durationHours: 14,
            instructor: "Raghav Gupta",
            summary: "Structure maintainable mobile applications by extracting presentation logic into isolated, testable ViewModels.",
            topics: ["MVC vs MVVM", "Unit Testing ViewModels", "Data Binding Patterns", "Dependency Injection"],
            iconName: "arrow.triangle.branch"
        ),
        Course(
            title: "SwiftUI Animations & Gestures",
            subtitle: "Fluid transitions, drag gestures, and matched geometry",
            category: .swiftUI,
            level: .advanced,
            durationHours: 10,
            instructor: "Raghav Gupta",
            summary: "Bring interfaces to life using implicit animations, spring physics, drag gestures, and interactive transitions.",
            topics: ["withAnimation", "Spring Physics", "DragGesture", "matchedGeometryEffect"],
            iconName: "sparkles"
        )
    ]
}
