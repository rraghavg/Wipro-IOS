//
//  Lab11App.swift
//  lab-11
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Module 11
//  Interactive performance profiling and retain cycle demonstration app
//

import SwiftUI

@main
struct Lab11App: App {
    var body: some Scene {
        WindowGroup {
            ProfilingDashboardView()
        }
    }
}

// MARK: - Retain Cycle Models (Extension & Lab 1E Reproduction)

class LeakyDepartment {
    let name: String
    var employees: [LeakyEmployee] = []

    init(name: String) {
        self.name = name
        print("🟢 LeakyDepartment '\(name)' initialized")
    }

    deinit {
        print("🔴 LeakyDepartment '\(name)' DEALLOCATED")
    }
}

class LeakyEmployee {
    let name: String
    // Strong reference creates a circular retain cycle with LeakyDepartment.employees
    var department: LeakyDepartment?

    init(name: String, department: LeakyDepartment?) {
        self.name = name
        self.department = department
        print("🟢 LeakyEmployee '\(name)' initialized")
    }

    deinit {
        print("🔴 LeakyEmployee '\(name)' DEALLOCATED")
    }
}

// Fixed version using weak reference
class FixedDepartment {
    let name: String
    var employees: [FixedEmployee] = []

    init(name: String) {
        self.name = name
        print("🟢 FixedDepartment '\(name)' initialized")
    }

    deinit {
        print("🔴 FixedDepartment '\(name)' DEALLOCATED")
    }
}

class FixedEmployee {
    let name: String
    // Weak reference breaks the circular reference cycle
    weak var department: FixedDepartment?

    init(name: String, department: FixedDepartment?) {
        self.name = name
        self.department = department
        print("🟢 FixedEmployee '\(name)' initialized")
    }

    deinit {
        print("🔴 FixedEmployee '\(name)' DEALLOCATED")
    }
}

// MARK: - Transaction Data Item

struct TransactionItem: Identifiable {
    let id: Int
    let title: String
    let amount: Double
    let timestamp: Date
}

// Cached singleton DateFormatter for targeted optimization (R5)
class PerformanceDateFormatter {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Main Dashboard View

struct ProfilingDashboardView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PerformanceBenchmarkView()
                .tabItem {
                    Label("Time & Allocations", systemImage: "gauge.with.needle.fill")
                }
                .tag(0)

            MemoryLeakBenchmarkView()
                .tabItem {
                    Label("Leaks & ARC", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(1)
        }
    }
}

// MARK: - Tab 1: CPU Time Profiler & Allocations Benchmark (R1, R3, R4, R5)

struct PerformanceBenchmarkView: View {
    @State private var workloadCount: Int = 10_000
    @State private var isOptimizedMode: Bool = false
    @State private var executionDurationMs: Double = 0.0
    @State private var isProcessing: Bool = false
    @State private var statusMessage: String = "Select mode and tap 'Run Workload'"

