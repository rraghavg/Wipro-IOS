# Lab 8A: SwiftUI App Structure and Views
**Wipro iOS Developer Training — Module 8 (SwiftUI Fundamentals)**  
**Student:** Raghav Gupta  
**Folder:** `lab-8a/`

---

## 📌 Objective
Build a multi-view Course Explorer application using small, modular, reusable SwiftUI views. Fulfill all five requirements:
- **R1:** Course Explorer app with title, cards, category labels, and detail screen.
- **R2:** Use `VStack`, `HStack`, `ZStack`, `ScrollView`, `List`/`LazyVStack`, and custom views.
- **R3:** Preview / Simulator iterations.
- **R4:** Extract subviews to keep view bodies clean and readable.
- **R5:** Dedicated empty state when no courses exist.
- **Extension:** Reusable course-card component with configurable title, subtitle, level, and duration badge.

---

## 📂 File Architecture
```text
lab-8a/
├── Lab8AApp.swift               # @main App entry point
├── Info.plist                   # App configuration
├── Base.lproj/
│   └── LaunchScreen.storyboard  # Launch screen
├── Assets.xcassets/             # Colors & AppIcon
├── Models/
│   └── Course.swift             # Course model & sample catalog
├── Views/
│   ├── CategoryPillView.swift   # Reusable category tag
│   ├── CourseCardView.swift     # Reusable configurable course card (Extension)
│   ├── EmptyCoursesView.swift   # R5 empty state with reset action
│   ├── CourseDetailView.swift   # R1 detail view with curriculum & stats
│   └── CourseExplorerView.swift # Main explorer view with extracted subviews
├── Component-Tree.txt           # R4 component tree & layout breakdown
└── README.md                    # Project documentation
```
