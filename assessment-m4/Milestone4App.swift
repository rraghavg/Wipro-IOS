//
//  Milestone4App.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Assessment Milestone 4: SwiftUI and Configuration
//

import SwiftUI

@main
struct Milestone4App: App {
    // Shared state container passed across tabs and detail views
    @StateObject private var store = ProjectStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                ProjectListView(store: store)
                    .tabItem {
                        Label("Projects", systemImage: "folder.fill")
                    }

                ProjectSubmissionFormView(store: store)
                    .tabItem {
                        Label("Submit", systemImage: "plus.circle.fill")
                    }

                ConfigurationAndVivaView()
                    .tabItem {
                        Label("Viva & Config", systemImage: "graduationcap.fill")
                    }
            }
        }
    }
}
