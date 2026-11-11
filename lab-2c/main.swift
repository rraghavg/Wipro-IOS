//
//  main.swift
//  lab-2c
//
//  Created by Raghav Gupta on 11/11/26.
//

import Foundation

protocol Displayable {
    func display()
}

// student
struct Student: Displayable {
    var name: String
    var marks: Int

    func display() {
        print("Name:", name)
        print("Marks:", marks)
    }
}

// course
struct Course: Displayable {
    var name: String
    var duration: Int

    func display() {
        print("Course:", name)
        print("Duration:", duration)
    }
}

// extention
extension String {
    var isLong: Bool {
        return count > 5
    }
}

// generic stack
struct Stack<T> {
    var items: [T] = []

    mutating func push(_ value: T) {
        items.append(value)
    }

    mutating func pop() -> T? {
        return items.popLast()
    }

    func peek() -> T? {
        return items.last
    }

    var isEmpty: Bool {
        return items.isEmpty
    }
}

// protocol constraint
func show<T: Displayable>(_ item: T) {
    item.display()
}

// custom protocol
protocol MyStack {
    associatedtype Item
    mutating func push(_ value: Item)
    mutating func pop() -> Item?
    func peek() -> Item?
    var isEmpty: Bool { get }
}

extension Stack: MyStack { }


// main

let s = Student(name: "Raghav", marks: 90)
let c = Course(name: "Swift", duration: 6)

print("Student Details")
show(s)

print("\nCourse Details")
show(c)


// string extension
let name = "Raghav Gupta"
print("\nName:", name)
print("Long Name:", name.isLong)


// integer stack
var a = Stack<Int>()

print("\nInteger Stack")
print("Empty:", a.isEmpty)

a.push(10)
a.push(20)
a.push(30)

print("Top:", a.peek() ?? 0)
print("Removed:", a.pop() ?? 0)
print("New Top:", a.peek() ?? 0)


// string stack
var b = Stack<String>()

print("\nString Stack")

b.push("Apple")
b.push("Banana")
b.push("Mango")

print("Top:", b.peek() ?? "None")
print("Removed:", b.pop() ?? "None")
print("New Top:", b.peek() ?? "None")


