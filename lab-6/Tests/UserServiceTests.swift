//
//  UserServiceTests.swift
//  lab-6
//
//  Automated test suite containing 5 validation test cases for network states:
//  1. Successful decoding of valid JSON
//  2. HTTP 404 (Not Found) handling
//  3. JSON decoding failure handling
//  4. Empty data response handling
//  5. Network offline / connection failure handling
//

import Foundation

class UserServiceTests {

    static func runAllTests() async {
        print("\n==================================================")
        print("🧪 RUNNING LAB 6 AUTOMATED TEST SUITE (5 TEST CASES)")
        print("==================================================")

        var passed = 0
        var failed = 0

        // Test 1: Successful JSON Decoding
        do {
            print("\n[TEST 1] Testing Valid JSON Decoding...")
            let sampleJSON = """
            [
              {
                "id": 1,
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "address": {
                  "street": "Kulas Light",
                  "suite": "Apt. 556",
                  "city": "Gwenborough",
                  "zipcode": "92998-3874",
                  "geo": { "lat": "-37.3159", "lng": "81.1496" }
                },
                "phone": "1-770-736-8031 x56442",
                "website": "hildegard.org",
                "company": {
                  "name": "Romaguera-Crona",
                  "catchPhrase": "Multi-layered client-server neural-net",
                  "bs": "harness real-time e-markets"
                }
              }
            ]
            """.data(using: .utf8)!

            let users = try JSONDecoder().decode([User].self, from: sampleJSON)
            assert(users.count == 1, "Expected 1 user")
            assert(users[0].name == "Leanne Graham", "Name mismatch")
            assert(users[0].initials == "LG", "Initials calculation error")
            print("✅ TEST 1 PASSED: Successfully decoded User model from JSON.")
            passed += 1
        } catch {
            print("❌ TEST 1 FAILED: \(error)")
            failed += 1
        }

        // Test 2: HTTP 404 Not Found Handling
        do {
            print("\n[TEST 2] Testing HTTP 404 Not Found Response...")
            let service = UserService()
            service.simulationMode = .simulate404
            _ = try await service.fetchUsers()
            print("❌ TEST 2 FAILED: Expected invalidResponse(statusCode: 404) error, but call succeeded.")
            failed += 1
        } catch let error as NetworkError {
            if case .invalidResponse(let statusCode) = error, statusCode == 404 {
                print("✅ TEST 2 PASSED: Properly caught HTTP 404 status code.")
                passed += 1
            } else {
                print("❌ TEST 2 FAILED: Unexpected error type: \(error)")
                failed += 1
            }
        } catch {
            print("❌ TEST 2 FAILED: Non-NetworkError caught: \(error)")
            failed += 1
        }

        // Test 3: Decoding Failure Handling
        do {
            print("\n[TEST 3] Testing Malformed JSON Decoding Failure...")
            let service = UserService()
            service.simulationMode = .simulateDecodingError
            _ = try await service.fetchUsers()
            print("❌ TEST 3 FAILED: Expected decodingError, but call succeeded.")
            failed += 1
        } catch let error as NetworkError {
            if case .decodingError = error {
                print("✅ TEST 3 PASSED: Properly caught JSON decoding error without crashing.")
                passed += 1
            } else {
                print("❌ TEST 3 FAILED: Unexpected error: \(error)")
                failed += 1
            }
        } catch {
            print("❌ TEST 3 FAILED: Non-NetworkError caught: \(error)")
            failed += 1
        }

        // Test 4: Empty Data Handling
        do {
            print("\n[TEST 4] Testing Empty Array Response ([]) Handling...")
            let service = UserService()
            service.simulationMode = .simulateEmptyList
            _ = try await service.fetchUsers()
            print("❌ TEST 4 FAILED: Expected emptyData, but call succeeded.")
            failed += 1
        } catch let error as NetworkError {
            if case .emptyData = error {
                print("✅ TEST 4 PASSED: Successfully handled empty data state.")
                passed += 1
            } else {
                print("❌ TEST 4 FAILED: Unexpected error: \(error)")
                failed += 1
            }
        } catch {
            print("❌ TEST 4 FAILED: Non-NetworkError caught: \(error)")
            failed += 1
        }

        // Test 5: Network Offline Failure
        do {
            print("\n[TEST 5] Testing Network Offline / Disconnection...")
            let service = UserService()
            service.simulationMode = .simulateNetworkOffline
            _ = try await service.fetchUsers()
            print("❌ TEST 5 FAILED: Expected networkFailure, but call succeeded.")
            failed += 1
        } catch let error as NetworkError {
            if case .networkFailure = error {
                print("✅ TEST 5 PASSED: Handled offline connection safely with user-friendly alert.")
                passed += 1
            } else {
                print("❌ TEST 5 FAILED: Unexpected error: \(error)")
                failed += 1
            }
        } catch {
            print("❌ TEST 5 FAILED: Non-NetworkError caught: \(error)")
            failed += 1
        }

        print("\n==================================================")
        print("SUMMARY: \(passed) Passed, \(failed) Failed out of 5 tests.")
        print("==================================================\n")
    }
}
