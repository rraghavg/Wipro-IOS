//
//  CourseListView.swift
//  lab-8b
//
//  Created by Raghav Gupta
//  R2, R3, R4: List view with NavigationStack, type-safe navigationDestination,
//  toolbar items, and model passing.
//

import SwiftUI

struct CourseListView: View {
    @State private var courses: [Course] = Course.samples
    @State private var navigationPath = NavigationPath()
    @State private var showInfoSheet: Bool = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                // Section 1: Intro info card
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NavigationStack Template")
                            .font(.headline)
                        Text("Demonstrates predictable navigation, typed NavigationLink destinations, toolbar actions, and model passing.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                // Section 2: Course List
                Section("Available Courses (\(courses.count))") {
                    ForEach(courses) { course in
                        // R2 & R3: NavigationLink passing selected Course model
                        NavigationLink(value: course) {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.12))
                                        .frame(width: 42, height: 42)

                                    Image(systemName: course.iconName)
                                        .foregroundColor(.blue)
                                        .font(.subheadline)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(course.title)
                                        .font(.body)
                                        .fontWeight(.semibold)

                                    HStack(spacing: 8) {
                                        Text(course.category)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)

                                        Text("•")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)

                                        Text(course.duration)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                // Section 3: Extension Route (Search & Deep Link)
                Section("Extension") {
                    NavigationLink(value: "search_screen") {
                        Label("Open Full Catalog Search", systemImage: "magnifyingglass")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Courses")
            // Type-safe Navigation Destinations (R2 & R3)
            .navigationDestination(for: Course.self) { course in
                CourseDetailView(course: course)
            }
            .navigationDestination(for: String.self) { route in
                if route == "search_screen" {
                    CourseSearchRouteView(allCourses: courses)
                }
            }
            // R4: Toolbar Actions
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigationPath.append("search_screen")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                NavigationInfoSheet()
            }
        }
    }
}

// Extracted Info Sheet
struct NavigationInfoSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("About NavigationStack in SwiftUI")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("In iOS 16+, Apple introduced NavigationStack to replace NavigationView. It allows data-driven navigation by binding a `NavigationPath` collection, making deep linking and programmatic push/pop reliable.")
                    .font(.body)
                    .foregroundColor(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Concepts Demonstrated:")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("• NavigationLink(value:) binds data to destinations")
                    Text("• navigationDestination(for:) handles the route cleanly")
                    Text("• ToolbarItem places actions in standard nav bar positions")
                    Text("• Programmatic back navigation via @Environment(\\.dismiss)")
                }
                .font(.footnote)
                .foregroundColor(.secondary)

                Spacer()
            }
            .padding(20)
            .navigationTitle("Navigation Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - SwiftUI Preview
struct CourseListView_Previews: PreviewProvider {
    static var previews: some View {
        CourseListView()
    }
}

