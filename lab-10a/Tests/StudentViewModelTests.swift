//
//  StudentViewModelTests.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  XCTest suite covering view model operations, dependency injection, and async testing (R2, R4, R5, Extension)
//

import XCTest
#if canImport(Lab10A)
@testable import Lab10A
#endif

final class StudentViewModelTests: XCTestCase {

    var mockService: MockStudentService!
    var sut: StudentViewModel!

    override func setUp() {
        super.setUp()
        // R5: Instantiate and inject fake service with deterministic data
        mockService = MockStudentService()
        sut = StudentViewModel(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Initial State Test

    func testInitialViewModelState() {
        XCTAssertTrue(sut.students.isEmpty, "Students array should initially be empty")
        XCTAssertFalse(sut.isLoading, "ViewModel should not be loading initially")
        XCTAssertNil(sut.errorMessage, "No error should exist on init")
    }

    // MARK: - ViewModel Operations (R2)

    func testHonorRollFilteringOperation() {
        // Arrange: Populate with test students
        sut.students = [
            Student(id: "1", name: "High Achiever", score: 95.0, isBookmarked: false),
            Student(id: "2", name: "Average Student", score: 78.0, isBookmarked: false),
            Student(id: "3", name: "Honor Roll Exact", score: 90.0, isBookmarked: false),
            Student(id: "4", name: "Below Cutoff", score: 89.9, isBookmarked: false)
        ]

        // Act
        let honorRoll = sut.honorRollStudents()

        // Assert (R4: Meaningful assertions)
        XCTAssertEqual(honorRoll.count, 2, "Only 2 students met the >= 90.0 honor roll criteria")
        XCTAssertTrue(honorRoll.contains(where: { $0.id == "1" }))
        XCTAssertTrue(honorRoll.contains(where: { $0.id == "3" }))
        XCTAssertFalse(honorRoll.contains(where: { $0.id == "4" }), "89.9 must not be included in honor roll")
    }

    func testToggleBookmarkOperation() {
        // Arrange
        sut.students = [
            Student(id: "S01", name: "Raghav Gupta", score: 94.0, isBookmarked: false)
        ]

        // Act 1: Toggle on
        sut.toggleBookmark(studentID: "S01")

        // Assert
        XCTAssertTrue(sut.students[0].isBookmarked, "Bookmarked flag should be true after first toggle")

        // Act 2: Toggle off
        sut.toggleBookmark(studentID: "S01")

        // Assert
        XCTAssertFalse(sut.students[0].isBookmarked, "Bookmarked flag should return to false after second toggle")
    }

    // MARK: - Async Service Injection with Mocked Data (Extension & R5)

    func testAsyncLoadStudentsSuccess() async {
        // Ensure mock service is configured for success
        mockService.shouldFail = false

        // Act: Execute async fetch
        await sut.loadStudents()

        // Assert
        XCTAssertEqual(sut.students.count, 4, "Should load exactly 4 mocked students")
        XCTAssertEqual(sut.students.first?.name, "Raghav Gupta")
        XCTAssertFalse(sut.isLoading, "Loading state must reset to false upon completion")
        XCTAssertNil(sut.errorMessage, "ErrorMessage must be nil on success")
    }

    func testAsyncLoadStudentsFailureHandling() async {
        // Arrange: Inject deterministic failure into mock service
        mockService.shouldFail = true

        // Act
        await sut.loadStudents()

        // Assert
        XCTAssertTrue(sut.students.isEmpty, "Students array must remain empty when service fails")
        XCTAssertFalse(sut.isLoading, "Loading state must reset to false after failure")
        XCTAssertNotNil(sut.errorMessage, "ErrorMessage should capture the service failure")
    }
}
