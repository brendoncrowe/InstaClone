//
//  InstaCloneTests.swift
//  InstaCloneTests
//
//  Created by Brendon Crowe on 5/2/23.
//

import XCTest

@testable import InstaClone


final class InstaCloneTests: XCTestCase {
    
    func testCurrentUser() {
        let expectation = XCTestExpectation(description: "Fetch users completion handler should be called.")
        
        DataBaseService.shared.fetchUsers { result in
            switch result {
            case .success(let users):
                expectation.fulfill()
                XCTAssertFalse(users.isEmpty, "Users array should not be empty.")
            case .failure(let error):
                XCTFail("Fetching users should not result in an error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}


