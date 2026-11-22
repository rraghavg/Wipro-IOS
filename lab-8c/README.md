# Lab 8C: State Management
**Wipro iOS Developer Training — Module 8 (SwiftUI Fundamentals)**  
**Student:** Raghav Gupta  
**Folder:** `lab-8c/`

---

## 📌 Objective
Master data ownership and state propagation across SwiftUI views:
- **R1:** `@State` for local UI concerns (search query, local filters).
- **R2:** Shared course data in an `ObservableObject` model (`CourseStore`).
- **R3:** Pass `@Binding` to child components (`FavouriteToggleButton`).
- **R4:** Reactive synchronization between list and detail views when favourites change.
- **R5:** Technical analysis on local vs shared state guidelines.
- **Extension:** Persistent favourites using `UserDefaults`.

---

## 📂 File Architecture
```text
lab-8c/
├── Lab8CApp.swift                   # App entry point
├── Info.plist                       # App configuration
├── Base.lproj/
│   └── LaunchScreen.storyboard      # Launch screen
├── Assets.xcassets/                 # Colors & AppIcon
├── Models/
│   └── Course.swift                 # Course domain model
├── ViewModels/
│   └── CourseStore.swift            # ObservableObject store with persistence (R2 & Extension)
├── Views/
│   ├── FavouriteToggleButton.swift  # R3 child component taking @Binding
│   ├── CourseDetailView.swift       # R4 detail view observing shared store
│   └── CourseCatalogView.swift      # R1 & R2 catalog screen with @State & @StateObject
├── State-Management-Notes.txt       # R5 technical notes on state wrappers
└── README.md                        # Project documentation
```
