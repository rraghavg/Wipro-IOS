//
//  UserService.swift
//  lab-6
//
//  Service layer responsible for fetching and decoding user directory data.
//

import Foundation

// MARK: - Service Protocol
protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
}

// MARK: - Simulation Modes for Testing & Grading
enum NetworkSimulationMode: String, CaseIterable {
    case liveAPI = "Live API"
    case simulate404 = "HTTP 404 (Not Found)"
    case simulate500 = "HTTP 500 (Server Error)"
    case simulateDecodingError = "Decoding Error"
    case simulateNetworkOffline = "Network Offline"
    case simulateEmptyList = "Empty Results"
}

// MARK: - Concrete Network Service
class UserService: UserServiceProtocol {
    
    // Classroom-approved public test API endpoint
    static let defaultEndpoint = "https://jsonplaceholder.typicode.com/users"
    
    private let session: URLSession
    private let endpointString: String
    
    // Active simulation mode (defaults to live API)
    var simulationMode: NetworkSimulationMode = .liveAPI

    init(session: URLSession = .shared, endpoint: String = defaultEndpoint) {
        self.session = session
        self.endpointString = endpoint
    }

    func fetchUsers() async throws -> [User] {
        // Handle student test simulations if selected
        switch simulationMode {
        case .simulate404:
            // Simulate short network delay then throw HTTP 404
            try await Task.sleep(nanoseconds: 600_000_000)
            throw NetworkError.invalidResponse(statusCode: 404)

        case .simulate500:
            try await Task.sleep(nanoseconds: 600_000_000)
            throw NetworkError.invalidResponse(statusCode: 500)

        case .simulateDecodingError:
            try await Task.sleep(nanoseconds: 500_000_000)
            let badJSON = Data("{\"notAUserList\": 123}".utf8)
            do {
                _ = try JSONDecoder().decode([User].self, from: badJSON)
            } catch {
                throw NetworkError.decodingError(error.localizedDescription)
            }

        case .simulateNetworkOffline:
            try await Task.sleep(nanoseconds: 500_000_000)
            throw NetworkError.networkFailure("The Internet connection appears to be offline.")

        case .simulateEmptyList:
            try await Task.sleep(nanoseconds: 500_000_000)
            throw NetworkError.emptyData

        case .liveAPI:
            return try await performLiveFetch()
        }

        return []
    }

    // MARK: - Live Network Call
    private func performLiveFetch() async throws -> [User] {
        // 1. Build and validate URL using URLComponents
        guard let components = URLComponents(string: endpointString),
              let url = components.url else {
            throw NetworkError.invalidURL
        }

        // 2. Configure URLRequest with headers and timeout
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15.0
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 3. Perform asynchronous network request using URLSession
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.networkFailure(error.localizedDescription)
        }

        // 4. Validate HTTP status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        // 5. Decode JSON response safely
        let decoder = JSONDecoder()
        let users: [User]
        do {
            users = try decoder.decode([User].self, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }

        // 6. Handle empty list scenario
        if users.isEmpty {
            throw NetworkError.emptyData
        }

        return users
    }
}
