//
//  ProjectSubmissionFormView.swift
//  assessment-m4
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Milestone 4
//  R3: Validated submission form with loading, success, error, and confirmation states
//

import SwiftUI

enum SubmissionState {
    case idle
    case loading
    case success(message: String)
    case error(message: String)
}

struct ProjectSubmissionFormView: View {
    @ObservedObject var store: ProjectStore

    // Form inputs
    @State private var projectTitle: String = ""
    @State private var authorEmail: String = ""
    @State private var selectedCategory: ProjectCategory = .swiftUI
    @State private var durationHours: Int = 4
    @State private var projectDescription: String = ""
    @State private var agreeToRubric: Bool = false

    // State management for R3
    @State private var attemptedSubmit: Bool = false
    @State private var submissionState: SubmissionState = .idle
    @State private var showSuccessAlert: Bool = false

    // Declarative validation
    var isTitleValid: Bool {
        projectTitle.trimmingCharacters(in: .whitespaces).count >= 3
    }

    var isEmailValid: Bool {
        let trimmed = authorEmail.trimmingCharacters(in: .whitespaces)
        return trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 5
    }

    var isDescriptionValid: Bool {
        projectDescription.trimmingCharacters(in: .whitespaces).count >= 10
    }

    var isFormValid: Bool {
        isTitleValid && isEmailValid && isDescriptionValid && agreeToRubric
    }

    var body: some View {
        NavigationStack {
            Form {
                // Section 1: Project Details
                Section("Project Information") {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Project Title (min 3 chars)", text: $projectTitle)
                            .autocorrectionDisabled()

                        if attemptedSubmit && !isTitleValid {
                            inlineError("Project title must be at least 3 characters.")
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Author Email Address", text: $authorEmail)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        if attemptedSubmit && !isEmailValid {
                            inlineError("Please enter a valid work email address.")
                        }
                    }

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ProjectCategory.allCases.filter { $0 != .all }) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }

                    Stepper("Estimated Duration: \(durationHours) Hours", value: $durationHours, in: 1...40)
                }

                // Section 2: Specification
                Section("Project Specification & Goals") {
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .topLeading) {
                            if projectDescription.isEmpty {
                                Text("Describe project deliverables, architecture, and objectives...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }

                            TextEditor(text: $projectDescription)
                                .frame(minHeight: 90)
                        }

                        if attemptedSubmit && !isDescriptionValid {
                            inlineError("Description must be at least 10 characters.")
                        }
                    }
                }

                // Section 3: Rubric Compliance & Loading / Error States (R3)
                Section {
                    Toggle(isOn: $agreeToRubric) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("I certify this meets all Milestone 4 criteria")
                                .font(.subheadline)
                            Text("Verified against TiE edu rubrics.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    if attemptedSubmit && !agreeToRubric {
                        inlineError("You must accept rubric compliance to submit.")
                    }

                    // Display active submission state
                    switch submissionState {
                    case .loading:
                        HStack(spacing: 12) {
                            ProgressView()
                            Text("Validating and registering submission...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)

                    case .error(let msg):
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.red)
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 4)

                    case .success(let msg):
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding(.vertical, 4)

                    case .idle:
                        EmptyView()
                    }
                }

                // Section 4: Action Button
                Section {
                    Button(action: submitProject) {
                        HStack {
                            Spacer()
                            if case .loading = submissionState {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Label("Submit Milestone Project", systemImage: "paperplane.fill")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid || submissionStateIsLoading)
                    .opacity(isFormValid ? 1.0 : 0.5)
                } footer: {
                    if !isFormValid {
                        Text("Fill all required fields and accept criteria to enable submission.")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Submit Project (R3)")
            .alert("Submission Successful! 🎉", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    resetForm()
                }
            } message: {
                Text("Project '\(projectTitle)' has been added to your Milestone 4 project list.")
            }
        }
    }

    private var submissionStateIsLoading: Bool {
        if case .loading = submissionState { return true }
        return false
    }

    private func inlineError(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
            Text(text)
        }
        .font(.caption2)
        .foregroundColor(.red)
        .padding(.top, 2)
    }

    private func submitProject() {
        attemptedSubmit = true
        guard isFormValid else { return }

        submissionState = .loading

        // Simulate asynchronous network/persistence pipeline
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            store.addProject(
                title: projectTitle,
                subtitle: "\(durationHours) Hours • \(selectedCategory.rawValue)",
                category: selectedCategory,
                duration: "\(durationHours) Hours",
                description: projectDescription
            )

            submissionState = .success(message: "Project successfully registered!")
            showSuccessAlert = true
        }
    }

    private func resetForm() {
        projectTitle = ""
        authorEmail = ""
        selectedCategory = .swiftUI
        durationHours = 4
        projectDescription = ""
        agreeToRubric = false
        attemptedSubmit = false
        submissionState = .idle
    }
}
