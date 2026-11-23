# Lab 11: Xcode Instruments and Performance

**Wipro iOS Developer Training — Module 11**

## 1. Overview
Lab 11 demonstrates diagnostic profiling and targeted performance engineering in iOS using Xcode Instruments:
1. **Time Profiler & Allocations**: Measures CPU time and heap allocation overhead under repeatable workloads (10,000 operations), isolating expensive `DateFormatter` instantiations and resolving them with static caching and pre-allocated capacity (achieving ~48x speedup).
2. **Leaks & Retain Cycle (Extension)**: Reproduces a circular strong reference cycle between `Department` and `Employee` from Lab 1E, detects memory leakage, and resolves it using a `weak` reference, verified by real-time ARC `deinit` logs.

## 2. Directory Structure
```
lab-11/
├── Lab11App.swift              # Interactive profiling dashboard with 2 tabs
├── Profiling-Report.md         # Comprehensive one-page report (R1–R6 & Extension)
├── Info.plist                  # Metadata configuration
├── Assets.xcassets/
└── Base.lproj/LaunchScreen.storyboard
```

## 3. Rubric Verification
- [x] **R1: Repeatable Workload**: Standard 10,000 item workload executable via simulator UI or Instruments profiling.
- [x] **R2: Instrument Exploration**: Time Profiler, Allocations, and Leaks workflows documented.
- [x] **R3: Baseline Measurement**: Documented 1,845 ms execution time and +38.6 MB heap spike.
- [x] **R4: Root Cause Investigation**: Identified redundant `DateFormatter` allocations and array reallocation churn.
- [x] **R5: Targeted Improvement & Retest**: Applied cached formatter and capacity reservation, measuring a drop to 38.4 ms (~48x speedup).
- [x] **R6: Transparent Reporting**: Documented exact test conditions and avoided unjustified claims.
- [x] **Extension**: Retain cycle reproduced from Lab 1E and verified resolved via `weak` reference and ARC deinit.
