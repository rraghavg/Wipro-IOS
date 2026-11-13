//
//  TaskListView.swift
//  lab-4a (MVVM)
//
//  Created by Raghav Gupta on 12/11/26.
//

import SwiftUI

// view - only binds to viewModel, no business logic here
struct TaskListView: View {

    @StateObject private var viewModel = TaskViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // input row
                HStack {
                    TextField("Enter new task...", text: $viewModel.newTitle)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        viewModel.addTask()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                // validation error
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                // filter picker
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // task list
                List {
                    ForEach(viewModel.filteredTasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)

                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundColor(task.isCompleted ? .secondary : .primary)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleComplete(task: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTasks)
                }
            }
            .navigationTitle("Task List (MVVM)")
        }
    }
}
