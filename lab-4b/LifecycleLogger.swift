//
//  LifecycleLogger.swift
//  lab-4b
//
//  Created by Raghav Gupta on 14/11/26.
//

import Foundation

class LifecycleLogger {

    static let shared = LifecycleLogger()

    var logs: [String] = []
    var onLogUpdate: (() -> Void)?

    func log(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())

        let entry = "[\(timestamp)] \(message)"
        logs.append(entry)
        print(entry)

        DispatchQueue.main.async {
            self.onLogUpdate?()
        }
    }
}
