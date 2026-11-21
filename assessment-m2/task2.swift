//
//  task2.swift
//  assessment-m2
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training - Milestone 2
//  Task 2: Fetch Two Independent Data Sources Concurrently and Combine Results
//

import Foundation

// ==========================================
// MARK: - 1. INDEPENDENT DATA MODELS
// ==========================================

// Source 1: User's assigned sprint tasks
struct UserTask: Codable, CustomStringConvertible {
    let id: Int
    let title: String
    let status: String
    
    var description: String {
        return "#\(id) [\(status)] \(title)"
    }
}

// Source 2: Organization/Team announcements
struct TeamAnnouncement: Codable, CustomStringConvertible {
    let id: Int
    let message: String
    let department: String
    
    var description: String {
        return "[\(department)] \(message)"
    }
}

// Combined Model: Aggregates both data sources into a single dashboard view
struct CombinedDashboard {
    let tasks: [UserTask]
    let announcements: [TeamAnnouncement]
    let fetchedAt: Date
    let elapsedSeconds: Double
    
    func printSummary() {
        print("\n==============================================")
        print("COMBINED DASHBOARD DATA (Aggregated Result)")
        print("==============================================")
        print("Fetched At: \(fetchedAt)")
        print("Elapsed Time: \(String(format: "%.3f", elapsedSeconds))s")
        print("\n1. User Tasks (\(tasks.count) items):")
        for t in tasks {
            print("   • \(t)")
        }
        print("\n2. Announcements (\(announcements.count) items):")
        for a in announcements {
            print("   • \(a)")
        }
        print("==============================================\n")
    }
}

// ==========================================
// MARK: - 2. MOCK SERVICE WITH REALISTIC DELAYS
// ==========================================

class DashboardService {
    
    // Simulates an API call to /api/user/tasks (takes ~0.5 second)
    func fetchUserTasks() async throws -> [UserTask] {
        let startTime = Date()
        print("  [Network 1 START] Fetching User Tasks...")
        
        // Simulating network latency of 0.5 seconds
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let sampleTasks = [
            UserTask(id: 101, title: "Configure MVVM Architecture", status: "In Progress"),
            UserTask(id: 102, title: "Write Concurrency Unit Tests", status: "Pending"),
            UserTask(id: 103, title: "Review Auto Layout Constraints", status: "Completed")
        ]
        
        let elapsed = Date().timeIntervalSince(startTime)
        print("  [Network 1 DONE ] User Tasks received in \(String(format: "%.2f", elapsed))s")
        return sampleTasks
    }
    
    // Simulates an independent API call to /api/team/announcements (takes ~0.5 second)
    func fetchAnnouncements() async throws -> [TeamAnnouncement] {
        let startTime = Date()
        print("  [Network 2 START] Fetching Team Announcements...")
        
        // Simulating network latency of 0.5 seconds
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let sampleAnnouncements = [
            TeamAnnouncement(id: 1, message: "Sprint Planning at 3:00 PM", department: "Engineering"),
            TeamAnnouncement(id: 2, message: "iOS 18 SDK update guidelines released", department: "Mobile CoE"),
            TeamAnnouncement(id: 3, message: "Milestone 2 Assessment submission due today", department: "Training")
        ]
        
        let elapsed = Date().timeIntervalSince(startTime)
        print("  [Network 2 DONE ] Announcements received in \(String(format: "%.2f", elapsed))s")
        return sampleAnnouncements
    }
}

// ==========================================
// MARK: - 3. CONCURRENT FETCHING IMPLEMENTATIONS
// ==========================================

class DashboardCoordinator {
    private let service = DashboardService()
    
    // -------------------------------------------------------------
    // Approach A: Sequential Fetching (For Comparison & Timing)
    // -------------------------------------------------------------
    // Notice: Network 2 has to wait for Network 1 to finish.
    // Total time = Time(1) + Time(2) ≈ 1.0s
    func fetchSequentially() async throws -> CombinedDashboard {
        print("\n--- APPROACH A: SEQUENTIAL FETCH (One after another) ---")
        let start = Date()
        
        let tasks = try await service.fetchUserTasks()
        let announcements = try await service.fetchAnnouncements()
        
        let totalElapsed = Date().timeIntervalSince(start)
        return CombinedDashboard(tasks: tasks, announcements: announcements, fetchedAt: Date(), elapsedSeconds: totalElapsed)
    }
    
