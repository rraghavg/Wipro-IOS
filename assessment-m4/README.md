# Assessment Milestone 4: SwiftUI and Configuration

**Wipro iOS Developer Training — Milestone 4**

## 1. Overview
Assessment Milestone 4 demonstrates a production-ready SwiftUI application combining:
- A data-driven list-detail flow using `NavigationStack`.
- State-driven favourite synchronization between views via an `ObservableObject` store.
- A validated project submission form supporting loading, success, error, and confirmation states.
- Complete documentation of app configuration metadata and viva answers.

## 2. Directory Structure
```
assessment-m4/
├── Milestone4App.swift                     # @main App entry point with TabView
├── Models/
│   └── ProjectItem.swift                  # Project model & categories
├── ViewModels/
│   └── ProjectStore.swift                 # ObservableObject with reactive favourites
├── Views/
│   ├── ProjectListView.swift              # NavigationStack list with search & chips
│   ├── ProjectDetailView.swift            # Detail screen with synced favourite toggle
│   ├── ProjectSubmissionFormView.swift    # Validated form with async loading states
│   └── ConfigurationAndVivaView.swift     # In-app interactive viva & audit cards
├── Viva-Milestone4-SwiftUI-and-Configuration.txt # Complete viva explanations
├── Info.plist                             # Metadata & Privacy Usage keys
├── Assets.xcassets/
└── Base.lproj/LaunchScreen.storyboard
```

## 3. Rubric Verification
- [x] **R1: NavigationStack List-Detail**: Interactive navigation between project list and detail screen.
- [x] **R2: Synchronized Favourites**: Modifying favourite state in the detail view immediately reflects in the list and tab badges.
- [x] **R3: Validated Form with States**: Declarative form with validation error banners, progress spinner, and confirmation alert.
- [x] **R4: Configuration Documentation**: Explained app entry point, bundle ID, deployment target, and privacy strings.
- [x] **R5: Viva Responses**: Compared `@State` vs `@Binding`, and `App` vs `View` roles.
