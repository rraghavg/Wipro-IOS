//
//  main.swift
//  lab-1c
//
//  Created by Raghav Gupta on 06/11/26.
//


import Foundation

// MARK: arr

print("      ARRAY OPERATIONS      ")

var courses = ["CSE", "Electrical", "Electronics", "AI/ML", "DataScience", "Blockchain"]

// display
print("courses:", courses)

// add
courses.append("Cyber Security")
print("after adding:", courses)

// remove course
courses.remove(at: 1)
print("after removing:", courses)

// short
courses.sort()
print("sorted courses:", courses)

// filter course
let filteredCourses = courses.filter { $0.count > 4 }
print("courses with more than 4 letters:", filteredCourses)

// search
if courses.contains("Swift") {
    print("Swift course found")
}
else {
    print("course not found")
}


// MARK: - SET

print("\n      SET OPERATIONS ")

var studentIDs: Set<Int> = [101, 102, 103, 101, 104, 102, 105]

print("Student IDs:", studentIDs)

// remove dupli automatically
print("Unique Student IDs:", studentIDs)

// count unique
print("Total Unique Students:", studentIDs.count)


// MARK: - dictionary

print("\n      DICTIONARY OPERATIONS ")

var marks = [
    101: 85,
    102: 92,
    103: 67,
    104: 78,
    105: 95
]

print("Student Marks:", marks)

// find top
var topperID = 0
var highestMarks = 0

for (id, mark) in marks {

    if mark > highestMarks {
        highestMarks = mark
        topperID = id
    }
}

print("Topper ID:", topperID)
print("Highest Marks:", highestMarks)

// student below 75
print("Students below 75 marks:")

for (id, mark) in marks {

    if mark < 75 {
        print("Student ID:", id, "Marks:", mark)
    }
}


// MARK: - enum

print("\n     ENUM OPERATIONS ")

enum Priority {
    case low
    case medium
    case high
}

// create priority
let taskPriority = Priority.high

// priority with switch
switch taskPriority {

case .low:
    print("Task Priority: Low")

case .medium:
    print("Task Priority: Medium")

case .high:
    print("Task Priority: High")
}


// MARK: - enum with values

print("\n      API RESULT ")

enum APIResult {
    case success(String)
    case failure(String)
}

let result = APIResult.success("Data Loaded Successfully")

switch result {

case .success(let message):
    print("Success:", message)

case .failure(let error):
    print("Error:", error)
}

