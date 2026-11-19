# Lab 6: Build a Network-Driven Directory

**Module 6:** Networking and JSON Parsing  
**Student Name:** Raghav Gupta  
**Project:** Wipro iOS Developer Training  

---

## 1. Selected Public API Endpoint
- **Public API:** JSONPlaceholder User Directory API
- **Endpoint URL:** `https://jsonplaceholder.typicode.com/users`
- **Method:** `GET`
- **Response Format:** JSON array of 10 comprehensive user objects containing nested addresses, geographical coordinates, and company profiles.

---

## 2. Architecture & Separation of Concerns
The project strictly separates networking logic from user interface components:
- **`Models/User.swift`**: Strongly-typed `Codable` structs matching the API contract (`User`, `Address`, `Geo`, `Company`).
- **`Services/NetworkError.swift`**: Custom error enum conforming to `LocalizedError` covering `.invalidURL`, `.invalidResponse(statusCode:)`, `.decodingError`, `.emptyData`, and `.networkFailure`.
- **`Services/UserService.swift`**: Independent service conforming to `UserServiceProtocol`. Handles URL construction with `URLComponents`, request preparation, `URLSession.shared.data(for:)`, status code validation, and `JSONDecoder` parsing. Also includes simulation hooks for classroom demonstrations.
- **`Views/UserTableViewCell.swift`**: Custom reusable cell with initials avatar badge, formatted contact labels, and auto layout.
- **`Controllers/UserListViewController.swift`**: Manages table view, pull-to-refresh, activity indicators, interactive retry cards, search filtering, and error states.
- **`Controllers/UserDetailViewController.swift`**: Presents card-based comprehensive profile view for selected users.
- **`Tests/UserServiceTests.swift`**: Automated 5-test suite testing decoding, 404 handling, decoding errors, empty states, and offline failure.

---

## 3. Handled States & Error Scenarios
1. **Loading State:** `UIActivityIndicatorView` spins while the asynchronous request is active.
2. **Success State:** Populates `UITableView` with 10 directory cards; supports row tap to navigate to detailed profile.
3. **HTTP 404 (Not Found):** Caught via status code inspection; displays warning icon, descriptive message, and retry button.
4. **HTTP 500 (Internal Server Error):** Informs user that the server is temporarily down.
5. **Decoding Failure:** Catches corrupted or mismatched JSON schemas gracefully without app termination.
6. **Empty Results:** Displays a custom empty-state tray icon with a refresh button.
7. **Network Offline / Timeout:** Catches network disconnections and offers a "Try Again" action.

> **Demonstration Feature:** The navigation bar includes a **"Simulate"** action sheet that allows faculty and evaluators to instantly switch between live API and all 5 simulated failure modes, demonstrating every error UI state on demand.

---

## 4. Extension: Search & Request Optimization
- **Search Implementation:** Integrated `UISearchController` in `UserListViewController` that filters locally by name, username, email, or company in real-time.
- **Avoiding Too Many Network Requests (Throttling & Debouncing):**
  When performing server-side search or pagination, multiple rapid keystrokes can saturate the network with redundant requests.
  To prevent this:
  1. **Debouncing:** Introduce a short delay (e.g., 300ms) using a cancellable `Task` (`Task.sleep(nanoseconds: 300_000_000)`). If the user types another character before the timer elapses, cancel the previous task.
  2. **Task Cancellation:** Cancel any inflight `URLSessionTask` as soon as a new search query is initiated.
  3. **Local In-Memory Cache:** Cache query results in an `NSCache` or dictionary so repeated searches (e.g. backspacing) return immediately from memory without making a network trip.

---

## 5. Automated Test Cases (5 Test Suite)
The app runs `UserServiceTests.runAllTests()` on startup, logging to the console:
1. `testFetchUsersSuccess`: Verifies valid JSON payload decodes into `[User]` with exact fields and computed initials.
2. `testFetchUsers404NotFound`: Verifies status code 404 throws `NetworkError.invalidResponse(statusCode: 404)`.
3. `testFetchUsersDecodingFailure`: Verifies malformed JSON throws `NetworkError.decodingError`.
4. `testFetchUsersEmptyData`: Verifies empty array `[]` throws `NetworkError.emptyData`.
5. `testFetchUsersNetworkFailure`: Verifies connection failure triggers `NetworkError.networkFailure`.
