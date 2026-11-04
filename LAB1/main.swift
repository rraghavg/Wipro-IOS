import Foundation

// Student
let name = "Raghav"
let rollNumber = 101

// Marks in five subjects
var mark1 = 85
var mark2 = 75
var mark3 = 90
var mark4 = 65
var mark5 = 80

var attendance = 85.0

// total,avg,%
let total = mark1 + mark2 + mark3 + mark4 + mark5
let average = Double(total) / 5
let percentage = Double(total) / 500 * 100

// Pass or Fail
var result = "Pass"

if mark1 < 33 || mark2 < 33 || mark3 < 33 ||
   mark4 < 33 || mark5 < 33 {
    result = "Fail"
}

// Grades
func calculateGrade(_ percentage: Double) -> String {
    switch percentage {
    case 90...100:
        return "A+"
    case 80..<90:
        return "A"
    case 70..<80:
        return "B"
    case 60..<70:
        return "C"
    case 33..<60:
        return "D"
    default:
        return "F"
    }
}

let grade = calculateGrade(percentage)

// attendance
if attendance < 0 || attendance > 100 {
    print("Invalid Attendance")
} else {

    // Display Result
    print("----- STUDENT RESULT -----")
    print("Name: \(name)")
    print("Roll Number: \(rollNumber)")
    print("Total Marks: \(total)")
    print("Average: \(average)")
    print("Percentage: \(percentage)%")
    print("Result: \(result)")
    print("Grade: \(grade)")
    print("Attendance: \(attendance)%")
}

// arithmetic
let a = 10
let b = 5

print("Addition:", a + b)
print("Subtraction:", a - b)
print("Multiplication:", a * b)
print("Division:", a / b)
print("Remainder:", a % b)

// comparison
print("Equal:", a == b)
print("Greater:", a > b)
print("Less:", a < b)

// logical
let age = 20
print("Logical AND:", age > 18 && a > b)
print("Logical OR:", age > 18 || a < b)
print("Logical NOT:", !(a == b))

// compound
var number = 10
number += 5
print("Compound Assignment:", number)

// mil coalescing
var studentCity: String? = nil
let city = studentCity ?? "Mathura"
print("City:", city)

// boundary
print("Boundary Test - 0:", calculateGrade(0))
print("Boundary Test - 100:", calculateGrade(100))
print("Boundary Test - Fail:", calculateGrade(32))
