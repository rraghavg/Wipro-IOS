//
//  EmptyCoursesView.swift
//  lab-8a
//
//  Created by Raghav Gupta
//  R5: Empty state component shown when no courses match or list is cleared
//

import SwiftUI

struct EmptyCoursesView: View {
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 80, height: 80)

                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.orange)
            }

            VStack(spacing: 6) {
                Text("No Courses Available")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("There are no courses matching your selected filter, or the catalog is empty.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: onReset) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Show All Courses")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}
