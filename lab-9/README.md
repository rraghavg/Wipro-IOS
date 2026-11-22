# Lab 9: Project Configuration Audit & Info.plist

**Wipro iOS Developer Training — Module 9**

## 1. Overview
This project provides a comprehensive configuration audit of an iOS application, inspecting bundle identifiers, deployment targets, code signing, and privacy permissions. It contrasts a non-sensitive preset avatar feature with a faculty-approved photo library permission that handles denial gracefully.

## 2. Key Architecture & Components
- **`Lab9App.swift`**: SwiftUI app entry point.
- **`ConfigurationAuditView.swift`**:
  - Displays runtime metadata (`bundleIdentifier`, `CFBundleShortVersionString`, `CFBundleVersion`).
  - Implements a **non-sensitive customization feature** (color preset and SF Symbol avatar selector) requiring zero permissions.
  - Implements a **faculty-approved photo library picker** with `PhotosPicker`.
  - Simulates and handles denied permissions gracefully by showing an informative alert and a one-click redirect to `UIApplication.openSettingsURLString`.
- **`ProjectConfigurationAudit.txt`**: Complete audit document covering R1–R5 and Debug vs. Release build settings.
- **`Info.plist`**: Configured with `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription`.

## 3. Rubric Checklist
- [x] **R1: Metadata Inspection**: Bundle ID, marketing version, build number, deployment target, signing, and orientations.
- [x] **R2: Info Settings & Privacy Strings**: Verified and documented privacy descriptions in `Info.plist`.
- [x] **R3: Non-Sensitive vs Sensitive Features**: Built-in preset avatar vs. photo library picker.
- [x] **R4: Graceful Permission Handling**: Clear prompt text and redirection to iOS Settings if denied.
- [x] **R5: Scope Breakdown**: Documented per-project, per-target, and per-build-configuration settings.
- [x] **Extension**: Complete Debug vs. Release optimization and macro analysis.
