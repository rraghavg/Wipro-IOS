//
//  task4.swift
//  assessment-m2
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training - Milestone 2
//  Task 4: Explain Why UI Updates Belong on the Main Actor / Main Queue
//

import Foundation

// ==========================================
// MARK: - 1. THREAD INSPECTION UTILITIES
// ==========================================

func printThreadInfo(tag: String) {
    let isMain = Thread.isMainThread
    let threadDesc = isMain ? "🟢 MAIN THREAD (UI Safe)" : "🔵 BACKGROUND THREAD (Worker)"
    print("[\(tag)] Current Thread: \(threadDesc) | Thread Object: \(Thread.current)")
}

// ==========================================
// MARK: - 2. SIMULATED UI COMPONENT
// ==========================================

// In UIKit, all UIView and UIViewController classes are marked with @MainActor.
// Here we simulate a UI label that should ONLY be updated on the main thread.
@MainActor
class ProfileStatusView {
    var titleText: String = "Initial Title"
    var isSpinnerAnimating: Bool = false
    
    func updateTitle(_ newTitle: String) {
        // Confirming that we are strictly executing on the Main Thread
        assert(Thread.isMainThread, "CRITICAL ERROR: UI update called from background thread!")
        self.titleText = newTitle
        print("  -> UI Updated Successfully on Main Thread: '\(newTitle)'")
    }
    
    func setSpinner(animating: Bool) {
        assert(Thread.isMainThread, "CRITICAL ERROR: Spinner toggled from background thread!")
        self.isSpinnerAnimating = animating
        let state = animating ? "Spinning..." : "Stopped"
        print("  -> UI Spinner State: \(state)")
    }
}

// ==========================================
// MARK: - 3. BACKGROUND SERVICE (HEAVY COMPUTATION)
// ==========================================

class DataSyncService {
    
    // Simulates an intensive background task (e.g., parsing large JSON, image filter)
    nonisolated func performHeavySync() async -> String {
        printThreadInfo(tag: "Heavy Work Start")
        
        // Simulating 300ms of intensive parsing
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        printThreadInfo(tag: "Heavy Work Complete")
        return "Synced 1,250 records successfully"
    }
}

// ==========================================
// MARK: - 4. APPROACH COMPARISON: GCD VS @MainActor
// ==========================================

class SyncCoordinator {
    private let syncService = DataSyncService()
    
    // -----------------------------------------------------------------
    // PATTERN 1: Legacy GCD (Grand Central Dispatch)
    // -----------------------------------------------------------------
    // In older iOS code, developers had to manually remember to wrap UI code
    // inside `DispatchQueue.main.async`. If forgotten, Xcode would crash or glitch!
    func runWithLegacyGCD(uiView: ProfileStatusView) {
        print("\n--- [PATTERN 1: LEGACY GCD (DispatchQueue)] ---")
        
        DispatchQueue.global(qos: .userInitiated).async {
            printThreadInfo(tag: "GCD Background Queue")
            
            // Heavy background work
            Thread.sleep(forTimeInterval: 0.2)
            let result = "Result from GCD background thread"
            
            // MUST manually dispatch back to main thread for UI
            DispatchQueue.main.async {
                printThreadInfo(tag: "GCD Main Queue Dispatch")
                uiView.updateTitle(result)
            }
        }
    }
    
    // -----------------------------------------------------------------
    // PATTERN 2: Modern Swift Concurrency (@MainActor)
    // -----------------------------------------------------------------
    // In modern Swift, the compiler itself enforces that calls to @MainActor
    // classes or methods must be awaited from the main actor.
    // The compiler prevents thread violation bugs at COMPILE TIME!
    func runWithModernMainActor(uiView: ProfileStatusView) async {
        print("\n--- [PATTERN 2: MODERN SWIFT CONCURRENCY (@MainActor)] ---")
        printThreadInfo(tag: "Coordinator Function Entry")
        
        // Step 1: Update UI to show loading (on main actor)
        await uiView.setSpinner(animating: true)
        
        // Step 2: Offload heavy computation to background cooperative thread
        let result = await syncService.performHeavySync()
        
        // Step 3: Switch back to MainActor for UI presentation
        await MainActor.run {
            printThreadInfo(tag: "Inside MainActor.run")
            uiView.updateTitle(result)
            uiView.setSpinner(animating: false)
        }
    }
}

// ==========================================
// MARK: - 5. DEMO EXECUTION
// ==========================================

_ = Task {
    print("==================================================")
    print("WHY UI UPDATES BELONG ON THE MAIN THREAD / MAIN ACTOR")
    print("==================================================")
    
    let uiView = await ProfileStatusView()
    let coordinator = SyncCoordinator()
    
    // 1. Run Modern Swift Concurrency Approach
    await coordinator.runWithModernMainActor(uiView: uiView)
    
    // 2. Run Legacy GCD Approach
    coordinator.runWithLegacyGCD(uiView: uiView)
    
    // Wait for GCD block to finish
    try? await Task.sleep(nanoseconds: 500_000_000)
    
    print("\n==================================================")
    print("KEY TAKEAWAYS FOR FACULTY & INTERVIEW:")
    print("1. Thread Safety: UIKit is NOT thread-safe to avoid lock overhead.")
    print("2. RunLoop Sync : The Main RunLoop coordinates user touches, layout passes,")
    print("                  and screen refresh (60Hz/120Hz).")
    print("3. Memory Safety: Updating views from multiple threads causes race conditions")
    print("                  and heap memory corruption (EXC_BAD_ACCESS).")
    print("4. Modern Swift : Use @MainActor so the compiler prevents background UI")
    print("                  mutations at compile time instead of crashing at runtime.")
    print("==================================================")
}

// Run loop to let async and GCD finish
RunLoop.main.run(until: Date().addingTimeInterval(1.5))
