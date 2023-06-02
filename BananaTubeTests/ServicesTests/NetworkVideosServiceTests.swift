//
//  NetworkVideosServiceTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 27.05.2023.
//

import XCTest
@testable import BananaTube

class NetworkVideosServiceTests: XCTestCase {
    let service = NetworkVideosService()

    func testGetRealVideos_Successful() async throws {
        // Given
        let videoIds = ["xCpynxQeXZI", "6GPmwBaY4pQ", "ux6zXguiqxM"]

        // When
        let videos = await service.getRealVideos(videoIds: videoIds)

        // Then
        XCTAssertEqual(videos.count, videoIds.count)
    }

    func testGetRealVideos_EmptyVideoIds() async {
        // Given
        let videoIds: [String] = []

        // When
        let videos = await service.getRealVideos(videoIds: videoIds)

        // Then
        XCTAssertTrue(videos.isEmpty)
    }

    func testGetRealVideos_NetworkError() async {
        // Given
        let videoIds = ["videoId1", "videoId2", "videoId3"]

        // When
        let videos = await service.getRealVideos(videoIds: videoIds)

        // Then
        XCTAssertTrue(videos.isEmpty)
    }

    static var allTests = [
        ("testGetRealVideos_Successful", testGetRealVideos_Successful),
        ("testGetRealVideos_EmptyVideoIds", testGetRealVideos_EmptyVideoIds),
        ("testGetRealVideos_NetworkError", testGetRealVideos_NetworkError),
    ]
}

