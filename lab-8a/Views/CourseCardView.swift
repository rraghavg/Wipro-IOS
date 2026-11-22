//
//  CourseCardView.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  Reusable course-card component with configurable title, subtitle, level badge, and icon
//

import SwiftUI

struct CourseCardView: View {
    let course: Course

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card Content
            VStack(alignment: .leading, spacing: 10) {
                // Top row with category icon & level badge
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(categoryColor(course.category).opacity(0.15))
                            .frame(width: 44, height: 44)

                        Image(systemName: course.iconName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(categoryColor(course.category))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(course.category.rawValue.uppercased())
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(categoryColor(course.category))

                        Text(course.level.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                // Course Title & Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    Text(course.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Divider()
                    .padding(.vertical, 2)

                // Bottom metadata row
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption2)
                        Text(course.instructor)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption2)
                        Text("\(course.durationHours) hrs")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        }
    }

    private func categoryColor(_ category: CourseCategory) -> Color {
        switch category {
        case .all: return .blue
        case .swiftUI: return .purple
        case .uikit: return .orange
        case .swift: return .red
        case .architecture: return .teal
        }
    }
}
