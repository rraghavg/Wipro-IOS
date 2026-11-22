//
//  CourseDetailView.swift
//  lab-8b
//
//  Created by Raghav Gupta
//  R3: Detail screen receiving selected Course model via NavigationLink
//  R4: Includes toolbar action and custom dismiss action
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @Environment(\.dismiss) private var dismiss
    @State private var isBookmarked: Bool = false
    @State private var showShareAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Card
                headerCard

                // Course Meta Info
                metadataGrid

                // Overview
                overviewSection

                // Syllabus Modules
                syllabusSection
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
        // R4: Toolbar actions & customizable navigation bar
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .orange : .blue)
                }

                Button {
                    showShareAlert = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .alert("Share Course", isPresented: $showShareAlert) {
            Button("Copy Link", role: .none) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Share '\(course.title)' with your fellow Wipro iOS trainees.")
        }
    }

    // MARK: - Extracted Subviews

    private var headerCard: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 60, height: 60)

                Image(systemName: course.iconName)
                    .font(.title)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(course.category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Text(course.title)
                    .font(.headline)

                Text("Instructor: \(course.instructor)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    private var metadataGrid: some View {
        HStack(spacing: 12) {
            metaBadge(icon: "clock.fill", label: "Duration", value: course.duration)
            metaBadge(icon: "person.2.fill", label: "Audience", value: "iOS Trainees")
            metaBadge(icon: "checkmark.seal.fill", label: "Certificate", value: "Verified")
        }
    }

    private func metaBadge(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.blue)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Course Overview")
                .font(.headline)

            Text(course.overview)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }

    private var syllabusSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Curriculum Modules")
                .font(.headline)

            ForEach(Array(course.syllabus.enumerated()), id: \.offset) { idx, item in
                HStack(spacing: 12) {
                    Text("\(idx + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 24, height: 24)
                        .background(Color.blue.opacity(0.12))
                        .foregroundColor(.blue)
                        .clipShape(Circle())

                    Text(item)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.vertical, 4)

                if idx < course.syllabus.count - 1 {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}
