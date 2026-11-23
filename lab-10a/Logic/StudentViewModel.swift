//
//  StudentViewModel.swift
//  lab-10a
//
//  Created by Raghav Gupta
//  Wipro iOS Developer Training — Lab 10A
//  ViewModel managing student data, filtering honor roll, and bookmarking.
//

import Foundation
import Combine

class StudentViewModel: ObservableObject {
    @Published var students: [Student] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service: StudentServiceProtocol

    // R5: Dependency injection of service protocol
    init(service: StudentServiceProtocol = MockStudentService()) {
        self.service = service
    }

    // Async operation using injected service (Extension)
    func loadStudents() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let fetched = try await service.fetchStudents()
            await MainActor.run {
                self.students = fetched
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    // Operation 1: Filter Honor Roll (Score >= 90)
    func honorRollStudents() -> [Student] {
        return students.filter { $0.score >= 90.0 }
    }

    // Operation 2: Toggle Bookmark
    func toggleBookmark(studentID: String) {
        if let idx = students.firstIndex(where: { $0.id == studentID }) {
            students[idx].isBookmarked.toggle()
        }
    }
}
