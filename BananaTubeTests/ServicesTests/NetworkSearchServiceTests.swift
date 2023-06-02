//
//  NetworkSearchServiceTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 26.05.2023.
//

import XCTest
@testable import BananaTube

class NetworkSearchServiceTests: XCTestCase {
    let service = NetworkSearchService()

    func testGetVideos_Success() async throws {
        // Given
        let searchText = "banana"
        let nextPageToken = ""
        let expectation = XCTestExpectation(description: "Get videos expectation")

        // When
        await service.getVideos(searchText: searchText, nextPageToken: nextPageToken) { result in
            // Then
            switch result {
            case .success(let searchResult):
                XCTAssertNotNil(searchResult)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
        }
    }

    func testGetVideos_KeyNotFound() async throws {
        // Given
        let searchText = "banana"
        let nextPageToken = "testtesttesttesttesttesttesttesttesttesttesttest"
        let expectation = XCTestExpectation(description: "Get videos expectation")

        // When
        await service.getVideos(searchText: searchText, nextPageToken: nextPageToken) { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Expected error, but received success")
            case .failure(let error):
                if let decodingError = error as? DecodingError, case .keyNotFound(let key, _) = decodingError {
                    // The error is the expected keyNotFound error with "kind" key
                    // Test passes
                    if key.stringValue == "kind" {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected decoding error: \(decodingError)")
                    }
                } else {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            }
        }
    }
}

