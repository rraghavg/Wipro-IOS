//
//  main.swift
//  task-3
//
//  Created by Raghav Gupta on 12/11/26.
//

import Foundation

// MARK: retain cycle problem

// both hold strong ref to each other -> memory leak
class Student {
    var name = "Raghav"
    var laptop: Laptop?

    deinit {
        print("Student removed")
    }
}

class Laptop {
    var model = "MacBook"
    var owner: Student?  // this causes retain cycle

    deinit {
        print("Laptop removed")
    }
}

print("RETAIN CYCLE")

var s: Student? = Student()
var l: Laptop? = Laptop()

s?.laptop = l
l?.owner = s  // strong reference back

s = nil
l = nil

// deinit not called - memory leak!
print("^ deinit not printed = memory leak")


// MARK: fix using weak

class FixedStudent {
    var name = "Raghav"
    var laptop: FixedLaptop?

    deinit {
        print("FixedStudent removed")
    }
}

class FixedLaptop {
    var model = "MacBook"
    weak var owner: FixedStudent?  // weak breaks the cycle

    deinit {
        print("FixedLaptop removed")
    }
}

print("\nFIXED WITH WEAK")

var fs: FixedStudent? = FixedStudent()
var fl: FixedLaptop? = FixedLaptop()

fs?.laptop = fl
fl?.owner = fs

fs = nil
fl = nil

// deinit called now - no leak


// MARK: closure retain cycle fix

class ProfileVC {
    var username = "raghavg"
    var onLoad: (() -> Void)?

    func setup() {
        // using [weak self] to avoid closure holding strong ref
        onLoad = { [weak self] in
            guard let self = self else { return }
            print("Loaded:", self.username)
        }
    }

    deinit {
        print("ProfileVC removed")
    }
}

print("\nCLOSURE FIX")

var vc: ProfileVC? = ProfileVC()
vc?.setup()
vc?.onLoad?()

vc = nil
