# Lab 7A: UIKit Profile Form

**Module 7:** UIKit Views, View Controllers, Storyboards, and Auto Layout  
**Student Name:** Raghav Gupta  
**Project:** Wipro iOS Developer Training  

---

## 1. Objective
Build a robust, responsive UIKit profile registration form utilizing strict Auto Layout constraints, real-time and on-submit validation, accessibility labels, and seamless keyboard management without relying on fixed screen coordinates.

---

## 2. Key Features & Implementation
1. **Responsive Auto Layout (`UIScrollView` + `UIStackView`):**
   - No hardcoded frames or screen coordinates.
   - Pinned with `NSLayoutConstraint.activate(...)` to `safeAreaLayoutGuide` and `contentLayoutGuide`.
   - Adapts to small screens (e.g. iPhone SE) and large screens (iPhone 16 / 17 Pro Max) without content clipping.
2. **Keyboard Handling & Dismissal:**
   - Anchored to Apple's modern `keyboardLayoutGuide.topAnchor` to prevent the software keyboard from covering input fields.
   - `UITapGestureRecognizer` allows users to tap anywhere outside the form to dismiss the keyboard.
   - `textFieldShouldReturn` advances focus from Name ➔ Email ➔ Course ➔ Submit.
   - `scrollView.keyboardDismissMode = .onDrag` enables intuitive scrolling dismissal.
3. **Form Validation & Inline Errors:**
   - **Name:** Minimum 2 characters required. Shows inline error and highlights field border.
   - **Email:** Strict regex validation (`[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}`).
   - **Course Track:** Flexible segmented control combined with optional custom track entry.
   - Real-time clearing of error messages when user edits text (`editingChanged`).
4. **Subtle Feedback Animation:**
   - Triggers a card shake animation (`CAKeyframeAnimation`) on invalid submission attempts.
   - Displays a clean `UIAlertController` upon valid form completion.
5. **Accessibility & Dynamic Type (Extension):**
   - All labels use `UIFontMetrics.default.scaledFont(...)` and `adjustsFontForContentSizeCategory = true`.
   - Every text field, segmented control, and button includes descriptive `accessibilityLabel` and `accessibilityHint` properties for VoiceOver users.
   - Semantic system colors (`.systemBackground`, `.secondarySystemGroupedBackground`, `.label`, `.secondaryLabel`, `.systemBlue`) ensure full Dark Mode and High Contrast compatibility.
