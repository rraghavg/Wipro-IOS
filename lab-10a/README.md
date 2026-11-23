# Lab 10A: XCTest Unit Tests

**Wipro iOS Developer Training — Module 10**

## 1. Overview
Lab 10A implements comprehensive, automated XCTest unit tests covering:
1. **Grade Calculation**: Normal letter grades, cutoffs, boundaries (0.0, 59.9, 60.0, 89.9, 90.0, 100.0), and invalid ranges (<0, >100).
2. **User Form Validation**: Length boundaries, adult age cutoff (18 vs 17), email format verification, and password strength.
3. **ViewModel Operations & Dependency Injection**: Testing business logic operations (filtering and bookmarking) using a fake injected service (`MockStudentService`) and testing an async/await pipeline with deterministic mocked data.

## 2. Directory Structure
```
lab-10a/
├── Logic/
│   ├── GradeCalculator.swift         # Grade calculation & boundary logic
│   ├── UserFormValidator.swift       # Form validation logic
│   ├── StudentServiceProtocol.swift  # Protocol & deterministic MockStudentService
│   └── StudentViewModel.swift        # ViewModel with dependency injection
├── Tests/
│   ├── GradeCalculatorTests.swift    # 5 tests covering normal/boundary/invalid
│   ├── UserFormValidatorTests.swift  # 5 tests covering normal/boundary/invalid
│   └── StudentViewModelTests.swift   # 5 tests covering VM ops & async mock
├── Lab10AApp.swift                   # Live visual test dashboard
├── Test-Run-Summary.txt              # Execution log & test run details
└── Info.plist
```

## 3. Rubric Verification
- [x] **R1: Test Target Structure**: Standard XCTest test classes with descriptive names.
- [x] **R2: Core Logic Testing**: Grade calculation, form validation, and view model operations tested independently of UI.
- [x] **R3: Normal, Boundary & Invalid Cases**: Explicit tests for 0, 100, 18, 17, negative numbers, and malformed strings.
- [x] **R4: Descriptive Names & Assertions**: Clean `test...` naming with detailed assertion messages (`XCTAssertEqual`, `XCTAssertThrowsError`, `XCTAssertTrue`).
- [x] **R5: Dependency Injection**: Injected `MockStudentService` instead of calling a live API.
- [x] **Extension**: Async service test with deterministic mocked data using Swift async/await.
