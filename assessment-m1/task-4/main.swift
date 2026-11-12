//
//  main.swift
//  task-4
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// MARK: errors

enum RegistrationError: Error {
    case emptyName
    case invalidScore
    case invalidID
}

// MARK: validation func

func registerStudent(name: String, score: Int, id: Int) throws {

    if name.isEmpty {
        throw RegistrationError.emptyName
    }

    if score < 0 || score > 100 {
        throw RegistrationError.invalidScore
    }

    if id <= 0 {
        throw RegistrationError.invalidID
    }

    print("Registered:", name, "| Score:", score, "| ID:", id)
}

// MARK: error handling

func tryRegister(name: String, score: Int, id: Int) {
    do {
        try registerStudent(name: name, score: score, id: id)
    }
    catch RegistrationError.emptyName {
        print("Error: name is empty")
    }
    catch RegistrationError.invalidScore {
        print("Error: score should be 0-100")
    }
    catch RegistrationError.invalidID {
        print("Error: id should be greater than 0")
    }
    catch {
        print("Something went wrong")
    }
}

// MARK: tests

print("REGISTRATION TESTS")

print("\nTest 1 - valid")
tryRegister(name: "Raghav", score: 90, id: 101)

print("\nTest 2 - empty name")
tryRegister(name: "", score: 85, id: 102)

print("\nTest 3 - invalid score")
tryRegister(name: "Priya", score: 120, id: 103)

print("\nTest 4 - invalid id")
tryRegister(name: "Aman", score: 75, id: -1)


// try? - returns nil if error
print("\nUsing try?")

let result: ()? = try? registerStudent(name: "Neha", score: 88, id: 104)
print("Result:", result != nil ? "success" : "nil")

let failed: ()? = try? registerStudent(name: "", score: 88, id: 104)
print("Failed result:", String(describing: failed))
