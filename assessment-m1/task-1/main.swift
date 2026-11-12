//
//  main.swift
//  task-1
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// gradebook - dictionary of arrays
var gradebook: [String: [Int]] = [
    "Raghav": [85, 90, 88],
    "Priya": [78, 82, 80],
    "Aman": [65, 70, 58]
]

// add score
func addScore(name: String, score: Int) {
    if score < 0 || score > 100 {
        print("Invalid score")
        return
    }

    if gradebook[name] != nil {
        gradebook[name]?.append(score)
    } else {
        gradebook[name] = [score]
    }
}

// get average
func getAverage(name: String) -> Double? {

    guard let scores = gradebook[name], !scores.isEmpty else {
        return nil
    }

    let total = scores.reduce(0, +)
    return Double(total) / Double(scores.count)
}

// grade letter
func getGrade(avg: Double) -> String {
    switch avg {
    case 90...100: return "A+"
    case 80..<90:  return "A"
    case 70..<80:  return "B"
    case 60..<70:  return "C"
    case 33..<60:  return "D"
    default:       return "F"
    }
}

// show report
func showReport(name: String) {
    print("\n--- \(name) ---")

    if let scores = gradebook[name] {
        print("Scores:", scores)
    } else {
        print("Student not found")
        return
    }

    // if let to safely get average
    if let avg = getAverage(name: name) {
        print("Average:", avg)
        print("Grade:", getGrade(avg: avg))
    }

    // nil coalescing for first score
    let first = gradebook[name]?.first ?? 0
    print("First score:", first)
}


// main

print("GRADEBOOK")

showReport(name: "Raghav")
showReport(name: "Priya")
showReport(name: "Aman")

// add new score
print("\nAdding score for Raghav")
addScore(name: "Raghav", score: 95)
showReport(name: "Raghav")

// new student
print("\nNew student")
addScore(name: "Neha", score: 92)
showReport(name: "Neha")

// student not in gradebook
print("\nStudent not found test")
showReport(name: "Karan")

// optional check
let unknown = gradebook["Karan"] ?? []
print("\nKaran scores:", unknown)
