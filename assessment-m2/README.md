# Assessment Milestone 2: Architecture and Concurrency
**Wipro iOS Developer Training (Swift)**  
**Student:** Raghav Gupta  
**Module:** Architecture and Modern Concurrency  
**Target Folder:** `assessment-m2/`

---

## 📌 Milestone Overview & Deliverables

This milestone demonstrates production-grade iOS architecture and asynchronous programming techniques in Swift:
1. **MVVM Refactoring & Unit Testing:** Moving state and business logic out of the View into an isolated, unit-tested ViewModel.
2. **Concurrent Multi-Source Fetching:** Fetching two independent endpoints concurrently using `async let` and `withThrowingTaskGroup`, demonstrating a 2.0x speedup over sequential execution.
3. **Comprehensive Async States:** Modeling and handling `Idle`, `Loading`, `Success`, `Error`, and `Cancellation` states.
4. **Main Thread Safety:** Deep technical analysis and runnable proof showing why UI mutations must execute on `@MainActor` / Main Queue.
5. **Concurrency Viva Guide:** Side-by-side comparison of Grand Central Dispatch (GCD), async/await, Task, and Task Groups, with faculty viva Q&A.

---

## 📂 Project Structure

```text
assessment-m2/
├── task1.swift                                 # Task 1: MVVM Task List + Unit Test Runner
├── task2.swift                                 # Task 2: Concurrent multi-source fetching (async let & TaskGroup)
├── task3.swift                                 # Task 3: 4-State Async lifecycle & cooperative cancellation
├── task4.swift                                 # Task 4: Thread verification & @MainActor vs GCD demo
├── task5.swift                                 # Task 5: Viva code comparison of all 4 concurrency models
├── task-1/
│   └── main.swift                              # Xcode Tool Target source for Task 1
├── task-2/
│   └── main.swift                              # Xcode Tool Target source for Task 2
├── task-3/
│   └── main.swift                              # Xcode Tool Target source for Task 3
├── task-4/
│   └── main.swift                              # Xcode Tool Target source for Task 4
├── task-5/
│   └── main.swift                              # Xcode Tool Target source for Task 5
├── Why-Main-Actor-UI-Explanation.txt          # Task 4: Technical report on UIKit thread safety & RunLoop
├── Viva-Concurrency-Comparison-Guide.txt      # Task 5: Comprehensive Viva Q&A & comparison matrix
└── README.md                                  # Complete Milestone documentation
```

---

## 🚀 How to Run the Tasks

Each task can be run directly from terminal or via its Xcode scheme:

### 1. Task 1: MVVM & Unit Testing
```bash
swift assessment-m2/task1.swift
```
**Output Highlights:**
- Demonstrates UI rendering and reactive binding.
- Runs 8 automated unit tests covering validation, toggling, deletion, filtering, sorting, and completion clearing.
- `8 Passed | 0 Failed`.

### 2. Task 2: Concurrent Multi-Source Fetching
```bash
swift assessment-m2/task2.swift
```
**Output Highlights:**
- Sequential Time: `1.045s`
- Concurrent Time (`async let`): `0.519s`
- Concurrent Time (`withThrowingTaskGroup`): `0.522s`
- **Speedup:** `2.0x faster` execution by fetching independent endpoints simultaneously.

### 3. Task 3: Loading, Success, Error, & Cancellation States
```bash
swift assessment-m2/task3.swift
```
**Output Highlights:**
- `Scenario 1 (Success)`: Transitions `.idle` ➔ `.loading` ➔ `.success`.
- `Scenario 2 (Error)`: Handles HTTP 503 failure gracefully ➔ `.failure`.
- `Scenario 3 (Cancellation)`: Mid-flight cancellation via `Task.cancel()` caught cooperatively ➔ `.cancelled`.

### 4. Task 4: Main Actor & UI Thread Safety
```bash
swift assessment-m2/task4.swift
```
**Output Highlights:**
- Prints active thread identity (`🟢 MAIN THREAD` vs `🔵 BACKGROUND THREAD`).
- Demonstrates compile-time actor isolation with `@MainActor`.
- Compares against legacy `DispatchQueue.main.async`.

### 5. Task 5: Viva Preparation & Model Comparisons
```bash
swift assessment-m2/task5.swift
```
**Output Highlights:**
- Solves the identical multi-task problem across all 4 paradigms: GCD, `async/await`, `Task`, and `Task Groups`.
- Includes side-by-side architectural cheat sheet.
- Complete Viva answers available in [Viva-Concurrency-Comparison-Guide.txt](file:///Users/raghavgupta/Desktop/Wipro%20IOS/assessment-m2/Viva-Concurrency-Comparison-Guide.txt).
