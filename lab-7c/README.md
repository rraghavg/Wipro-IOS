# Lab 7C: UI Controls and View Lifecycle

**Module 7:** UIKit Views, View Controllers, Storyboards, and Auto Layout  
**Student Name:** Raghav Gupta  
**Project:** Wipro iOS Developer Training  

---

## 1. Objective
Gain hands-on mastery over UIKit interactive controls (`UITextField`, `UISegmentedControl`, `UISwitch`, `UISlider`, `UIDatePicker`, `UIButton`), update reactive summary panels, track view controller lifecycle transitions during navigation, and handle dynamic keyboard layout adjustments.

---

## 2. Key Components & Implementation
1. **Interactive Controls:**
   - **`UITextField`**: Live student name field (`editingChanged`).
   - **`UISegmentedControl`**: 4-level academic year selector (`valueChanged`).
   - **`UISwitch`**: Honors program participation switch.
   - **`UISlider`**: Continuous target weekly study hours (5–40 hrs) with live label.
   - **`UIDatePicker`**: Batch start date selector in `.compact` style.
   - **`UIButton`**: Navigation push trigger to inspect stack transitions.
2. **Live Summary Panel:**
   - Reactive card view that live-updates whenever any control fires an event.
3. **Full Lifecycle Logging:**
   - Detailed timestamped console logging across `viewDidLoad()`, `viewWillAppear()`, `viewDidAppear()`, `viewWillDisappear()`, `viewDidDisappear()`, and `deinit`.
4. **Keyboard Avoidance Layout:**
   - Listens to `keyboardWillShowNotification` and `keyboardWillHideNotification` to smoothly adjust `scrollView.contentInset`.
5. **Accessibility Audit (Extension):**
   - Accessible labels assigned to every control, with high contrast semantic colors tested for Light and Dark modes.

---

## 3. Deliverables
- Source code for `ControlsViewController` and `LifecycleDetailViewController`.
- Technical analysis document: `Lifecycle Observation Report.txt`.
