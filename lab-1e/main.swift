//
//  main.swift
//  lab-1e
//
//  Created by Raghav Gupta on 06/11/26.
//

import Foundation

// MARK: struct type: Value

struct Course {
    var name: String
    var duration: Int
}

print("STRUCT VALUE TYPE")

var course1 = Course(name: "B.Tech Computer Science", duration: 30)
var course2 = course1

course2.name = "MBA"
course2.duration = 45

print("original:", course1.name, course1.duration)
print("copy:", course2.name, course2.duration)


// MARK: class refernece type

class CourseManager {
    var managerName: String

    init(managerName: String) {
        self.managerName = managerName
    }

    deinit {
        print("CourseManager \(managerName) released")
    }
}

print("\n--refernece type class--")

var manager1: CourseManager? = CourseManager(managerName: "Rahul")
var manager2 = manager1

manager2?.managerName = "Raghav"

print("Manager 1:", manager1?.managerName ?? "None")
print("Manager 2:", manager2?.managerName ?? "None")

manager1=nil
manager2=nil

// MARK: reference weak

class Teacher{
    let name: String
    weak var classroom: Classroom?
    
    init(name: String) {
        self.name = name
    }
    
    deinit{
        print("Teacher \(name) released")
    }
}

class Classroom{
    let roomNumber: Int
    var teacher : Teacher?
    
    init(roomNumber: Int) {
        self.roomNumber = roomNumber
    }
    deinit {
        print("Classroom \(roomNumber) released")
    }
}
print("\n Reference weak")

var teacher:Teacher? = Teacher(name: "Pooja")
var classroom:Classroom? = Classroom(roomNumber: 1002)

// Classroom strongly references Teacher
classroom?.teacher = teacher

// Teacher weakly references Classroom
teacher?.classroom = classroom

print("Teacher:", classroom?.teacher?.name ?? "None")
print("Classroom:", teacher?.classroom?.roomNumber ?? 0)

teacher=nil
classroom=nil


// MARK: strong refernce cycle with closure

class Student {
    let name: String
    var attendance: (() -> Void)?

    init(name: String) {
        self.name = name
    }

    func markAttendance() {
        print("\(name) is present")
    }

    deinit {
        print("Student \(name) released")
    }
}

print("\n strong reference cycle")

var student: Student? = Student(name: "Raghav")

// Closure strongly captures student
student?.attendance = {
    student?.markAttendance()
}

// Remove the closure to break the cycle
student?.attendance=nil

student = nil


// MARK: capture list weak

print("\n weak capture fix")

var student2: Student? = Student(name: "Riya")

student2?.attendance = { [weak student2] in
    student2?.markAttendance()
}

student2?.attendance?()

student2 = nil


