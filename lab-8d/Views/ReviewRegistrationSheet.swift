//
//  ReviewRegistrationSheet.swift
//  lab-8d
//
//  Created by Raghav Gupta
//  Extension: Review screen allowing trainees to inspect registration data before final submission
//

import SwiftUI

struct ReviewRegistrationSheet: View {
    let registration: RegistrationData
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Attendee Profile") {
                    labeledRow(label: "Full Name", value: registration.fullName)
                    labeledRow(label: "Email Address", value: registration.email)
                    labeledRow(label: "Organization", value: registration.organization)
                    labeledRow(label: "Experience", value: registration.experienceLevel.rawValue)
                }

                Section("Session Selection") {
                    labeledRow(label: "Track", value: registration.selectedTrack.rawValue)
                    labeledRow(label: "Certificate Requested", value: registration.wantsCertificate ? "Yes (Verified)" : "No")
                }

                if !registration.specialNotes.isEmpty {
                    Section("Additional Notes") {
                        Text(registration.specialNotes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button(action: {
                        dismiss()
                        onConfirm()
                    }) {
                        HStack {
                            Spacer()
                            Label("Confirm & Complete Registration", systemImage: "checkmark.circle.fill")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Review Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Edit") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func labeledRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}
