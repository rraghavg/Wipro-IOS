//
//  CourseStore.swift
//  lab-8c
//
//  Created by Raghav Gupta
//  R2: Observable model managing shared course catalog and synchronized favourite state
//  Extension: Local persistence using UserDefaults
//

import Foundation
import Combine

class CourseStore: ObservableObject {

    // R2: Published properties trigger view updates across all listening views
    @Published var courses: [Course] = Course.defaultCourses
    @Published var favouriteCourseIDs: Set<String> = []

    // UserDefaults key for local persistence (Extension)
    private let favouritesKey = "SavedFavouriteCourseIDs"

    init() {
        loadPersistedFavourites()
    }

    // MARK: - Favourite Actions (R4)

    func isFavourite(course: Course) -> Bool {
        return favouriteCourseIDs.contains(course.id)
    }

    func toggleFavourite(course: Course) {
        if favouriteCourseIDs.contains(course.id) {
            favouriteCourseIDs.remove(course.id)
        } else {
            favouriteCourseIDs.insert(course.id)
        }
        persistFavourites()
    }

    func clearAllFavourites() {
        favouriteCourseIDs.removeAll()
        persistFavourites()
    }

    // MARK: - Extension: Persistence via UserDefaults

    private func persistFavourites() {
        let array = Array(favouriteCourseIDs)
        UserDefaults.standard.set(array, forKey: favouritesKey)
    }

    private func loadPersistedFavourites() {
        if let saved = UserDefaults.standard.stringArray(forKey: favouritesKey) {
            self.favouriteCourseIDs = Set(saved)
        }
    }
}
