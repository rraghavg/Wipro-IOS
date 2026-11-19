# Lab 7B: Storyboards, View Hierarchy, and Navigation

**Module 7:** UIKit Views, View Controllers, Storyboards, and Auto Layout  
**Student Name:** Raghav Gupta  
**Project:** Wipro iOS Developer Training  

---

## 1. Objective
Develop a two-screen course catalog app to explore UINavigationController stack navigation, model object transfer via dependency injection without global state, deep view hierarchy inspection, and defensive unwrapping practices.

---

## 2. Key Components
1. **Course Model (`Models/Course.swift`):**
   - Holds strongly-typed course information: `id`, `title`, `instructor`, `duration`, `level`, `category`, `description`, `syllabus`, and SF Symbol icon names.
2. **List Screen (`CourseListViewController.swift`):**
   - Hosts `UITableView` styled with inset grouping.
   - Embeds a custom empty state view toggled via the navigation bar ("Toggle Empty") to demonstrate dynamic catalog reloading.
   - Uses dependency injection to push the selected course into `CourseDetailViewController`.
3. **Detail Screen (`CourseDetailViewController.swift`):**
   - Structured with `UIScrollView` + `UIStackView` displaying course metadata, detailed syllabus curriculum with numbered badges, and enrollment buttons.
   - Features explicit navigation stack pop transitions (`navigationController?.popViewController(animated: true)`).
4. **Custom Reusable Cell (`Views/CourseTableViewCell.swift`):**
   - Displays icon container, multi-line titles, instructor credits, dynamic level pill badges (color-coded for Beginner, Intermediate, and Advanced), and duration tags.
5. **Safety Architecture:**
   - Zero force unwraps (`!`).
   - All cell dequeueing, index path queries, and model bindings use `guard let` with graceful fallbacks.

---

## 3. Deliverables
- Two-screen application source code.
- Detailed technical report: `Navigation Flow and View Hierarchy.txt`.
- Screenshots of catalog list, course details, and empty state.
