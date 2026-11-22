//
//  ProjectItem.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//

import Foundation

enum ProjectCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case swiftUI = "SwiftUI"
    case uikit = "UIKit"
    case networking = "Networking"
    case architecture = "Architecture"

    var id: String { rawValue }
}

struct ProjectItem: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let category: ProjectCategory
    let duration: String
    let difficulty: String
    let iconName: String
    let description: String
    var isFavourite: Bool

    static let sampleProjects: [ProjectItem] = [
        ProjectItem(
            id: "M4-01",
            title: "Course Catalog & Favourites",
            subtitle: "Declarative NavigationStack & Two-Way Sync",
            category: .swiftUI,
            duration: "4 Hours",
            difficulty: "Intermediate",
            iconName: "square.grid.2x2",
            description: "Master modern SwiftUI NavigationStack, custom state stores, and reactive favourites synchronization across multiple screens.",
            isFavourite: true
        ),
        ProjectItem(
            id: "M4-02",
            title: "Auto Layout Profile Form",
            subtitle: "Responsive Constraints & Text Fields",
            category: .uikit,
            duration: "6 Hours",
            difficulty: "Intermediate",
            iconName: "person.crop.rectangle",
            description: "Build robust UIKit forms using NSLayoutConstraint, keyboard notifications, and inline error styling.",
            isFavourite: false
        ),
        ProjectItem(
            id: "M4-03",
            title: "Async/Await REST Directory",
            subtitle: "URLSession, Codable & Error Enums",
            category: .networking,
            duration: "8 Hours",
            difficulty: "Advanced",
            iconName: "network",
            description: "Perform asynchronous network requests using modern Swift concurrency, decoding JSON into typed models with custom error recovery.",
            isFavourite: true
        ),
        ProjectItem(
            id: "M4-04",
            title: "MVVM Concurrency Task Aggregator",
            subtitle: "Task Groups, MainActor & Combine",
            category: .architecture,
            duration: "5 Hours",
            difficulty: "Advanced",
            iconName: "cpu",
            description: "Deconstruct tight UIKit controllers into clean MVVM architecture, fanning out concurrent network calls with async let and task groups.",
            isFavourite: false
        ),
        ProjectItem(
            id: "M4-05",
            title: "Declarative Event Registration",
            subtitle: "Form, Sections, Pickers & Sheets",
            category: .swiftUI,
            duration: "3 Hours",
            difficulty: "Beginner",
            iconName: "list.clipboard",
            description: "Design accessible, declarative input forms with dynamic submission validation and modal review screens.",
            isFavourite: false
        )
    ]
}
