# Lab 8D: SwiftUI Layout and Form Interaction
**Wipro iOS Developer Training — Module 8 (SwiftUI Fundamentals)**  
**Student:** Raghav Gupta  
**Folder:** `lab-8d/`

---

## 📌 Objective
Create a responsive SwiftUI event registration form with declarative validation:
- **R1:** Form with text fields, a picker, a toggle, and a submit button.
- **R2:** Structured using `Form`, `Section`, padding, spacing, and alignment.
- **R3:** Inline validation feedback and personalized success alert.
- **R4:** Declarative disabled state (`.disabled(!formData.isFormComplete)`).
- **R5:** Layout testing for long text, empty input, and small-screen devices.
- **Extension:** Interactive review screen (`ReviewRegistrationSheet`) before final confirmation.

---

## 📂 File Architecture
```text
lab-8d/
├── Lab8DApp.swift                   # App entry point
├── Info.plist                       # App configuration
├── Base.lproj/
│   └── LaunchScreen.storyboard      # Launch screen
├── Assets.xcassets/                 # Colors & AppIcon
├── Models/
│   └── RegistrationModel.swift      # Form state & declarative validation rules
├── Views/
│   ├── EventRegistrationView.swift  # R1-R5: Responsive form & alerts
│   └── ReviewRegistrationSheet.swift# Extension: Review modal before submission
├── Form-Validation-Test-Cases.txt   # Comprehensive validation test scenarios
└── README.md                        # Project documentation
```
