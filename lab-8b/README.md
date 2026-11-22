# Lab 8B: Navigation and Basic Template
**Wipro iOS Developer Training — Module 8 (SwiftUI Fundamentals)**  
**Student:** Raghav Gupta  
**Folder:** `lab-8b/`

---

## 📌 Objective
Understand the SwiftUI app entry point, `WindowGroup`, and build predictable, data-driven navigation:
- **R1:** Inspect `@main App` entry point and initial `WindowGroup`.
- **R2:** Use `NavigationStack` and `NavigationLink` to move from list to detail screen.
- **R3:** Pass selected model directly to detail view.
- **R4:** Add toolbar actions and verified back-navigation behavior.
- **R5:** Technical report explaining how `App` differs from `View`.
- **Extension:** Dedicated catalog search screen with deep-link-like navigation destination.

---

## 📂 File Architecture
```text
lab-8b/
├── Lab8BApp.swift                         # R1: @main App entry point & WindowGroup
├── Info.plist                             # App configuration
├── Base.lproj/
│   └── LaunchScreen.storyboard            # Launch screen
├── Assets.xcassets/                       # Colors & AppIcon
├── Models/
│   └── Course.swift                       # Hashable & Identifiable course model
├── Views/
│   ├── CourseListView.swift               # R2, R3, R4: NavigationStack list & toolbar
│   ├── CourseDetailView.swift             # R3 & R4: Detail screen with bookmark toolbar
│   └── CourseSearchRouteView.swift        # Extension: Search navigation destination
├── App-EntryPoint-vs-View-Explanation.txt # R5: App vs View technical comparison
└── README.md                              # Project documentation
```
