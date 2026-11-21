//
//  task3.swift
//  assessment-m2
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training - Milestone 2
//  Task 3: Demonstrate Loading, Success, Error, and Cancellation States
//

import Foundation

// ==========================================
// MARK: - 1. VIEW STATE ENUM
// ==========================================

// Generic state machine representing the lifecycle of any asynchronous operation
enum ViewState<T: CustomStringConvertible>: CustomStringConvertible {
    case idle
    case loading(message: String)
    case success(data: T)
    case failure(error: String)
    case cancelled(reason: String)
    
    var description: String {
        switch self {
        case .idle:
            return "[STATE: IDLE] Waiting for user action..."
        case .loading(let message):
            return "[STATE: LOADING] ⏳ \(message)"
        case .success(let data):
            return "[STATE: SUCCESS] ✅ Successfully loaded:\n\(data)"
        case .failure(let error):
            return "[STATE: ERROR] ❌ Failed: \(error)"
        case .cancelled(let reason):
            return "[STATE: CANCELLED] ⚠️ Operation halted: \(reason)"
        }
    }
}

// Sample model to be loaded
struct DocumentPayload: CustomStringConvertible {
    let documentId: String
    let fileName: String
    let sizeKb: Int
    
    var description: String {
        return "   • File: \(fileName) (\(sizeKb) KB) | ID: \(documentId)"
    }
}

// ==========================================
// MARK: - 2. STATE CONTROLLER / DATA REPOSITORY
// ==========================================

class DocumentRepository {
    
    // Simulates an async fetch that can succeed, fail, or be cancelled
    func fetchDocument(documentId: String, shouldFail: Bool = false) async throws -> DocumentPayload {
        // Step 1: Check if already cancelled before starting
        try Task.checkCancellation()
        
        // Step 2: Simulating work chunk 1
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s
        
        // Step 3: Check cooperative cancellation mid-flight
        if Task.isCancelled {
            throw CancellationError()
        }
        
        // Step 4: Simulating failure case
        if shouldFail {
            throw NSError(
                domain: "NetworkError",
                code: 503,
                userInfo: [NSLocalizedDescriptionKey: "HTTP 503: Service Unavailable. Database connection failed."]
            )
        }
        
        // Step 5: Simulating work chunk 2
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s
        try Task.checkCancellation()
        
        return DocumentPayload(
            documentId: documentId,
            fileName: "Project_Architecture_Overview.pdf",
            sizeKb: 1420
        )
    }
}

// ==========================================
// MARK: - 3. VIEW MODEL MANAGING STATE
// ==========================================

class DocumentViewModel {
    private let repository = DocumentRepository()
    
    // Observable state property
    private(set) var state: ViewState<DocumentPayload> = .idle {
        didSet {
            // In a UIKit app, this would notify the view or update UI via MainActor
            print(state.description)
        }
    }
    
    // Reference to active Task so it can be cancelled
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Action: Load Document (Demonstrating Loading & Success / Error)
    
    func loadDocument(id: String, simulateFailure: Bool = false) {
        // Cancel any existing in-flight task first
        currentTask?.cancel()
        
        // 1. Transition to LOADING state
        state = .loading(message: "Fetching document #\(id)...")
        
        // 2. Launch asynchronous work
        currentTask = Task {
            do {
                let payload = try await repository.fetchDocument(documentId: id, shouldFail: simulateFailure)
                
                // Check if cancelled before applying success state
                guard !Task.isCancelled else {
                    self.state = .cancelled(reason: "Task was cancelled before completing.")
                    return
                }
                
                // 3. Transition to SUCCESS state
                self.state = .success(data: payload)
                
            } catch is CancellationError {
                // 4. Transition to CANCELLED state
                self.state = .cancelled(reason: "User cancelled or navigated away.")
            } catch {
                // 5. Transition to ERROR state
                self.state = .failure(error: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Action: Cancel Active Request
    
    func cancelCurrentRequest() {
        print(">> User tapped 'Cancel' button.")
        currentTask?.cancel()
    }
}

// ==========================================
// MARK: - 4. SIMULATION DEMONSTRATING ALL 4 STATES
// ==========================================

_ = Task {
    print("==================================================")
    print("DEMONSTRATING ALL 4 ASYNC LIFECYCLE STATES")
    print("==================================================\n")
    
    let viewModel = DocumentViewModel()
    
    // ----------------------------------------------------
    // SCENARIO 1: SUCCESS STATE (Idle -> Loading -> Success)
    // ----------------------------------------------------
    print("--- [SCENARIO 1: SUCCESSFUL FETCH] ---")
    viewModel.loadDocument(id: "DOC-101", simulateFailure: false)
    
    // Wait for Scenario 1 to finish
    try await Task.sleep(nanoseconds: 600_000_000)
    
    // ----------------------------------------------------
    // SCENARIO 2: ERROR STATE (Loading -> Failure)
    // ----------------------------------------------------
    print("\n--- [SCENARIO 2: NETWORK ERROR FETCH] ---")
    viewModel.loadDocument(id: "DOC-404", simulateFailure: true)
    
    // Wait for Scenario 2 to finish
    try await Task.sleep(nanoseconds: 600_000_000)
    
    // ----------------------------------------------------
    // SCENARIO 3: CANCELLATION STATE (Loading -> Cancelled)
    // ----------------------------------------------------
    print("\n--- [SCENARIO 3: COOPERATIVE CANCELLATION] ---")
    viewModel.loadDocument(id: "DOC-999", simulateFailure: false)
    
    // Wait 150ms (while task is still running/sleeping), then cancel it
    try await Task.sleep(nanoseconds: 150_000_000)
    viewModel.cancelCurrentRequest()
    
    // Wait for cancellation to settle
    try await Task.sleep(nanoseconds: 400_000_000)
    
    print("\n==================================================")
    print("ALL 4 STATES DEMONSTRATED SUCCESSFULLY:")
    print("  1. Idle       - Initial state before request")
    print("  2. Loading    - Progress indication while waiting")
    print("  3. Success    - Safe parsing & display of data")
    print("  4. Error      - Clean error handling with retry")
    print("  5. Cancelled  - Cooperative cancellation via Task.cancel()")
    print("==================================================")
}

// Keep program running for async execution
RunLoop.main.run(until: Date().addingTimeInterval(2.5))
