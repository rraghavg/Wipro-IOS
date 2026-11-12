//
//  main.swift
//  task-2
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// generic stack - T means any type
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


// int stack
var numStack = Stack<Int>()

print("INT STACK")
print("Empty:", numStack.isEmpty)

numStack.push(10)
numStack.push(20)
numStack.push(30)

print("Top:", numStack.peek() ?? 0)
print("Popped:", numStack.pop() ?? 0)
print("New Top:", numStack.peek() ?? 0)

_ = numStack.pop()
_ = numStack.pop()

// pop from empty - returns nil safely
print("Pop empty:", numStack.pop() ?? -1)


// string stack
var strStack = Stack<String>()

print("\nSTRING STACK")

strStack.push("Swift")
strStack.push("Xcode")
strStack.push("iOS")

print("Top:", strStack.peek() ?? "none")
print("Popped:", strStack.pop() ?? "none")
print("Top now:", strStack.peek() ?? "none")
print("Empty:", strStack.isEmpty)
