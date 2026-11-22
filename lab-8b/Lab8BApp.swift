//
//  Lab8BApp.swift
//  lab-8b
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 8B: @main App Entry Point and WindowGroup Inspection (R1)
//

import SwiftUI

// R1 & R5: The App protocol defines the application entry point and root scene lifecycle.
// Unlike an individual View (which defines a single visual node in the UI hierarchy),
// an App manages process launch, window scenes, deep links, and shared environment state.
@main
struct Lab8BApp: App {

    // The body property of an App returns a Scene (WindowGroup), not a View.
    var body: some Scene {
        WindowGroup {
            // Root View inside the primary window scene
            CourseListView()
        }
    }
}
