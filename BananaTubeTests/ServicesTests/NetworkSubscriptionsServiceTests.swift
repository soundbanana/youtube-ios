//
//  NetworkSubscriptionsServiceTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 26.05.2023.
//

import XCTest
@testable import BananaTube

class NetworkSubscriptionsServiceTests: XCTestCase {
    let service = NetworkSubscriptionsService(networkVideosService: NetworkVideosService())

    func testGetSubscriptionsChannels_Unauthorized() async {
        // When
        do {
            _ = try await service.getSubscriptionsChannels(accessToken: nil)
            XCTFail("Expected an unauthorized error.")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, NetworkError.unauthorized)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetPlaylists_Success() async throws {
        // When
        let playlists = try await service.getPlaylists(subscriptions: ["UCj7bSQWlq2O4lhGxGll5SUA", "UCk73U4QT3cNDvqb_PaWM8AA", "UCM7-8EfoIv0T9cCI4FhHbKQ", "UC6bTF68IAV1okfRfwXIP1Cg"])

        // Then
        XCTAssertNotNil(playlists)
        XCTAssertFalse(playlists.isEmpty)
    }

    func testGetPlaylists_KeyNotFound() async throws {
        // When
        do {
            // Provide an invalid URL to trigger the NetworkError.invalidURL
            let playlists = try await service.getPlaylists(subscriptions: ["%2C", "subscription2"])

            // Then
            XCTFail("Expected error, but received playlists: \(playlists)")
        } catch let error as DecodingError {
            if case let .keyNotFound(key, _) = error, key.stringValue == "items" {
                // The error is the expected keyNotFound error with "items" key
                // Test passes
            } else {
                XCTFail("Unexpected DecodingError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testGetPlaylistItems_Success() async throws {
        // When
        let items = try await service.getPlaylistItems(playlist: "UUj7bSQWlq2O4lhGxGll5SUA")

        // Then
        XCTAssertNotNil(items)
        XCTAssertFalse(items.isEmpty)
    }

    func testGetPlaylistItems_PlaylistNotFound() async {
        // When
        do {
            let items = try await service.getPlaylistItems(playlist: "invalidPlaylist")
            XCTAssertTrue(items.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
