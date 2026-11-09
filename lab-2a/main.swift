//
//  main.swift
//  lab-2a
//
//  Created by Raghav Gupta on 09/11/26.
//

import Foundation

// mean calculation
func mean(numbers: [Double]) -> Double {
    var sum = 0.0

    for num in numbers {
        sum = sum + num
    }

    return sum / Double(numbers.count)
}

// find max number
func maximum(numbers: [Int]) -> Int {
    return numbers.max() ?? 0
}

// check mail
func checkEmail(email: String) -> Bool {
    if email.contains("@") && email.contains(".") {
        return true
    } else {
        return false
    }
}

// name format
func displayName(first: String, last: String) -> String {
    return first.capitalized + " " + last.capitalized
}

// calculate expense
func totalExpenses(transactions: [Int]) -> Int {
    let expense = transactions.filter { $0 < 0 }
    let amount = expense.map { -$0 }
    return amount.reduce(0, +)
}

// student sorting
func sortStudents(students: [(String, Int)]) -> [(String, Int)] {
    return students.sorted {
        if $0.1 == $1.1 {
            return $0.0 < $1.0
        }
        return $0.1 > $1.1
    }
}

// loop func
func loopExpenses(transactions: [Int]) -> Int {
    var total = 0

    for item in transactions {
        if item < 0 {
            total = total - item
        }
    }

    return total
}



let numbers = [10.0, 20.0, 30.0, 40.0]

print("Mean:", mean(numbers: numbers))

let marks = [10, 50, 30]
print("Maximum:", maximum(numbers: marks))

print("Email:", checkEmail(email: "test@gmail.com"))

print("Name:", displayName(first: "raghav", last: "gupta"))

// transaction, expense
let transactions = [-200, 500, -300, 1000, -150, -100]

let expense = transactions.filter { $0 < 0 }
print("Expenses.", expense)

let amount = expense.map { -$0 }
print("Expense Amount.", amount)

let total = amount.reduce(0, +)
print("Total Exp.", total)

// students
let students = [
    ("Riya", 85),
    ("Raghav", 90),
    ("Shravan", 85),
    ("Pihu", 95)
]

let result = sortStudents(students: students)

print("\nStudents accc. marks:")

for student in result {
    print(student.0, student.1)
}

// comp loop and high order func

let a = loopExpenses(transactions: transactions)
let b = totalExpenses(transactions: transactions)

print("\nLoop:-", a)
print("Higher Order Function:-", b)

// expense category wise

let categoryExpenses = [
    ("Food", 20000),
    ("Travel", 30000),
    ("Food", 15000),
    ("Shopping", 50000)
]

let categories = Set(categoryExpenses.map { $0.0 })

print("\nCategory Wise Expenses:")

for category in categories.sorted() {
    var total = 0

    for item in categoryExpenses {
        if item.0 == category {
            total = total + item.1
        }
    }

    print(category, ":", total)
}


