//
//  InstaCloneTests.swift
//  InstaCloneTests
//
//  Created by Brendon Crowe on 5/2/23.
//

import XCTest

@testable import InstaClone


final class InstaCloneTests: XCTestCase {
    
    func testFetchUsers() {
        let expectation = XCTestExpectation(description: "users found")
        DataBaseService.shared.fetchUsers { result in
            switch result {
            case .success(let users):
                expectation.fulfill()
                XCTAssertEqual(users.count, 3, "user's should be equal to \(users.count)")
            case .failure(let error):
                XCTFail("Fetching users should not result in an error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}


