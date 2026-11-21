//
//  task5.swift
//  assessment-m2
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training - Milestone 2
//  Task 5: Viva Preparation - Comparative Analysis of GCD, async/await, Task, and Task Groups
//

import Foundation

// ==========================================
// MARK: - 1. PROBLEM STATEMENT FOR COMPARISON
// ==========================================
// We will fetch 3 simulated items (Order Details, User Rating, Shipping Status)
// and demonstrate how each of the 4 concurrency models handles:
// 1. Thread execution
// 2. Error propagation
// 3. Syntax & readability
// 4. Concurrency coordination

struct ItemSummary: CustomStringConvertible {
    let name: String
    let duration: Double
    
    var description: String {
        return "\(name) (took \(String(format: "%.2f", duration))s)"
    }
}

// ==========================================
// MARK: - 2. MODEL 1: GRAND CENTRAL DISPATCH (GCD)
// ==========================================
// Historical C-based API (libdispatch).
// Uses queues (serial / concurrent) and completion closures.

class GCDDemo {
    func runDemo(completion: @escaping ([ItemSummary]) -> Void) {
        print("\n--- 1. GRAND CENTRAL DISPATCH (GCD) ---")
        let startTime = Date()
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        var results: [ItemSummary] = []
        let lock = NSLock() // Needed to prevent race condition when appending to array
        
        let itemNames = ["Order Details", "User Rating", "Shipping Status"]
        
        for name in itemNames {
            group.enter()
            queue.async {
                // Simulate network latency of 0.2s
                Thread.sleep(forTimeInterval: 0.2)
                let elapsed = Date().timeIntervalSince(startTime)
                let item = ItemSummary(name: name, duration: elapsed)
                
                lock.lock()
                results.append(item)
                lock.unlock()
                
                group.leave()
            }
        }
        
        // Notify when all 3 concurrent blocks finish
        group.notify(queue: .main) {
            let totalTime = Date().timeIntervalSince(startTime)
            print("  [GCD Group Finished] Total time: \(String(format: "%.3f", totalTime))s")
            for item in results {
                print("    • \(item)")
            }
            completion(results)
        }
    }
}

// ==========================================
// MARK: - 3. MODEL 2: async / await (Coroutines)
// ==========================================
// Language-level coroutines introduced in Swift 5.5.
// Suspends execution at suspension points (`await`) without blocking the underlying thread.

class AsyncAwaitDemo {
    private func fetchSingleItem(name: String) async -> ItemSummary {
        let start = Date()
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s
        let elapsed = Date().timeIntervalSince(start)
        return ItemSummary(name: name, duration: elapsed)
    }
    
    func runDemo() async -> [ItemSummary] {
        print("\n--- 2. async / await (Sequential vs async let) ---")
        let start = Date()
        
        // Using `async let` for fixed-arity concurrency
        async let item1 = fetchSingleItem(name: "Order Details")
        async let item2 = fetchSingleItem(name: "User Rating")
        async let item3 = fetchSingleItem(name: "Shipping Status")
        
        let results = await [item1, item2, item3]
        let totalTime = Date().timeIntervalSince(start)
        print("  [async let Finished] Total time: \(String(format: "%.3f", totalTime))s")
        for item in results {
            print("    • \(item)")
        }
        return results
    }
}

// ==========================================
// MARK: - 4. MODEL 3: Task & Unstructured Concurrency
// ==========================================
// `Task` creates a new asynchronous context from synchronous code.
// Inherits actor context, priority, and task-local values.
// Supports cooperative cancellation via `task.cancel()`.

class TaskDemo {
    func runDemo() async {
        print("\n--- 3. Task (Lifecycle & Cooperative Cancellation) ---")
        
        // Creating an explicit Task handle
        let backgroundJob = Task(priority: .medium) { () -> String in
            print("  [Task Started] Priority: \(Task.currentPriority)")
            
            // Step 1: Work chunk
            try await Task.sleep(nanoseconds: 100_000_000)
            
            // Check cancellation
            if Task.isCancelled {
                print("  [Task Notification] Cancellation noticed before step 2!")
                throw CancellationError()
            }
            
            return "Task completed successfully"
        }
        
        do {
            let value = try await backgroundJob.value
            print("  [Task Result]: \(value)")
        } catch {
            print("  [Task Caught]: \(error)")
        }
    }
}

// ==========================================
// MARK: - 5. MODEL 4: Task Groups (Structured Concurrency)
// ==========================================
// Used when the number of concurrent jobs is dynamic (e.g., an array of URLs).
// Spawns child tasks scoped to the group block.
// If one child throws an error, sibling tasks are automatically cancelled!

class TaskGroupDemo {
    func runDemo() async throws -> [ItemSummary] {
        print("\n--- 4. Task Groups (Dynamic Structured Concurrency) ---")
        let start = Date()
        let itemsToFetch = ["Order Details", "User Rating", "Shipping Status"]
        
        let results = try await withThrowingTaskGroup(of: ItemSummary.self) { group -> [ItemSummary] in
            // Dynamically add a child task for each element in the array
            for name in itemsToFetch {
                group.addTask {
                    let taskStart = Date()
                    try await Task.sleep(nanoseconds: 200_000_000)
                    return ItemSummary(name: name, duration: Date().timeIntervalSince(taskStart))
                }
            }
            
            // Dynamically collect results as each finishes
            var collected: [ItemSummary] = []
            for try await item in group {
                collected.append(item)
            }
            return collected
        }
        
        let totalTime = Date().timeIntervalSince(start)
        print("  [Task Group Finished] Total time: \(String(format: "%.3f", totalTime))s")
        for item in results {
            print("    • \(item)")
        }
        return results
    }
}

// ==========================================
// MARK: - 6. ORCHESTRATION & VIVA SUMMARY
// ==========================================

_ = Task {
    print("==================================================")
    print("VIVA COMPARISON: GCD vs async/await vs Task vs Task Groups")
    print("==================================================")
    
    // 1. Run async/await
    let asyncDemo = AsyncAwaitDemo()
    _ = await asyncDemo.runDemo()
    
    // 2. Run Task demo
    let taskDemo = TaskDemo()
    await taskDemo.runDemo()
    
    // 3. Run Task Group demo
    let groupDemo = TaskGroupDemo()
    _ = try? await groupDemo.runDemo()
    
    // 4. Run GCD demo
    let gcdDemo = GCDDemo()
    gcdDemo.runDemo { _ in
        print("\n==================================================")
        print("VIVA CHEAT SHEET SUMMARY:")
        print("--------------------------------------------------")
        print("Feature        | GCD               | async/await   | Task Groups")
        print("---------------|-------------------|---------------|-----------------")
        print("Model          | Thread/Queue API  | Coroutines    | Structured Tree")
        print("Readability    | Callback closures | Linear code   | Linear async loop")
        print("Thread Control | Thread explosion  | Fixed pool    | Fixed pool")
        print("Error Handling | Result enum / err | try / catch   | try / catch")
        print("Cancellation   | Manual flags      | Cooperative   | Auto child cancel")
        print("==================================================")
    }
}

// RunLoop to keep process alive for completion
RunLoop.main.run(until: Date().addingTimeInterval(2.0))
