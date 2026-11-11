//
//  main.swift
//  lab-2b
//
//  Created by Raghav Gupta on 11/11/26.
import Foundation

// MARK: sort

let students = [
    ("Riya", 85),
    ("Shravan", 90),
    ("Raghav", 75),
    ("Pihu", 95)
]

// $0 is 1st student and $1 is 2nd student
let sortedStudents = students.sorted {
    $0.1 > $1.1
}

print("Sorted:")

for student in sortedStudents {
    print(student.0, student.1)
}


// MARK: completion

func downloadFile(completion: () -> Void) {

    print("\nFile Downloading...")
    print("Download completed!")

    // call closure after completing
    completion()
}

downloadFile {
    print("File is ready.")
}


// MARK: trailing

let numbers = [10, 20, 30, 40, 50]

// $0 represents each number
let result = numbers.filter {
    $0 > 20
}

print("\nNumbers are > 20:", result)


// MARK: closure with exlipit

let result2 = numbers.filter { number in
    return number > 20
}

print("Using explicit name:", result2)


// MARK: counter

func createCounter() -> () -> Int {

    var count = 0

    let counter = {
        count = count + 1
        return count
    }

    return counter
}

let myCounter = createCounter()

print("\nCounter:")
print(myCounter())
print(myCounter())
print(myCounter())


// MARK: avoid retain

class Student {

    var name = "Raghav"

    var showName: (() -> Void)?

    func setup() {

        showName = { [weak self] in

            if let student = self {
                print("\nStudent:", student.name)
            }
        }
    }

    deinit {
        print("Student object removed")
    }
}

var student: Student? = Student()

student?.setup()
student?.showName?()

student = nil


// MARK: retry

func retryOperation(times: Int, operation: () -> Bool) {

    for i in 1...times {

        print("\nAttempt:", i)

        if operation() {
            print("operation successful")
            return
        } else {
            print("operation fail")
        }
    }

    print("all attempts failed")
}

var attempt = 0

retryOperation(times: 3) {

    attempt = attempt + 1

    if attempt == 2 {
        return true
    } else {
        return false
    }
}


