//
//  CourseDetailView.swift
//  lab-8c
//
//  Created by Raghav Gupta
//  R4: Detail view observing shared CourseStore and passing binding to FavouriteToggleButton
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    // R2 & R4: Observes shared store so state changes reflect reactively
    @ObservedObject var store: CourseStore

    // Helper binding created from the store for this specific course (R3)
    private var isFavouriteBinding: Binding<Bool> {
        Binding(
            get: { store.isFavourite(course: course) },
            set: { _ in store.toggleFavourite(course: course) }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Course Header Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 50, height: 50)
                            Image(systemName: course.iconName)
                                .font(.title2)
                                .foregroundColor(.blue)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(course.category.uppercased())
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text(course.title)
                                .font(.title3)
                                .fontWeight(.bold)
                        }

                        Spacer()
                    }

                    // R3: Passing @Binding to child view FavouriteToggleButton
                    HStack {
                        Spacer()
                        FavouriteToggleButton(isFavourite: isFavouriteBinding)
                    }
                }
                .padding(16)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)

                // Sync Notice Card
                HStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.green)
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Real-Time Synchronization (R4)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Toggling favourite status here immediately updates the home catalog and filter count.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)

                // Course Meta Details
                VStack(alignment: .leading, spacing: 10) {
                    Text("Course Overview")
                        .font(.headline)

                    Text(course.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)

                    Divider()
                        .padding(.vertical, 4)

                    HStack {
                        Label(course.instructor, systemImage: "person.circle")
                        Spacer()
                        Label(course.duration, systemImage: "clock")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(14)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
