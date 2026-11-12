//
//  main.swift
//  task-5
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// MARK: struct vs class

// struct - value type (copy)
struct PointS {
    var x: Int
    var y: Int
}

// class - reference type (shared)
class PointC {
    var x: Int
    var y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

print("STRUCT VS CLASS")

// struct copy - original not changed
var p1 = PointS(x: 10, y: 20)
var p2 = p1
p2.x = 99

print("\nStruct (value type)")
print("p1.x:", p1.x)  // still 10
print("p2.x:", p2.x)  // 99

// class - both point to same obj
var c1 = PointC(x: 10, y: 20)
var c2 = c1
c2.x = 99

print("\nClass (reference type)")
print("c1.x:", c1.x)  // 99 - changed!
print("c2.x:", c2.x)  // 99


// MARK: protocol vs inheritance

protocol Payable {
    func salary() -> Double
}

protocol Describable {
    func describe()
}

// struct can use multiple protocols
// class inheritance only gives one parent
struct Employee: Payable, Describable {
    var name: String
    var hours: Double

    func salary() -> Double {
        return hours * 50
    }

    func describe() {
        print("Employee:", name, "| Pay:", salary())
    }
}

class Vehicle {
    var speed = 0
    func move() {
        print("Moving at", speed, "kmph")
    }
}

class Car: Vehicle {
    var brand = "Toyota"
    override func move() {
        print(brand, "going at", speed, "kmph")
    }
}

print("\nPROTOCOL VS INHERITANCE")

let emp = Employee(name: "Raghav", hours: 40)
emp.describe()

let car = Car()
car.speed = 80
car.move()


// MARK: map filter reduce

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print("\nMAP FILTER REDUCE")
print("Numbers:", numbers)

// map - transform each element
let doubled = numbers.map { $0 * 2 }
print("\nMap (x2):", doubled)

// filter - keep matching ones
let evens = numbers.filter { $0 % 2 == 0 }
print("Filter (even):", evens)

// reduce - combine into one value
let sum = numbers.reduce(0, +)
print("Reduce (sum):", sum)

// chaining
let result = numbers
    .filter { $0 > 5 }
    .map { $0 * $0 }
    .reduce(0, +)

print("\nChained (>5 -> square -> sum):", result)
