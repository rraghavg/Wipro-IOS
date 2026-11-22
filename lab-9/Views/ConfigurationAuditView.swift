//
//  ConfigurationAuditView.swift
//  lab-9
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training
//  Lab 9: Main Screen demonstrating app metadata inspection, permissionless features,
//  and graceful photo library permission handling.
//

import SwiftUI
import PhotosUI

struct ConfigurationAuditView: View {
    // App metadata read dynamically from Bundle.main (R1)
    let bundleIdentifier = Bundle.main.bundleIdentifier ?? "raghav.lab9"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    let photoUsageDescription = Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"] as? String ?? "Photo library access is used to choose an avatar."

    // R3: Feature with NO sensitive permissions (custom avatar color preset)
    @State private var selectedAvatarColor: Color = .blue
    @State private var avatarSymbol: String = "person.crop.circle.fill"

    // Optional Faculty-Approved Permission: Photo Library (R3 & R4)
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPermissionInfoAlert: Bool = false
    @State private var showSettingsPromptAlert: Bool = false
    @State private var auditSheetPresented: Bool = false

    let availableColors: [Color] = [.blue, .purple, .indigo, .teal, .green, .orange, .pink]
    let availableSymbols: [String] = ["person.crop.circle.fill", "graduationcap.circle.fill", "sparkles", "briefcase.fill", "laptopcomputer"]

    var body: some View {
        NavigationStack {
            List {
                // Section 1: Profile Avatar Header
                Section("Profile Avatar") {
                    HStack(spacing: 20) {
                        Spacer()
                        VStack(spacing: 12) {
                            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                    .shadow(radius: 4)
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(selectedAvatarColor.gradient)
                                        .frame(width: 90, height: 90)
                                        .shadow(radius: 4)

                                    Image(systemName: avatarSymbol)
                                        .font(.system(size: 42))
                                        .foregroundColor(.white)
                                }
                            }

                            Text("Raghav Gupta")
                                .font(.headline)
                            Text("Wipro iOS Trainee")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Section 2: Non-Sensitive Feature (R3)
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. Non-Sensitive Feature: Preset Customization")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("This customization modifies the avatar locally using standard Swift types without requesting any iOS system permissions.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        // Color picker presets
                        HStack(spacing: 12) {
                            ForEach(availableColors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedAvatarColor == color ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        selectedAvatarColor = color
                                        selectedImageData = nil // Revert custom photo
                                    }
                            }
                        }
                        .padding(.vertical, 4)

                        // Symbol selection
                        HStack(spacing: 16) {
                            ForEach(availableSymbols, id: \.self) { sym in
                                Button {
                                    avatarSymbol = sym
                                    selectedImageData = nil
                                } label: {
                                    Image(systemName: sym)
                                        .font(.title2)
                                        .foregroundColor(avatarSymbol == sym ? selectedAvatarColor : .gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Permissionless Feature (R3)")
                }

                // Section 3: Faculty-Approved Sensitive Feature (R3 & R4)
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("2. Faculty-Approved Permission: Photo Library")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Usage Description in Info.plist (R2):\n\"\(photoUsageDescription)\"")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(8)

                        HStack(spacing: 12) {
                            // PhotosPicker using modern out-of-process picker
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Label("Select from Photo Library", systemImage: "photo.on.rectangle")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .buttonStyle(.borderedProminent)
                            .onChange(of: selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }

                            if selectedImageData != nil {
                                Button(role: .destructive) {
                                    selectedImageData = nil
                                    selectedItem = nil
                                } label: {
                                    Text("Reset")
                                }
                                .buttonStyle(.bordered)
                            }
                        }

                        Button("Simulate Denied Permission Flow (R4)") {
                            showSettingsPromptAlert = true
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Privacy & Permission Handling (R2 & R4)")
                }

                // Section 4: Target & Metadata Audit Checklist (R1 & R5)
                Section("Project Audit Overview (R1 & R5)") {
                    auditRow(title: "Bundle Identifier", value: bundleIdentifier, icon: "cube.box")
                    auditRow(title: "Marketing Version", value: appVersion, icon: "tag")
                    auditRow(title: "Build Number", value: buildNumber, icon: "number")
                    auditRow(title: "Deployment Target", value: "iOS 17.0+", icon: "iphone")
                    auditRow(title: "Signing Style", value: "Automatic (Personal Team)", icon: "lock.shield")
                    auditRow(title: "Orientations", value: "Portrait, Landscape", icon: "arrow.triangle.2.circlepath")

                    Button {
                        auditSheetPresented = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("View Full Scope Audit (R5)", systemImage: "doc.text.magnifyingglass")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Configuration Audit")
            .sheet(isPresented: $auditSheetPresented) {
                AuditDetailsSheet()
            }
            // R4: Graceful handling of restricted or denied permission
            .alert("Photo Access Restricted", isPresented: $showSettingsPromptAlert) {
                Button("Open Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Keep Using Presets", role: .cancel) { }
            } message: {
                Text("Photo Library access was denied. To choose a photo from your library, please enable permission in iOS Settings -> Privacy -> Photos. In the meantime, you can continue using built-in presets without any restriction.")
            }
        }
    }

    private func auditRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.footnote)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Extracted sheet for R5: Project vs Target vs Configuration settings
struct AuditDetailsSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("1. Project-Level Settings") {
                    Text("Settings that apply across ALL targets in the Xcode project unless explicitly overridden.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    bullet("Base SDK: Latest iOS SDK (17.x / 18.x)")
                    bullet("Swift Language Version: Swift 5.x / 6.0")
                    bullet("Configurations: Debug and Release lists")
                    bullet("Architectures: Standard 64-bit (arm64, x86_64)")
                }

                Section("2. Target-Level Settings") {
                    Text("Settings specific to this individual application executable.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    bullet("Product Bundle Identifier: e.g. raghav.lab9")
                    bullet("Info.plist File & Custom Key Mappings")
                    bullet("Supported Device Families: iPhone & iPad (1, 2)")
                    bullet("Supported Interface Orientations: Portrait only or All")
                    bullet("Signing Certificate & Provisioning Profile")
                }

                Section("3. Build Configuration-Level Settings") {
                    Text("Settings that vary between Debug and Release schemes.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    bullet("Swift Optimization Level: -Onone (Debug) vs -O Whole Module (Release)")
                    bullet("DEBUG preprocessor macro: defined only in Debug")
                    bullet("Strip Debug Symbols: NO (Debug) vs YES (Release)")
                    bullet("Asset Catalog App Icon: allows distinct debug badge")
                }
            }
            .navigationTitle("Configuration Scope Audit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .foregroundColor(.blue)
            Text(text)
                .font(.footnote)
        }
    }
}

// MARK: - SwiftUI Preview
struct ConfigurationAuditView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationAuditView()
    }
}
