//
//  CourseExplorerView.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  R1, R2, R4, R5: Course Explorer main screen combining small reusable views,
//  extracted subviews, category filter, and empty state.
//

import SwiftUI

struct CourseExplorerView: View {
    @State private var courses: [Course] = Course.sampleCourses
    @State private var selectedCategory: CourseCategory = .all
    @State private var isSimulatingEmpty: Bool = false

    var filteredCourses: [Course] {
        if isSimulatingEmpty {
            return []
        }
        if selectedCategory == .all {
            return courses
        }
        return courses.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. Header Hero
                    headerHeroSection

                    // 2. Category Filter Pills (Horizontal Scroll)
                    categoryFilterSection

                    // 3. Status bar with count and empty toggle
                    statusBarSection

                    // 4. Course Cards or Empty State
                    if filteredCourses.isEmpty {
                        EmptyCoursesView {
                            isSimulatingEmpty = false
                            selectedCategory = .all
                        }
                    } else {
                        courseListSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Course Explorer")
        }
    }

    // MARK: - Extracted Subviews (R4)

    private var headerHeroSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Grow Your iOS Skills")
                .font(.title2)
                .fontWeight(.bold)

            Text("Browse specialized training tracks in Swift, UIKit, and modern SwiftUI architecture.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
    }

    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CourseCategory.allCases) { category in
                    Button {
                        selectedCategory = category
                        isSimulatingEmpty = false
                    } label: {
                        CategoryPillView(category: category, isSelected: selectedCategory == category && !isSimulatingEmpty)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var statusBarSection: some View {
        HStack {
            Text("\(filteredCourses.count) \(filteredCourses.count == 1 ? "Course" : "Courses")")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Spacer()

            Button {
                isSimulatingEmpty.toggle()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isSimulatingEmpty ? "arrow.counterclockwise" : "tray")
                    Text(isSimulatingEmpty ? "Restore List" : "Simulate Empty")
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSimulatingEmpty ? .blue : .orange)
            }
        }
    }

    private var courseListSection: some View {
        LazyVStack(spacing: 14) {
            ForEach(filteredCourses) { course in
                NavigationLink(destination: CourseDetailView(course: course)) {
                    CourseCardView(course: course)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - SwiftUI Preview (R3)
struct CourseExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        CourseExplorerView()
    }
}
