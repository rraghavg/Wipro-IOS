//
//  CategoryPillView.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  Reusable badge pill for category tags
//

import SwiftUI

struct CategoryPillView: View {
    let category: CourseCategory
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconForCategory(category))
                .font(.caption2)
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
        )
        .foregroundColor(isSelected ? .white : .primary)
        .overlay(
            Capsule()
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }

    private func iconForCategory(_ category: CourseCategory) -> String {
        switch category {
        case .all: return "sparkles"
        case .swiftUI: return "square.stack.3d.up.fill"
        case .uikit: return "rectangle.3.group.fill"
        case .swift: return "swift"
        case .architecture: return "arrow.triangle.branch"
        }
    }
}
