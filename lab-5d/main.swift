//
//  main.swift
//  lab-5d
//
//  Created by Raghav Gupta on 17/11/26.
//

import Foundation

// 1. Unsafe Counter (Before)
// A regular class without any synchronization.
// When multiple threads increment this counter at the same time,
// they overwrite each other's work (data race).
final class UnsafeCounter: @unchecked Sendable {
    private var value = 0
    
    func increment() {
        // Not thread safe: reading and writing happen simultaneously across threads
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}

// 2. Safe Counter using an Actor (After)
// Swift actors ensure that only one task can access their mutable state at a time.
actor SafeCounter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}

// 3. Alternative fix using NSLock
// Another classic way to synchronize access using a lock.
final class LockedCounter: @unchecked Sendable {
    private var value = 0
    private let lock = NSLock()
    
    func increment() {
        lock.lock()
        value += 1
        lock.unlock()
    }
    
    func getValue() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
}

// Helper to run concurrent increments on the unsafe counter
func testUnsafe(numTasks: Int, incrementsPerTask: Int) async -> Int {
    let counter = UnsafeCounter()
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<numTasks {
            group.addTask {
                for _ in 0..<incrementsPerTask {
                    counter.increment()
                }
            }
        }
    }
    return counter.getValue()
}

// Helper to run concurrent increments on the actor safe counter
func testSafe(numTasks: Int, incrementsPerTask: Int) async -> Int {
    let counter = SafeCounter()
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<numTasks {
            group.addTask {
                for _ in 0..<incrementsPerTask {
                    await counter.increment()
                }
            }
        }
    }
    return await counter.getValue()
}

// Helper to run concurrent increments on the lock safe counter
func testLocked(numTasks: Int, incrementsPerTask: Int) async -> Int {
    let counter = LockedCounter()
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<numTasks {
            group.addTask {
                for _ in 0..<incrementsPerTask {
                    counter.increment()
                }
            }
        }
    }
    return counter.getValue()
}

func runLab5D() async {
    print("    Lab 5D    ")
    
    let tasks = 100
    let increments = 100
    let expected = tasks * increments // 10,000 expected increments
    
    print("Running \(tasks) tasks, each incrementing \(increments) times.")
    print("Expected total: \(expected)\n")
    
    // Part 1: Observe unsafe behavior
    print("1. Testing Unsafe Counter (Class with no synchronization)...")
    let unsafeCount = await testUnsafe(numTasks: tasks, incrementsPerTask: increments)
    let lost = expected - unsafeCount
    print("   Result: \(unsafeCount) / \(expected)")
    print("   Lost increments: \(lost)")
    if unsafeCount < expected {
        print("   Notice: Increments were lost due to a data race!\n")
    } else {
        print("   Counter matched (data races are non-deterministic).\n")
    }
    
    // Part 2: Fix with Actor
    print("2. Testing Safe Counter (using Swift Actor)...")
    let safeCount = await testSafe(numTasks: tasks, incrementsPerTask: increments)
    print("   Result: \(safeCount) / \(expected)")
    print("   Lost increments: \(expected - safeCount)")
    print("   Notice: The actor serializes access so no increments are lost.\n")
    
    // Part 3: Alternative with NSLock
    print("3. Testing Safe Counter (using NSLock)...")
    let lockedCount = await testLocked(numTasks: tasks, incrementsPerTask: increments)
    print("   Result: \(lockedCount) / \(expected)")
    print("   Lost increments: \(expected - lockedCount)")
    print("   Notice: NSLock also protects mutable state successfully.\n")
    
    // Extension: Repeated stress test
    print("4. Extension: Running 10 repeated trials to verify consistency...")
    var unsafeFails = 0
    var safePasses = 0
    
    for i in 1...10 {
        let u = await testUnsafe(numTasks: tasks, incrementsPerTask: increments)
        let s = await testSafe(numTasks: tasks, incrementsPerTask: increments)
        
        if u < expected { unsafeFails += 1 }
        if s == expected { safePasses += 1 }
        
        print("   Trial #\(i): Unsafe = \(u), Actor = \(s)")
    }
    
    print("\nStress Test Summary:")
    print("   - Unsafe counter had data races in \(unsafeFails) of 10 trials")
    print("   - Actor counter was correct in \(safePasses) of 10 trials")
    print("\nComplete")
}

let semaphore = DispatchSemaphore(value: 0)
Task {
    await runLab5D()
    semaphore.signal()
}
semaphore.wait()
