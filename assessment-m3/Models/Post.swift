//
//  Post.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  Codable model for JSONPlaceholder /posts endpoint
//

import Foundation

// R2: Codable model matching the JSON response from the API
// Each post has an id, userId, title, and body
struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
