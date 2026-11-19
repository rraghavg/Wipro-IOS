//
//  User.swift
//  lab-6
//
//  Model representing a user from the JSONPlaceholder test directory API.
//

import Foundation

// MARK: - Main User Model
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    // Helper for avatar circle
    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            let first = parts[0].prefix(1)
            let second = parts[1].prefix(1)
            return "\(first)\(second)".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

// MARK: - Address & Coordinates
struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo

    var fullAddress: String {
        return "\(suite), \(street), \(city) - \(zipcode)"
    }
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

// MARK: - Company
struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