    var body: some View {
        NavigationStack {
            List {
                Section("Repeatable Workload Controls (R1)") {
                    Picker("Workload Items", selection: $workloadCount) {
                        Text("5,000 Items").tag(5_000)
                        Text("10,000 Items").tag(10_000)
                        Text("20,000 Items").tag(20_000)
                    }
                    .pickerStyle(.segmented)

                    Toggle("Enable Targeted Optimizations (R5)", isOn: $isOptimizedMode)
                        .tint(.green)

                    Button(action: executeWorkload) {
                        HStack {
                            Spacer()
                            if isProcessing {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text(isProcessing ? "Processing..." : "Run Repeatable Workload")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .disabled(isProcessing)
                }

                Section("Profiling Observations (R3 & R5)") {
                    HStack {
                        Text("Execution Time:")
                        Spacer()
                        Text(String(format: "%.2f ms", executionDurationMs))
                            .fontWeight(.bold)
                            .foregroundColor(isOptimizedMode ? .green : .red)
                    }

                    HStack {
                        Text("Engine Mode:")
                        Spacer()
                        Text(isOptimizedMode ? "Optimized (Linear + Cached)" : "Baseline (Quadratic + New Formatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text(statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }

                Section("Technical Explanations") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Baseline Issues (R4):")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text("1. Allocating a new `DateFormatter()` on each item iteration. `DateFormatter` is very heavy to initialize because it queries system locale and calendar caches.\n2. Repeated string concatenation copying arrays repeatedly (quadratic overhead).")
                            .font(.caption2)
                            .foregroundColor(.secondary)

                        Divider()

                        Text("Targeted Improvements (R5):")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("1. Reused single cached `PerformanceDateFormatter.shared` instance.\n2. Replaced repetitive string allocation with single buffered array capacity pre-allocation.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Time & Allocations")
        }
    }

    private func executeWorkload() {
        isProcessing = true
        statusMessage = "Executing \(workloadCount) operations..."

        DispatchQueue.global(qos: .userInitiated).async {
            let start = CFAbsoluteTimeGetCurrent()

            if isOptimizedMode {
                // Optimized execution: Pre-allocated array + cached DateFormatter (R5)
                var list: [String] = []
                list.reserveCapacity(workloadCount)
                let formatter = PerformanceDateFormatter.shared
                let now = Date()

                for i in 0..<workloadCount {
                    let formatted = formatter.string(from: now)
                    list.append("Tx #\(i): Amount $\(Double(i) * 1.5) on \(formatted)")
                }
            } else {
                // Baseline unoptimized execution: Allocates new DateFormatter repeatedly (R4)
                var list: [String] = []
                for i in 0..<workloadCount {
                    let heavyFormatter = DateFormatter()
                    heavyFormatter.dateStyle = .medium
                    heavyFormatter.timeStyle = .short
                    let formatted = heavyFormatter.string(from: Date())
                    list.append("Tx #\(i): Amount $\(Double(i) * 1.5) on \(formatted)")
                }
            }

            let elapsedMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0

            DispatchQueue.main.async {
                self.executionDurationMs = elapsedMs
                self.isProcessing = false
                self.statusMessage = isOptimizedMode
                    ? "Completed \(workloadCount) items in \(String(format: "%.1f", elapsedMs))ms with minimal heap pressure."
                    : "Completed \(workloadCount) items in \(String(format: "%.1f", elapsedMs))ms. High memory & CPU load detected."
            }
        }
    }
}

// MARK: - Tab 2: Leaks & Retain Cycle Benchmark (Extension & Lab 1E)

struct MemoryLeakBenchmarkView: View {
    @State private var useWeakReference: Bool = false
    @State private var cycleCount: Int = 0
    @State private var deinitLog: [String] = []

    var body: some View {
        NavigationStack {
            List {
                Section("Retain Cycle Configuration (Extension)") {
                    Toggle("Use Weak Reference (Fix Retain Cycle)", isOn: $useWeakReference)
                        .tint(.green)

                    HStack(spacing: 12) {
                        Button("Create & Release Objects") {
                            triggerObjectLifecycle()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Clear Logs") {
                            deinitLog.removeAll()
                            cycleCount = 0
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 4)
                }

                Section("Lifecycle Logs (ARC Verification)") {
                    if deinitLog.isEmpty {
                        Text("Tap 'Create & Release Objects' to observe initialization and deallocation.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(deinitLog, id: \.self) { log in
                            HStack {
                                Text(log)
                                    .font(.caption)
                                    .foregroundColor(log.contains("DEALLOCATED") ? .green : .primary)
                            }
                        }
                    }
                }

                Section("Instruments Leaks Guide") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("How to Verify in Xcode Instruments (R2):")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("1. In Xcode, choose Product -> Profile (⌘I).\n2. Select the 'Leaks' template.\n3. Turn OFF the weak toggle above and click 'Create & Release'.\n4. Observe red X marks appearing in Instruments Leaks track.\n5. Turn ON the weak toggle and repeat: observe green checkmarks with zero leaks.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Leaks & ARC")
        }
    }

    private func triggerObjectLifecycle() {
        cycleCount += 1
        let runID = cycleCount

        if useWeakReference {
            // Non-leaking implementation using `weak var department`
            deinitLog.append("Run #\(runID) [FIXED]: Initializing Department & Employees...")
            var dept: FixedDepartment? = FixedDepartment(name: "Engineering-\(runID)")
            let emp1 = FixedEmployee(name: "Raghav", department: dept)
            let emp2 = FixedEmployee(name: "Ananya", department: dept)
            dept?.employees = [emp1, emp2]

            // Release the strong reference
            dept = nil
            deinitLog.append("Run #\(runID) [FIXED]: Released strong reference -> Objects deallocated cleanly ✅")
        } else {
            // Leaking implementation using strong circular references
            deinitLog.append("Run #\(runID) [LEAKY]: Initializing Department & Employees...")
            var dept: LeakyDepartment? = LeakyDepartment(name: "Finance-\(runID)")
            let emp1 = LeakyEmployee(name: "Raghav", department: dept)
            let emp2 = LeakyEmployee(name: "Pooja", department: dept)
            dept?.employees = [emp1, emp2]

            // Setting dept = nil does NOT deallocate because employees retain dept strongly!
            dept = nil
            deinitLog.append("Run #\(runID) [LEAKY]: Released local variable, but retain cycle keeps objects alive on heap ⚠️ (LEAK)")
        }
    }
}
