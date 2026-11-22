//
//  ProjectDetailView.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//  R1 & R2: Detail view observing shared store and keeping favourite status in sync
//

import SwiftUI

struct ProjectDetailView: View {
    let projectID: String
    @ObservedObject var store: ProjectStore

    // Retrieve current project dynamically from store to ensure real-time reactive sync
    var project: ProjectItem? {
        store.projects.first(where: { $0.id == projectID })
    }

    var body: some View {
        Group {
            if let current = project {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header Card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .top) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.blue.opacity(0.12))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: current.iconName)
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(current.category.rawValue.uppercased())
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)

                                    Text(current.title)
                                        .font(.title3)
                                        .fontWeight(.bold)

                                    Text(current.subtitle)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }

                            Divider()

                            // Interactive Favourite Button (R2)
                            HStack {
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        store.toggleFavourite(for: current.id)
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: current.isFavourite ? "heart.fill" : "heart")
                                            .foregroundColor(current.isFavourite ? .red : .gray)
                                            .font(.title3)

                                        Text(current.isFavourite ? "Favourited Project" : "Add to Favourites")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(current.isFavourite ? .red : .primary)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(current.isFavourite ? Color.red.opacity(0.12) : Color(.systemGray6))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                Spacer()

                                Text(current.difficulty)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.15))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(16)

                        // Sync Notification Banner (R2)
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.green)
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Two-Way View Synchronization (R2)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Text("Any change made to the heart icon above immediately updates the list view badge and tab icon count.")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)

                        // Project Overview
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Project Specification")
                                .font(.headline)

                            Text(current.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)

                            Divider()
                                .padding(.vertical, 6)

                            HStack {
                                Label("Estimated Time: \(current.duration)", systemImage: "clock")
                                Spacer()
                                Label("ID: \(current.id)", systemImage: "tag")
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                    }
                    .padding(16)
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle(current.title)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Project not found.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
