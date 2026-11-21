//
//  PostService.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//  Networking layer: URLSession + JSONDecoder, kept separate from UI
//

import Foundation

// custom error enum so we can show proper messages to the user
enum PostServiceError: LocalizedError {
    case badURL
    case httpError(Int)
    case decodingFailed(String)
    case noResults
    case networkDown(String)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL we tried to reach is not valid."
        case .httpError(let code):
            if code == 404 {
                return "HTTP 404 — the page was not found on the server."
            } else if code >= 500 {
                return "HTTP \(code) — the server ran into a problem. Try again later."
            }
            return "Got an unexpected HTTP status code: \(code)."
        case .decodingFailed(let detail):
            return "Could not read the JSON the server sent back: \(detail)"
        case .noResults:
            return "The server returned an empty list."
        case .networkDown(let msg):
            return "Network error: \(msg)"
        }
    }
}

// simulation modes so we can demo error/empty states without actually breaking things
enum SimulationMode: String, CaseIterable {
    case live        = "Live API"
    case error404    = "HTTP 404"
    case error500    = "HTTP 500"
    case badJSON     = "Decoding Error"
    case offline     = "Network Offline"
    case emptyList   = "Empty Results"
}

class PostService {

    // JSONPlaceholder — classroom-approved public test API
    private let endpoint = "https://jsonplaceholder.typicode.com/posts"

    var mode: SimulationMode = .live

    // R2: Uses URLSession with async/await, URLComponents, URLRequest, JSONDecoder
    func fetchPosts() async throws -> [Post] {

        // handle the simulated error modes first (for grading screenshots)
        switch mode {
        case .error404:
            try await Task.sleep(nanoseconds: 500_000_000)
            throw PostServiceError.httpError(404)
        case .error500:
            try await Task.sleep(nanoseconds: 500_000_000)
            throw PostServiceError.httpError(500)
        case .badJSON:
            try await Task.sleep(nanoseconds: 400_000_000)
            let garbage = Data("{\"nope\": true}".utf8)
            do {
                _ = try JSONDecoder().decode([Post].self, from: garbage)
            } catch {
                throw PostServiceError.decodingFailed(error.localizedDescription)
            }
            return []
        case .offline:
            try await Task.sleep(nanoseconds: 400_000_000)
            throw PostServiceError.networkDown("The internet connection appears to be offline.")
        case .emptyList:
            try await Task.sleep(nanoseconds: 400_000_000)
            throw PostServiceError.noResults
        case .live:
            break
        }

        // 1. build the URL using URLComponents
        guard let components = URLComponents(string: endpoint),
              let url = components.url else {
            throw PostServiceError.badURL
        }

        // 2. create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 3. fire off the network call
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw PostServiceError.networkDown(error.localizedDescription)
        }

        // 4. check the HTTP status
        guard let http = response as? HTTPURLResponse else {
            throw PostServiceError.httpError(-1)
        }
        guard (200...299).contains(http.statusCode) else {
            throw PostServiceError.httpError(http.statusCode)
        }

        // 5. decode
        let posts: [Post]
        do {
            posts = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            throw PostServiceError.decodingFailed(error.localizedDescription)
        }

        // 6. empty check
        if posts.isEmpty {
            throw PostServiceError.noResults
        }

        return posts
    }
}
