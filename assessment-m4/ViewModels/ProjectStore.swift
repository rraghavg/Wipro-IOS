//
//  ProjectStore.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//  R2: Shared observable state store maintaining project list and synchronized favourites
//

import Foundation
import Combine

class ProjectStore: ObservableObject {
    // R2: Published list triggers UI re-renders across all observing views
    @Published var projects: [ProjectItem] = ProjectItem.sampleProjects

    // Filter properties
    @Published var selectedCategory: ProjectCategory = .all
    @Published var searchText: String = ""
    @Published var showFavouritesOnly: Bool = false

    // Computed filtered list
    var filteredProjects: [ProjectItem] {
        projects.filter { project in
            let matchesCategory = (selectedCategory == .all || project.category == selectedCategory)
            let matchesSearch = searchText.isEmpty ||
                project.title.localizedCaseInsensitiveContains(searchText) ||
                project.subtitle.localizedCaseInsensitiveContains(searchText)
            let matchesFav = !showFavouritesOnly || project.isFavourite

            return matchesCategory && matchesSearch && matchesFav
        }
    }

    var favouriteCount: Int {
        projects.filter { $0.isFavourite }.count
    }

    // MARK: - Favourite Toggling (R2)

    func toggleFavourite(for projectID: String) {
        if let index = projects.firstIndex(where: { $0.id == projectID }) {
            projects[index].isFavourite.toggle()
        }
    }

    func isFavourite(for projectID: String) -> Bool {
        projects.first(where: { $0.id == projectID })?.isFavourite ?? false
    }

    // MARK: - Project Addition (from Form Submission R3)

    func addProject(title: String, subtitle: String, category: ProjectCategory, duration: String, description: String) {
        let newProject = ProjectItem(
            id: "M4-\(String(format: "%02d", projects.count + 1))",
            title: title,
            subtitle: subtitle,
            category: category,
            duration: duration,
            difficulty: "Custom",
            iconName: "star.bubble",
            description: description,
            isFavourite: false
        )
        projects.insert(newProject, at: 0)
    }
}
