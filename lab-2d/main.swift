//
//  main.swift
//  lab-2d
//
//  Created by Raghav Gupta on 11/11/26.
//

import Foundation

// MARK: error enum

enum ValidationError: Error {
    case emptyName
    case invalidMark
    case invalidID
}

// MARK: registration

func registerStudent(name: String, marks: Int, id: Int) throws {

    if name.isEmpty {
        throw ValidationError.emptyName
    }

    if marks < 0 || marks > 100 {
        throw ValidationError.invalidMark
    }

    if id <= 0 {
        throw ValidationError.invalidID
    }

    print("Student Registered Successfully!")
    print("Name:", name)
    print("Marks:", marks)
    print("ID:", id)
}

// MARK: error handling

func testRegistration(name: String, marks: Int, id: Int) {

    do {
        try registerStudent(name: name, marks: marks, id: id)
    }

    catch ValidationError.emptyName {
        print("Error: Name cannot be empty.")
    }

    catch ValidationError.invalidMark {
        print("Error: Marks should be between 0 and 100.")
    }

    catch ValidationError.invalidID {
        print("Error: ID should be greater than zero.")
    }

    catch {
        print("Something went wrong.")
    }
}

// MARK: tests

print("STUDENT REGISTRATION")

print("\nTest 1")
testRegistration(name: "Raghav", marks: 90, id: 101)

print("\nTest 2")
testRegistration(name: "", marks: 80, id: 102)

print("\nTest 3")
testRegistration(name: "Riya", marks: 120, id: 103)

print("\nTest 4")
testRegistration(name: "Shravan", marks: 85, id: 0)


// MARK: optional return

func checkName(name: String) -> String? {

    if name.isEmpty {
        return nil
    }

    return name
}

print("\nOPTIONAL EXAMPLE")

if let result = checkName(name: "Raghav") {
    print("Valid Name:", result)
} else {
    print("Name is empty")
}


// MARK: result example

func checkMarks(marks: Int) -> Result<Int, ValidationError> {

    if marks < 0 || marks > 100 {
        return .failure(.invalidMark)
    }

    return .success(marks)
}

print("\nRESULT EXAMPLE")

let result = checkMarks(marks: 90)

switch result {

case .success(let marks):
    print("Valid Marks:", marks)

case .failure(.invalidMark):
    print("Invalid Marks")
    
case .failure(.emptyName):
    print("Name is empty")

case .failure(.invalidID):
    print("Invalid ID")
}


// MARK: 7. network response

enum NetworkError: Error {
    case serverError
}

func getData() -> Result<String, NetworkError> {

    // Simulating network response
    let success = true

    if success {
        return .success("Data received successfully")
    } else {
        return .failure(.serverError)
    }
}

print("\nNETWORK RESPONSE")

let response = getData()

switch response {

case .success(let message):
    print(message)

case .failure(.serverError):
    print("Unable to connect to server. Please try again.")
}


