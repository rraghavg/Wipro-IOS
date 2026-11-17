//
//  main.swift
//  lab-5c
//
//  Created by Raghav Gupta on 17/11/26.
//

import Foundation

// Simple model to hold course information
struct Course {
    let id: String
    let title: String
}

enum FetchError: Error {
    case notFound(String)
}

// Simulates an async network call to get course details
func fetchCourseDetails(id: String, shouldFail: Bool = false) async throws -> Course {
    // Simulate network delay (1 second)
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Check if task was cancelled while sleeping
    try Task.checkCancellation()
    
    if shouldFail {
        throw FetchError.notFound(id)
    }
    
    let catalog = [
        "CS101": "Introduction to Swift",
        "CS102": "iOS UI Development",
        "CS103": "Async/Await & Concurrency",
        "CS104": "Data Persistence with CoreData"
    ]
    
    let title = catalog[id] ?? "Unknown Course"
    return Course(id: id, title: title)
}

// 1. Sequential fetch (fetching courses one after another)
func fetchSequentially(courseIDs: [String]) async throws -> [Course] {
    var courses: [Course] = []
    for id in courseIDs {
        let course = try await fetchCourseDetails(id: id)
        courses.append(course)
    }
    return courses
}

// 2. Concurrent fetch using TaskGroup
func fetchConcurrently(courseIDs: [String]) async throws -> [Course] {
    try await withThrowingTaskGroup(of: Course.self) { group in
        for id in courseIDs {
            group.addTask {
                return try await fetchCourseDetails(id: id)
            }
        }
        
        var courses: [Course] = []
        for try await course in group {
            courses.append(course)
        }
        return courses
    }
}

// 3. Handling failures: Return partial results if one fails
func fetchWithPartialResults(courseIDs: [String], failID: String) async -> [Course] {
    await withTaskGroup(of: Course?.self) { group in
        for id in courseIDs {
            let willFail = (id == failID)
            group.addTask {
                do {
                    return try await fetchCourseDetails(id: id, shouldFail: willFail)
                } catch {
                    print("  [Warning] Failed to fetch \(id): \(error)")
                    return nil // Return nil so other child tasks can still succeed
                }
            }
        }
        
        var results: [Course] = []
        for await course in group {
            if let course = course {
                results.append(course)
            }
        }
        return results
    }
}

// Extension: Batch fetching with max concurrency limit
func fetchInBatches(courseIDs: [String], batchSize: Int) async throws -> [Course] {
    var allCourses: [Course] = []
    
    var startIndex = 0
    while startIndex < courseIDs.count {
        let endIndex = min(startIndex + batchSize, courseIDs.count)
        let batch = Array(courseIDs[startIndex..<endIndex])
        
        print("  Processing batch: \(batch)")
        let batchResults = try await fetchConcurrently(courseIDs: batch)
        allCourses.append(contentsOf: batchResults)
        
        startIndex += batchSize
    }
    
    return allCourses
}

// Run our tests
func runTests() async {
    let ids = ["CS101", "CS102", "CS103", "CS104"]
    
    print("LAB 5C")
    print("Testing with courses: \(ids)\n")
    
    // Test 1: Sequential fetch
    print("1. Running Sequential Fetch...")
    let seqStart = Date()
    do {
        let seqCourses = try await fetchSequentially(courseIDs: ids)
        let seqTime = Date().timeIntervalSince(seqStart)
        print("Fetched \(seqCourses.count) courses:")
        for c in seqCourses {
            print("  - \(c.id): \(c.title)")
        }
        print(String(format: "Sequential time: %.2f seconds\n", seqTime))
    } catch {
        print("Sequential fetch failed: \(error)\n")
    }
    
    // Test 2: Concurrent Task Group fetch
    print("2. Running Concurrent Fetch (TaskGroup)...")
    let conStart = Date()
    do {
        let conCourses = try await fetchConcurrently(courseIDs: ids)
        let conTime = Date().timeIntervalSince(conStart)
        print("Fetched \(conCourses.count) courses:")
        for c in conCourses {
            print("  - \(c.id): \(c.title)")
        }
        print(String(format: "Concurrent time: %.2f seconds\n", conTime))
    } catch {
        print("Concurrent fetch failed: \(error)\n")
    }
    
    // Test 3: Child task failure (Handling partial results)
    print("3. Testing Child Task Failure (CS102 will fail)...")
    let partialCourses = await fetchWithPartialResults(courseIDs: ids, failID: "CS102")
    print("Successfully retrieved \(partialCourses.count) courses despite failure:")
    for c in partialCourses {
        print("  - \(c.id): \(c.title)")
    }
    print("Notice: The failure of CS102 did not cancel the other courses.\n")
    
    // Test 4: Extension - Batch processing with max concurrency of 2
    print("4. Extension: Fetching with Max Concurrency Limit (batch size = 2)...")
    let batchStart = Date()
    do {
        let batchCourses = try await fetchInBatches(courseIDs: ids, batchSize: 2)
        let batchTime = Date().timeIntervalSince(batchStart)
        print("Batch fetch finished with \(batchCourses.count) courses in \(String(format: "%.2f", batchTime))s\n")
    } catch {
        print("Batch fetch failed: \(error)\n")
    }
    
    print("Complete")
}

let semaphore = DispatchSemaphore(value: 0)
Task {
    await runTests()
    semaphore.signal()
}
semaphore.wait()
