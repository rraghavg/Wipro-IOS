//
//  main.swift
//  lab-1d
//
//  Created by Raghav Gupta on 06/11/26.
//

import Foundation

// stu mark dictionary
var marks = [
    101: 85,
    102: 90,
    103: 75,
    104: 95
]

// Ffunc to search marks by stuid
func findMarks(id: Int) -> Int? {

    return marks[id]
}

// MARK: - if let

print("      IF LET")

let studentMarks = findMarks(id: 101)

if let result = studentMarks {
    print("Student Marks:", result)
}
else {
    print("Student Not Found")
}


// MARK: - guard let

print("\n      GUARD LET ")

func checkStudent(id: Int) {

    guard let result = findMarks(id: id) else {
        print("student not found")
        return
    }

    print("marks:", result)
}

checkStudent(id: 102)
checkStudent(id: 110)


// MARK: - optional chaining

print("\n      optional chaining")

let studentName: String? = "Raghav"

let nameLength = studentName?.count

print("name length :", nameLength as Any)

let missingName: String? = nil

print("missing NL:", missingName?.count as Any)


// MARK: - nil coalescing

print("\n      nil coalescing")

let city: String? = nil

let finalCity = city ?? "Mathura"

print("student city :", finalCity)


// MARK: - empty text firld

print("\n      empty text field")

let inputText = "   "

if inputText.trimmingCharacters(in: .whitespaces).isEmpty {
    print("enter name")
}
else {
    print("Student name:", inputText)
}


// MARK: - student profile

print("\n      student profile")

struct StudentProfile {

    var name: String
    var address: String?
    var phone: String?

    func showProfile() {

        print("Name:", name)
        print("Address:", address ?? "Not Available")
        print("Phone:", phone ?? "Not Available")
    }
}

let student1 = StudentProfile(
    name: "Raghav",
    address: "Mathura",
    phone: nil
)

student1.showProfile()