    // -------------------------------------------------------------
    // Approach B: Concurrent Fetching with `async let` (Recommended)
    // -------------------------------------------------------------
    // Swift launches both child tasks simultaneously in the background.
    // We then `await` both results together using tuple destructuring.
    // Total time = max(Time(1), Time(2)) ≈ 0.5s (2x FASTER!)
    func fetchConcurrentlyWithAsyncLet() async throws -> CombinedDashboard {
        print("\n--- APPROACH B: CONCURRENT FETCH USING `async let` ---")
        let start = Date()
        
        // Both async calls start executing concurrently immediately
        async let tasksCall = service.fetchUserTasks()
        async let announcementsCall = service.fetchAnnouncements()
        
        // Await both results together
        let (tasks, announcements) = try await (tasksCall, announcementsCall)
        
        let totalElapsed = Date().timeIntervalSince(start)
        return CombinedDashboard(tasks: tasks, announcements: announcements, fetchedAt: Date(), elapsedSeconds: totalElapsed)
    }
    
    // -------------------------------------------------------------
    // Approach C: Concurrent Fetching with `withThrowingTaskGroup`
    // -------------------------------------------------------------
    // Useful for dynamic lists or when results can be processed as they arrive
    enum FetchResult {
        case tasks([UserTask])
        case announcements([TeamAnnouncement])
    }
    
    func fetchConcurrentlyWithTaskGroup() async throws -> CombinedDashboard {
        print("\n--- APPROACH C: CONCURRENT FETCH USING `withThrowingTaskGroup` ---")
        let start = Date()
        
        let (tasks, announcements) = try await withThrowingTaskGroup(of: FetchResult.self) { group -> ([UserTask], [TeamAnnouncement]) in
            // Add task 1 to group
            group.addTask {
                let items = try await self.service.fetchUserTasks()
                return .tasks(items)
            }
            
            // Add task 2 to group
            group.addTask {
                let items = try await self.service.fetchAnnouncements()
                return .announcements(items)
            }
            
            var collectedTasks: [UserTask] = []
            var collectedAnnouncements: [TeamAnnouncement] = []
            
            // Collect results as each child finishes
            for try await result in group {
                switch result {
                case .tasks(let t):
                    collectedTasks = t
                case .announcements(let a):
                    collectedAnnouncements = a
                }
            }
            
            return (collectedTasks, collectedAnnouncements)
        }
        
        let totalElapsed = Date().timeIntervalSince(start)
        return CombinedDashboard(tasks: tasks, announcements: announcements, fetchedAt: Date(), elapsedSeconds: totalElapsed)
    }
}

// ==========================================
// MARK: - 4. EXECUTION & TIMING BENCHMARK
// ==========================================

Task {
    let coordinator = DashboardCoordinator()
    
    do {
        // 1. Run Sequential
        let seqResult = try await coordinator.fetchSequentially()
        
        // 2. Run Concurrent with async let
        let concurrentResult = try await coordinator.fetchConcurrentlyWithAsyncLet()
        concurrentResult.printSummary()
        
        // 3. Run Concurrent with Task Group
        let groupResult = try await coordinator.fetchConcurrentlyWithTaskGroup()
        
        // 4. Comparison Summary
        print("==================================================")
        print("TIMING BENCHMARK COMPARISON")
        print("==================================================")
        print("Sequential Fetch Time   : \(String(format: "%.3f", seqResult.elapsedSeconds))s")
        print("Concurrent (`async let`): \(String(format: "%.3f", concurrentResult.elapsedSeconds))s")
        print("Concurrent (`TaskGroup`): \(String(format: "%.3f", groupResult.elapsedSeconds))s")
        let speedup = seqResult.elapsedSeconds / concurrentResult.elapsedSeconds
        print("Concurrency Speedup     : \(String(format: "%.1f", speedup))x faster!")
        print("==================================================")
        
    } catch {
        print("Error during fetch: \(error.localizedDescription)")
    }
}

// Allow asynchronous Task to finish execution in command line
RunLoop.main.run(until: Date().addingTimeInterval(3.5))
