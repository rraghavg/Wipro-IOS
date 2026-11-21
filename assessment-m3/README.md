# Assessment Milestone 3: Networking and UIKit
**Wipro iOS Developer Training (Swift)**  
**Student:** Raghav Gupta  
**Module:** Networking and UIKit  
**Target Folder:** `assessment-m3/`

---

## 📌 Milestone Overview & Deliverables

This milestone demonstrates production-grade UIKit development, Auto Layout constraint design, modern networking with Swift Concurrency, and robust error/empty state management:

1. **R1: UIKit Form with Validation & Auto Layout**
   - Built programmatically with `UIView`, `UIScrollView`, `UIStackView`, `UITextField`, `UILabel`, and `UIButton`.
   - Full Auto Layout constraints (zero fixed frame coordinates).
   - Dynamic keyboard avoidance adjusting scroll view content insets.
   - Inline error messages with error-highlight border and haptic shake animation.
   - Fields: Full Name (min 2 chars), Email (regex pattern check), Course Track.

2. **R2: JSON Decoding into Codable Models & List Rendering**
   - Public classroom-approved test API endpoint: `https://jsonplaceholder.typicode.com/posts`
   - `Post` model conforming to `Codable` and `Identifiable`.
   - Networking isolated in `PostService` using `URLSession` with `async/await` and `JSONDecoder`.
   - Rendered using custom `PostTableViewCell` with dynamic heights and badge styling.

3. **R3: Loading, Success, Empty, and Failure States**
   - **Loading State:** Centered `UIActivityIndicatorView` with progress label.
   - **Success State:** Populated `UITableView` with pull-to-refresh (`UIRefreshControl`).
   - **Empty State:** Informational card with tray icon and guidance message.
   - **Failure State:** Error card displaying HTTP status / network error with a prominent **"Retry"** action button.
   - **Simulation Mode Action Sheet:** Nav bar "Simulate" menu allowing reviewers/faculty to test Live API, HTTP 404, HTTP 500, Decoding Error, Offline, and Empty Results on demand!

4. **R4: Navigation from List to Detail Screen**
   - Managed via `UINavigationController` push/pop transitions.
   - Passes the selected `Post` model cleanly through initializer dependency injection (`PostDetailViewController(post:)`), avoiding global variables.
   - Scrollable card view showing post ID badge, user badge, formatted title, separator, and full body text.

5. **R5: Viva & Faculty Review Guide**
   - Detailed technical documentation in [Viva-Networking-and-UIKit-Guide.txt](file:///Users/raghavgupta/Desktop/Wipro%20IOS/assessment-m3/Viva-Networking-and-UIKit-Guide.txt) covering:
     - View Hierarchy & Responder Chain.
     - Auto Layout, `translatesAutoresizingMaskIntoConstraints`, layout equations, priorities, and safe area guides.
     - `URLSession` architectures, HTTP status validation, and API security.
     - `Codable`, `CodingKeys`, snake_case conversions, and unit testing JSON parsing.

---

## 📂 Project Structure

```text
assessment-m3/
├── AppDelegate.swift                           # App lifecycle management
├── SceneDelegate.swift                         # Window setup with UITabBarController
├── Info.plist                                  # Scene manifest and ATS configuration
├── Base.lproj/
│   └── LaunchScreen.storyboard                 # Launch screen
├── Assets.xcassets/                            # Accent color & AppIcon
├── Models/
│   └── Post.swift                              # Codable model for JSONPlaceholder /posts
├── Services/
│   └── PostService.swift                       # URLSession async/await service + simulation modes
├── Views/
│   └── PostTableViewCell.swift                 # Reusable custom table view cell
├── Controllers/
│   ├── ProfileFormViewController.swift          # R1: Form with Auto Layout, validation, shake
│   ├── PostListViewController.swift             # R2 & R3: List, loading/empty/error states
│   └── PostDetailViewController.swift           # R4: Detail screen with injected model
├── Viva-Networking-and-UIKit-Guide.txt         # R5: Complete Viva Q&A and technical reference
└── README.md                                  # Complete Milestone documentation
```

---

## 🚀 Running and Testing in Xcode

1. Open `Wipro IOS.xcodeproj` in Xcode.
2. Select the **`assessment-m3`** scheme from the scheme selector.
3. Choose an iPhone Simulator (e.g., iPhone 15 Pro, iPhone 16) and press **⌘R** (Run).
4. **Testing Tabs:**
   - **Tab 1 ("Register"):** Test empty submissions, short names, invalid emails to observe inline errors and shake animations. Enter valid details to see the success banner.
   - **Tab 2 ("Directory"):** View the fetched posts from `jsonplaceholder.typicode.com`. Tap **"Simulate"** in the top right navigation bar to test HTTP 404, HTTP 500, Offline, and Empty Results states. Tap any post row to push the detailed view.
