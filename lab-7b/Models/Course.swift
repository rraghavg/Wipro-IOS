//
//  Course.swift
//  lab-7b
//
//  Model representing a course passed from the list screen to the detail screen.
//

import Foundation

struct Course: Identifiable {
    let id: Int
    let title: String
    let instructor: String
    let duration: String
    let level: CourseLevel
    let category: String
    let description: String
    let syllabus: [String]
    let iconSystemName: String

    enum CourseLevel: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }

    // Classroom sample courses
    static let sampleCourses: [Course] = [
        Course(
            id: 1,
            title: "Swift Concurrency & Async/Await",
            instructor: "Raghav Gupta",
            duration: "4 Weeks",
            level: .intermediate,
            category: "iOS Development",
            description: "Master modern Swift structured concurrency, Tasks, Task Groups, Actors, and Sendable safety to write responsive apps.",
            syllabus: [
                "Understanding Async/Await & Cooperative Multitasking",
                "Working with Tasks and Cancellation checks",
                "Fan-out with Task Groups & Error handling",
                "Actor isolation & Sendable Concurrency Safety"
            ],
            iconSystemName: "arrow.triangle.swap"
        ),
        Course(
            id: 2,
            title: "UIKit Layout & View Hierarchy",
            instructor: "Priya Sharma",
            duration: "3 Weeks",
            level: .beginner,
            category: "iOS Development",
            description: "Deep dive into UIView lifecycle, UINavigationController, Auto Layout constraints, and debugging the view hierarchy.",
            syllabus: [
                "UIView containment and parent-child relations",
                "Auto Layout anchors and constraint priorities",
                "UINavigationController push/pop workflows",
                "Safe outlet unwrapping & defensive programming"
            ],
            iconSystemName: "rectangle.stack.fill"
        ),
        Course(
            id: 3,
            title: "REST Networking & Codable in Swift",
            instructor: "Dr. Vikram Sen",
            duration: "3 Weeks",
            level: .intermediate,
            category: "Backend & Network",
            description: "Learn to fetch JSON from remote endpoints safely using URLSession, decode with JSONDecoder, and handle error states.",
            syllabus: [
                "URLComponents and URLRequest headers",
                "Parsing JSON into Codable models safely",
                "Handling 404, 500, decoding errors, and offline modes",
                "Unit testing network services with mocked data"
            ],
            iconSystemName: "network"
        ),
        Course(
            id: 4,
            title: "Core Data & Local Persistence",
            instructor: "Ananya Iyer",
            duration: "5 Weeks",
            level: .advanced,
            category: "Data Architecture",
            description: "Architect offline-first iOS apps using Core Data persistence, NSFetchRequest optimization, and background sync.",
            syllabus: [
                "Data modeling and Entity relationships",
                "NSPersistentContainer and NSManagedObjectContext",
                "Batch operations and NSFetchedResultsController",
                "Handling thread confinement and context saving"
            ],
            iconSystemName: "cylinder.split.1x2.fill"
        ),
        Course(
            id: 5,
            title: "SwiftUI Declarative UI Patterns",
            instructor: "Karan Verma",
            duration: "4 Weeks",
            level: .beginner,
            category: "iOS Development",
            description: "Build reactive, animated iOS user interfaces with SwiftUI, @State, @Binding, and Observation framework.",
            syllabus: [
                "Declarative view composition and modifiers",
                "State management with @Observable and Environment",
                "Custom navigation stacks and animations",
                "Bridging UIKit with UIViewRepresentable"
            ],
            iconSystemName: "sparkles"
        )
    ]
}
