//
//  Lab10BApp.swift
//  lab-10b
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10B
//  UI Automation Target with Accessibility Identifiers (R2)
//

import SwiftUI

@main
struct Lab10BApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct Candidate: Identifiable, Hashable {
    let id: String
    let name: String
    let role: String
    let experience: String
}

struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            RegistrationAutomationView()
                .tabItem {
                    Label("Register", systemImage: "square.and.pencil")
                }
                .tag(0)
                .accessibilityIdentifier("registerTabButton")

            CandidateDirectoryView()
                .tabItem {
                    Label("Directory", systemImage: "person.3.fill")
                }
                .tag(1)
                .accessibilityIdentifier("directoryTabButton")
        }
    }
}

// MARK: - Screen 1: Registration Form with Identifiers (R1, R2, R3)

struct RegistrationAutomationView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var selectedRole: String = "iOS Trainee"
    @State private var agreedToTerms: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert: Bool = false

    let roles = ["iOS Trainee", "SwiftUI Developer", "QA Automation Engineer"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Candidate Information") {
                    TextField("Full Name", text: $fullName)
                        .accessibilityIdentifier("nameTextField") // R2

                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .accessibilityIdentifier("emailTextField") // R2

                    Picker("Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }
                    .accessibilityIdentifier("rolePicker") // R2

                    Toggle("Accept Training Terms", isOn: $agreedToTerms)
                        .accessibilityIdentifier("termsToggle") // R2
                }

                // Inline Error Display (R3)
                if let error = errorMessage {
                    Section {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        .accessibilityIdentifier("validationErrorBanner") // R2 & R3
                    }
                }

                // Actions
                Section {
                    Button(action: handleSubmission) {
                        HStack {
                            Spacer()
                            Text("Submit Registration")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .accessibilityIdentifier("submitButton") // R2

                    Button("Clear Form", role: .destructive) {
                        clearForm()
                    }
                    .accessibilityIdentifier("clearButton") // R2
                }
            }
            .navigationTitle("Lab 10B Automation")
            // R1: Success Confirmation Alert
            .alert("Registration Complete", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    clearForm()
                }
                .accessibilityIdentifier("alertOkButton")
            } message: {
                Text("Welcome, \(fullName)! Your application for \(selectedRole) has been accepted.")
                    .accessibilityIdentifier("alertSuccessMessage")
            }
        }
    }

    private func handleSubmission() {
        let trimmedName = fullName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        if trimmedName.isEmpty {
            errorMessage = "Full Name cannot be empty."
            return
        }
        if trimmedEmail.isEmpty || !trimmedEmail.contains("@") {
            errorMessage = "Please provide a valid email."
            return
        }
        if !agreedToTerms {
            errorMessage = "You must accept the training terms."
            return
        }

        errorMessage = nil
        showSuccessAlert = true
    }

    private func clearForm() {
        fullName = ""
        email = ""
        agreedToTerms = false
        errorMessage = nil
    }
}

// MARK: - Screen 2: Candidate Directory & Detail Navigation (Extension)

struct CandidateDirectoryView: View {
    let candidates = [
        Candidate(id: "c1", name: "Raghav Gupta", role: "iOS Trainee", experience: "Swift, SwiftUI, UIKit"),
        Candidate(id: "c2", name: "Aarav Mehta", role: "QA Engineer", experience: "XCUITest, Performance"),
        Candidate(id: "c3", name: "Isha Nair", role: "Backend Developer", experience: "REST, Node, Cloud")
    ]

    @State private var searchText: String = ""

    var filteredCandidates: [Candidate] {
        if searchText.isEmpty { return candidates }
        return candidates.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                if filteredCandidates.isEmpty {
                    Text("No candidates found")
                        .accessibilityIdentifier("emptyStateLabel") // R3
                } else {
                    ForEach(Array(filteredCandidates.enumerated()), id: \.element.id) { index, candidate in
                        NavigationLink(destination: CandidateDetailView(candidate: candidate)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(candidate.name)
                                    .font(.headline)
                                Text(candidate.role)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .accessibilityIdentifier("candidateRow_\(index)") // R2
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search candidates")
            .accessibilityIdentifier("directorySearchField")
            .navigationTitle("Candidates")
        }
    }
}

struct CandidateDetailView: View {
    let candidate: Candidate
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            Text(candidate.name)
                .font(.title2)
                .fontWeight(.bold)
                .accessibilityIdentifier("candidateDetailTitle") // R2

            Text(candidate.role)
                .font(.headline)
                .foregroundColor(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Technical Skillset:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(candidate.experience)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("candidateDetailBio")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)

            Spacer()
        }
        .padding(20)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
