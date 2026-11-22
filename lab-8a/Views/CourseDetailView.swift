//
//  CourseDetailView.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  R1: Course detail screen showing complete syllabus and metadata
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Banner
                headerBanner

                // Quick stats row
                statsRow

                // Course Description
                descriptionSection

                // Syllabus Topics
                syllabusSection
            }
            .padding(16)
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Extracted Subviews for Readability (R4)

    private var headerBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 140)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: course.iconName)
                        .font(.title2)
                    Text(course.category.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
                .foregroundColor(.white.opacity(0.9))

                Text(course.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(course.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(16)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(icon: "person.fill", title: "Instructor", value: course.instructor)
            statCard(icon: "clock.fill", title: "Duration", value: "\(course.durationHours) Hours")
            statCard(icon: "chart.bar.fill", title: "Level", value: course.level.rawValue)
        }
    }

    private func statCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About this course")
                .font(.headline)

            Text(course.summary)
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Course Curriculum")
                .font(.headline)

            ForEach(Array(course.topics.enumerated()), id: \.offset) { index, topic in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.12))
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Text(topic)
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding(.vertical, 4)

                if index < course.topics.count - 1 {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}
