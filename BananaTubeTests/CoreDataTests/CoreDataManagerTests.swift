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
    let userEmail = "test@example.com"

    override func setUp() {
        super.setUp()

        coreDataManager = CoreDataManager.shared
    }

    override func tearDown() {
        super.tearDown()

        coreDataManager.deleteAllVideosOfUser(userEmail: userEmail)
    }

    // MARK: - Video CRUD Tests

    func testCreateVideo() {
        // Given
        let id = "123"

        // When
        coreDataManager.createVideo(id: id, userEmail: userEmail)

        // Then
        let videos = coreDataManager.fetchVideos(userEmail: userEmail)
        XCTAssertEqual(videos.count, 1)
        XCTAssertEqual(videos[0].id, id)
        XCTAssertEqual(videos[0].userEmail, userEmail)
    }

    func testFetchVideos_Success() {
        // Create test videos
        coreDataManager.createVideo(id: "1", userEmail: userEmail)
        coreDataManager.createVideo(id: "2", userEmail: "other@example.com")
        coreDataManager.createVideo(id: "3", userEmail: userEmail)

        // When
        let videos = coreDataManager.fetchVideos(userEmail: userEmail)

        // Then
        XCTAssertEqual(videos.count, 2)
        XCTAssertEqual(videos[0].id, "1")
        XCTAssertEqual(videos[1].id, "3")
    }

    func testFetchVideos_EmptyArray() {
        // Given
        let userEmail = "nosuchuser@example.com"

        // When
        let videos = coreDataManager.fetchVideos(userEmail: userEmail)
        XCTAssertEqual(videos, [])
    }

    func testFetchVideoWithID_Success() {
        // Given
        let id = "123"

        // Create a test video
        coreDataManager.createVideo(id: id, userEmail: userEmail)

        // When
        let video = coreDataManager.fetchVideo(id: id)

        // Then
        XCTAssertNotNil(video)
        XCTAssertEqual(video?.id, id)
        XCTAssertEqual(video?.userEmail, userEmail)
    }

    func testFetchVideoWithID_Nil() {
        // Given
        let id = "notExistId"

        // When
        let video = coreDataManager.fetchVideo(id: id)

        // Then
        XCTAssertNil(video)
    }

    func testDeleteAllVideos() {
        // Create test videos
        coreDataManager.createVideo(id: "1", userEmail: userEmail)
        coreDataManager.createVideo(id: "2", userEmail: "other@example.com")
        coreDataManager.createVideo(id: "3", userEmail: userEmail)

        // When
        coreDataManager.deleteAllVideos()

        // Then
        let videos = coreDataManager.fetchVideos(userEmail: userEmail)
        XCTAssertEqual(videos.count, 0)
    }

    func testDeleteVideoWithID() {
        // Given
        let id = "123"

        // Create a test video
        coreDataManager.createVideo(id: id, userEmail: userEmail)

        // When
        coreDataManager.deleteVideo(id: id, userEmail: userEmail)

        // Then
        let video = coreDataManager.fetchVideo(id: id)
        XCTAssertNil(video)
    }
}
