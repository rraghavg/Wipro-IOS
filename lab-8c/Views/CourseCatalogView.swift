//
//  CourseCatalogView.swift
//  lab-8c
//
//  Created by Raghav Gupta
//  R1, R2, R3, R4: Catalog screen demonstrating @State (local) vs @StateObject / @Published (shared)
//

import SwiftUI

struct CourseCatalogView: View {
    // R2: Shared state container owned by the root view
    @StateObject private var store = CourseStore()

    // R1: Local view state (UI-only concerns, never shared outside this view)
    @State private var searchText: String = ""
    @State private var showFavouritesOnly: Bool = false

    // Filtered courses based on both local search and shared favourite status
    var displayedCourses: [Course] {
        store.courses.filter { course in
            let matchesSearch = searchText.isEmpty ||
                course.title.localizedCaseInsensitiveContains(searchText) ||
                course.category.localizedCaseInsensitiveContains(searchText)

            let matchesFavourite = !showFavouritesOnly || store.isFavourite(course: course)
            return matchesSearch && matchesFavourite
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Section 1: Local State Controls (R1)
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        // Favourite Toggle Filter (Local @State)
                        Toggle(isOn: $showFavouritesOnly) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("Show Favourites Only")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }

                        // Status subtitle
                        HStack {
                            Text("Total Favourites: \(store.favouriteCourseIDs.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            if !store.favouriteCourseIDs.isEmpty {
                                Button("Clear All") {
                                    store.clearAllFavourites()
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                } header: {
                    Text("Filter & State Controls")
                }

                // Section 2: Course List
                Section("Courses (\(displayedCourses.count))") {
                    if displayedCourses.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: showFavouritesOnly ? "heart.slash" : "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text(showFavouritesOnly ? "No favourite courses saved yet." : "No matching courses found.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    } else {
                        ForEach(displayedCourses) { course in
                            NavigationLink(destination: CourseDetailView(course: course, store: store)) {
                                courseRow(course: course)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search courses (@State)")
            .navigationTitle("State Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("\(store.favouriteCourseIDs.count)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Extracted Row Component

    private func courseRow(course: Course) -> some View {
        HStack(spacing: 12) {
            Image(systemName: course.iconName)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 3) {
                Text(course.title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(course.category)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }

            Spacer()

            // R3: Pass binding to child toggle button directly inside row
            FavouriteToggleButton(
                isFavourite: Binding(
                    get: { store.isFavourite(course: course) },
                    set: { _ in store.toggleFavourite(course: course) }
                )
            )
        }
        .padding(.vertical, 4)
    }
}

// MARK: - SwiftUI Preview
struct CourseCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CourseCatalogView()
    }
}

