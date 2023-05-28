//
//  CoreDataManagerTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 28.05.2023.
//

import XCTest
import CoreData

@testable import BananaTube

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()

        coreDataManager = CoreDataManager.shared
    }

    override func tearDown() {
        super.tearDown()

        // Clean up any created videos after each test
        coreDataManager.deleteAllVideos()
    }

    // MARK: - Video CRUD Tests

    func testCreateVideo() {
        // Given
        let id = "123"
        let userEmail = "test@example.com"

        // When
        coreDataManager.createVideo(with: id, userEmail: userEmail)

        // Then
        let videos = coreDataManager.fetchVideos(for: userEmail)
        XCTAssertEqual(videos.count, 1)
        XCTAssertEqual(videos[0].id, id)
        XCTAssertEqual(videos[0].userEmail, userEmail)
    }

    func testFetchVideos() {
        // Given
        let userEmail = "test@example.com"

        // Create test videos
        coreDataManager.createVideo(with: "1", userEmail: userEmail)
        coreDataManager.createVideo(with: "2", userEmail: "other@example.com")
        coreDataManager.createVideo(with: "3", userEmail: userEmail)

        // When
        let videos = coreDataManager.fetchVideos(for: userEmail)

        // Then
        XCTAssertEqual(videos.count, 2)
        XCTAssertEqual(videos[0].id, "1")
        XCTAssertEqual(videos[1].id, "3")
    }

    func testFetchVideoWithID() {
        // Given
        let id = "123"
        let userEmail = "test@example.com"

        // Create a test video
        coreDataManager.createVideo(with: id, userEmail: userEmail)

        // When
        let video = coreDataManager.fetchVideo(with: id)

        // Then
        XCTAssertNotNil(video)
        XCTAssertEqual(video?.id, id)
        XCTAssertEqual(video?.userEmail, userEmail)
    }

    func testDeleteAllVideos() {
        // Given
        let userEmail = "test@example.com"

        // Create test videos
        coreDataManager.createVideo(with: "1", userEmail: userEmail)
        coreDataManager.createVideo(with: "2", userEmail: "other@example.com")
        coreDataManager.createVideo(with: "3", userEmail: userEmail)

        // When
        coreDataManager.deleteAllVideos()

        // Then
        let videos = coreDataManager.fetchVideos(for: userEmail)
        XCTAssertEqual(videos.count, 0)
    }

    func testDeleteVideoWithID() {
        // Given
        let id = "123"
        let userEmail = "test@example.com"

        // Create a test video
        coreDataManager.createVideo(with: id, userEmail: userEmail)

        // When
        coreDataManager.deleteVideo(with: id, userEmail: userEmail)

        // Then
        let video = coreDataManager.fetchVideo(with: id)
        XCTAssertNil(video)
    }
}
