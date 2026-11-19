//
//  NetworkError.swift
//  lab-6
//
//  Custom error enum representing network and parsing failure states.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(String)
    case emptyData
    case networkFailure(String)
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL is invalid or malformed."
        case .invalidResponse(let statusCode):
            switch statusCode {
            case 404:
                return "HTTP 404: The requested resource was not found on the server."
            case 500...599:
                return "HTTP \(statusCode): Server encountered an internal error. Please try again later."
            default:
                return "Received unexpected HTTP status code \(statusCode)."
            }
        case .decodingError(let detail):
            return "Failed to parse JSON response into models: \(detail)"
        case .emptyData:
            return "The server returned an empty list of users."
        case .networkFailure(let message):
            return "Network connection failed: \(message). Check your internet connection."
        case .custom(let message):
            return message
        }
    }
}
