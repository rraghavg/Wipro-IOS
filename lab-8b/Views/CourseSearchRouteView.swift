//
//  CourseSearchRouteView.swift
//  lab-8b
//
//  Created by Raghav Gupta
//  Extension: Dedicated search & filter route navigable via NavigationStack path
//

import SwiftUI

struct CourseSearchRouteView: View {
    let allCourses: [Course]
    @State private var searchQuery: String = ""

    var searchResults: [Course] {
        if searchQuery.isEmpty {
            return allCourses
        }
        return allCourses.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.category.localizedCaseInsensitiveContains(searchQuery) ||
            $0.overview.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    var body: some View {
        List {
            if searchResults.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No results for '\(searchQuery)'")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .listRowBackground(Color.clear)
            } else {
                ForEach(searchResults) { course in
                    NavigationLink(value: course) {
                        HStack(spacing: 12) {
                            Image(systemName: course.iconName)
                                .font(.title3)
                                .foregroundColor(.blue)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(course.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                Text(course.category)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .searchable(text: $searchQuery, prompt: "Search title, category, or overview")
        .navigationTitle("Search Courses")
        .navigationBarTitleDisplayMode(.inline)
    }
}
