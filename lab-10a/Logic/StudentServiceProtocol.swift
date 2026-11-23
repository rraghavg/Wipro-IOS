//
//  StudentServiceProtocol.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  Protocol for dependency injection (R5) and deterministic mocked service (Extension)
//

import Foundation

struct Student: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let score: Double
    var isBookmarked: Bool
}

protocol StudentServiceProtocol {
    func fetchStudents() async throws -> [Student]
}

// R5: Mock service returning deterministic fake data for testing without live network
class MockStudentService: StudentServiceProtocol {
    var shouldFail: Bool = false
    var mockStudents: [Student] = [
        Student(id: "S01", name: "Raghav Gupta", score: 94.0, isBookmarked: false),
        Student(id: "S02", name: "Ananya Sharma", score: 88.5, isBookmarked: true),
        Student(id: "S03", name: "Rahul Verma", score: 67.0, isBookmarked: false),
        Student(id: "S04", name: "Pooja Patel", score: 91.0, isBookmarked: false)
    ]

    func fetchStudents() async throws -> [Student] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return mockStudents
    }
}
