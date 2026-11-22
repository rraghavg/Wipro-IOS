//
//  ProjectListView.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//  R1: SwiftUI list-detail flow using NavigationStack
//  R2: Real-time favourite state management
//

import SwiftUI

struct ProjectListView: View {
    @ObservedObject var store: ProjectStore

    var body: some View {
        NavigationStack {
            List {
                // Category Filter Bar
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ProjectCategory.allCases) { cat in
                                Button {
                                    store.selectedCategory = cat
                                } label: {
                                    Text(cat.rawValue)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(store.selectedCategory == cat ? Color.blue : Color(.systemGray6))
                                        .foregroundColor(store.selectedCategory == cat ? .white : .primary)
                                        .cornerRadius(16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Toggle(isOn: $store.showFavouritesOnly) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Show Favourites Only (\(store.favouriteCount))")
                                .font(.subheadline)
                        }
                    }
                } header: {
                    Text("Filter Options")
                }

                // Project List Section (R1)
                Section("Available Projects (\(store.filteredProjects.count))") {
                    if store.filteredProjects.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "tray")
                                .font(.title)
                                .foregroundColor(.secondary)
                            Text("No projects match the current filter.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(store.filteredProjects) { project in
                            NavigationLink(destination: ProjectDetailView(projectID: project.id, store: store)) {
                                projectRow(project: project)
                            }
                        }
                    }
                }
            }
            .searchable(text: $store.searchText, prompt: "Search projects by title...")
            .navigationTitle("Milestone 4 Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("\(store.favouriteCount)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(8)
                }
            }
        }
    }

    private func projectRow(project: ProjectItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: project.iconName)
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(project.title)
                        .font(.body)
                        .fontWeight(.semibold)

                    if project.isFavourite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Text(project.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Quick toggle button inside row (R2)
            Button {
                withAnimation(.spring()) {
                    store.toggleFavourite(for: project.id)
                }
            } label: {
                Image(systemName: project.isFavourite ? "heart.fill" : "heart")
                    .foregroundColor(project.isFavourite ? .red : .gray.opacity(0.5))
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
