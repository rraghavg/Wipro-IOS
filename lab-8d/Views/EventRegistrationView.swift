//
//  EventRegistrationView.swift
//  lab-8d
//
//  Created by Raghav Gupta
//  R1, R2, R3, R4, R5: Responsive Form with sections, pickers, toggles, inline validation,
//  disabled states, and review sheet before final confirmation.
//

import SwiftUI

struct EventRegistrationView: View {
    @State private var formData = RegistrationData()
    @State private var showReviewSheet: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var attemptedSubmit: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                // Section 1: Personal Details
                Section {
                    // Full Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Full Name (e.g. Raghav Gupta)", text: $formData.fullName)
                            .textContentType(.name)
                            .autocorrectionDisabled()

                        if attemptedSubmit && !formData.isNameValid {
                            inlineErrorText("Name must be at least 2 characters.")
                        }
                    }

                    // Email Field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Work Email Address", text: $formData.email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        if attemptedSubmit && !formData.isEmailValid {
                            inlineErrorText("Please enter a valid email address.")
                        }
                    }

                    // Organization Field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Organization / Company", text: $formData.organization)
                            .textContentType(.organizationName)

                        if attemptedSubmit && !formData.isOrganizationValid {
                            inlineErrorText("Organization is required.")
                        }
                    }
                } header: {
                    Text("Attendee Information")
                } footer: {
                    Text("All attendee details are verified for Wipro iOS training certification.")
                }

                // Section 2: Session Selection & Preferences (R1 & R2)
                Section("Workshop Track & Experience") {
                    Picker("Selected Track", selection: $formData.selectedTrack) {
                        ForEach(SessionTrack.allCases) { track in
                            Text(track.rawValue).tag(track)
                        }
                    }
                    .pickerStyle(.navigationLink)

                    Picker("Experience Level", selection: $formData.experienceLevel) {
                        ForEach(ExperienceLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.menu)

                    Toggle("Request Certificate of Attendance", isOn: $formData.wantsCertificate)
                }

                // Section 3: Notes & Long Text (R5: Long Text Testing)
                Section("Special Requirements") {
                    ZStack(alignment: .topLeading) {
                        if formData.specialNotes.isEmpty {
                            Text("Dietary preferences, accessibility needs, or specific questions...")
                                .font(.subheadline)
                                .foregroundColor(.secondary.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }

                        TextEditor(text: $formData.specialNotes)
                            .frame(minHeight: 80)
                    }
                }

                // Section 4: Terms & Code of Conduct
                Section {
                    Toggle(isOn: $formData.agreedToCodeOfConduct) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("I agree to the Training Code of Conduct")
                                .font(.subheadline)
                            Text("Mandatory for workshop attendance.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    if attemptedSubmit && !formData.agreedToCodeOfConduct {
                        inlineErrorText("You must accept the code of conduct to proceed.")
                    }
                }

                // Section 5: Form Submission Button (R4: Disabled state)
                Section {
                    Button(action: handleReviewOrSubmit) {
                        HStack {
                            Spacer()
                            Label("Review & Submit", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    // R4: Button disabled when required fields are incomplete
                    .disabled(!formData.isFormComplete)
                    .opacity(formData.isFormComplete ? 1.0 : 0.5)
                } footer: {
                    if !formData.isFormComplete {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Complete all required fields and accept terms to enable submission.")
                        }
                        .font(.caption2)
                        .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Event Registration")
            // Extension: Review sheet before final submission
            .sheet(isPresented: $showReviewSheet) {
                ReviewRegistrationSheet(registration: formData) {
                    showSuccessAlert = true
                }
            }
            // R3: Success confirmation
            .alert("Registration Confirmed! 🎉", isPresented: $showSuccessAlert) {
                Button("Done", role: .cancel) {
                    resetForm()
                }
            } message: {
                Text("Thank you, \(formData.fullName)! You are registered for '\(formData.selectedTrack.rawValue)'. A confirmation email will be sent to \(formData.email).")
            }
        }
    }

    // MARK: - Validation Helpers

    private func inlineErrorText(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
            Text(text)
        }
        .font(.caption2)
        .foregroundColor(.red)
        .padding(.top, 2)
    }

    private func handleReviewOrSubmit() {
        attemptedSubmit = true
        if formData.isFormComplete {
            showReviewSheet = true
        }
    }

    private func resetForm() {
        formData = RegistrationData()
        attemptedSubmit = false
    }
}

// MARK: - SwiftUI Preview
struct EventRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        EventRegistrationView()
    }
}

