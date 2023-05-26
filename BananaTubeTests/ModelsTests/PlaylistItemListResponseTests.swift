//
//  PlaylistItemListResponseTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 26.05.2023.
//

import XCTest
@testable import BananaTube

class PlaylistItemListTests: XCTestCase {
    func testDecodePlaylistItemListResponse() throws {

        // Given
        let json = generatePlaylistItemsJSON()

        // When
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let playlistItems = try decoder.decode(PlaylistItems.self, from: data)

        // Then
        XCTAssertEqual(playlistItems.kind, "youtube#playlistItemListResponse")
        XCTAssertEqual(playlistItems.etag, "zmXzcJP4IryTED9lYMZZcukV3ZA")
        XCTAssertEqual(playlistItems.nextPageToken, "EAAaBlBUOkNBbw")
        XCTAssertEqual(playlistItems.pageInfo.totalResults, 75)
        XCTAssertEqual(playlistItems.pageInfo.resultsPerPage, 10)

        XCTAssertEqual(playlistItems.items.count, 10)

        let item1 = playlistItems.items[0]
        XCTAssertEqual(item1.kind, "youtube#playlistItem")
        XCTAssertEqual(item1.etag, "r_RVJ-u90U3N6SiDwlAEHsT9JzA")
        XCTAssertEqual(item1.id, "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLk9PejBmemY0SFNV")
        XCTAssertEqual(item1.contentDetails.videoId, "OOz0fzf4HSU")
        XCTAssertEqual(item1.contentDetails.videoPublishedAt, "2023-04-11T09:45:02Z")
    }

    func testDecodePlaylistItemListResponseWithInvalidData() throws {
        // Given
        let json = generateInvalidPlaylistItemsJSON()

        // When
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(PlaylistItems.self, from: data)) { error in
            // Then
            XCTAssertTrue(error is DecodingError)
            let decodingError = error as! DecodingError
            switch decodingError {
            case .dataCorrupted(let context):
                XCTAssertEqual(context.debugDescription, "The given data was not valid JSON.")
            default:
                XCTFail("Expected a dataCorrupted error.")
            }
        }
    }

    func generatePlaylistItemsJSON() -> String {
        """
        {
            "kind": "youtube#playlistItemListResponse",
            "etag": "zmXzcJP4IryTED9lYMZZcukV3ZA",
            "nextPageToken": "EAAaBlBUOkNBbw",
            "items": [
                {
                    "kind": "youtube#playlistItem",
                    "etag": "r_RVJ-u90U3N6SiDwlAEHsT9JzA",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLk9PejBmemY0SFNV",
                    "contentDetails": {
                        "videoId": "OOz0fzf4HSU",
                        "videoPublishedAt": "2023-04-11T09:45:02Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "OpyqBC6o9u4ltuS7dbKdKIjj8dY",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLlVRU2RyTFUyUFdZ",
                    "contentDetails": {
                        "videoId": "UQSdrLU2PWY",
                        "videoPublishedAt": "2023-03-31T10:15:02Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "MbaNVxQuHzF577sNN-FlRz3idSY",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLng4NHJ0alUteF9J",
                    "contentDetails": {
                        "videoId": "x84rtjU-x_I",
                        "videoPublishedAt": "2023-03-24T12:30:28Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "tztdXTUne1yn6_-1Ibzlm_3cSkI",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLl9ZZWVhX2V3WS1F",
                    "contentDetails": {
                        "videoId": "_Yeea_ewY-E",
                        "videoPublishedAt": "2023-03-23T10:00:22Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "PVXxvJVnI_xWM4KO6d10euIMr3M",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLi1TVVJUeXczUTlv",
                    "contentDetails": {
                        "videoId": "-SURTyw3Q9o",
                        "videoPublishedAt": "2023-03-12T07:00:00Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "LiY9Wkq_ThYXt5avvTqZiwnjmno",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLm1XZHktd3F4SEh3",
                    "contentDetails": {
                        "videoId": "mWdy-wqxHHw",
                        "videoPublishedAt": "2022-11-14T13:00:28Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "FUL7pA_eh6sloCzMHvHYhY5XHDs",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLjB5V1ZfZV9xRDVR",
                    "contentDetails": {
                        "videoId": "0yWV_e_qD5Q",
                        "videoPublishedAt": "2022-08-23T10:45:01Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "MMY-7QN37GCVJqwm_yqvekQNnH0",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLjRMTF9ZMW85Snc0",
                    "contentDetails": {
                        "videoId": "4LL_Y1o9Jw4",
                        "videoPublishedAt": "2022-08-16T16:48:03Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "wk962u_Rs08n-eB3uQ1SeDNxtGU",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLk1wOUJ4VHFTZkxv",
                    "contentDetails": {
                        "videoId": "Mp9BxTqSfLo",
                        "videoPublishedAt": "2022-06-05T20:54:22Z"
                    }
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "RPzDq9c_vwI-OnTiOsBfaWcEeL4",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLmFtVU5TRlBSTl9j",
                    "contentDetails": {
                        "videoId": "amUNSFPRN_c",
                        "videoPublishedAt": "2022-06-03T18:19:19Z"
                    }
                }
            ],
            "pageInfo": {
                "totalResults": 75,
                "resultsPerPage": 10
            }
        }
        """
    }

    func generateInvalidPlaylistItemsJSON() -> String {
        """
        {
            "kind": "youtube#playlistItemListResponse",
            "etag": "zmXzcJP4IryTED9lYMZZcukV3ZA",
            "nextPageToken": "EAAaBlBUOkNBbw",
            "items": [
                {
                    "kind": "youtube#playlistItem",
                    "etag": "r_RVJ-u90U3N6SiDwlAEHsT9JzA",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLk9PejBmemY0SFNV",
                    "contentDetails": {
                        "videoId": "OOz0fzf4HSU",
                        "videoPublishedAt": "2023-04-11T09:45:02Z"
                    }
                },
                // Add an item with missing required fields
                {
                    "kind": "youtube#playlistItem",
                    "etag": "OpyqBC6o9u4ltuS7dbKdKIjj8dY",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLlVRU2RyTFUyUFdZ"
                    // "contentDetails" field is missing
                },
                {
                    "kind": "youtube#playlistItem",
                    "etag": "MbaNVxQuHzF577sNN-FlRz3idSY",
                    "id": "VVVrNzNVNFFUM2NORHZxYl9QYVdNOEFBLng4NHJ0alUteF9J",
                    "contentDetails": {
                        "videoId": "x84rtjU-x_I",
                        "videoPublishedAt": "2023-03-24T12:30:28Z"
                    }
                }
            ],
            "pageInfo": {
                "totalResults": 75,
                "resultsPerPage": 10
            }
        }
        """
    }

}
