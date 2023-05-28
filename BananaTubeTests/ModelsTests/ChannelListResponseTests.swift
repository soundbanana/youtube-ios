//
//  ChannelListResponseTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 26.05.2023.
//

import XCTest
@testable import BananaTube

class ChannelListResponseTests: XCTestCase {
    func testDecodeChannelListResponse() throws {
        
        // Given
        let json = generatePlaylistItemsJSON()

        let jsonData = json.data(using: .utf8)!

        // When
        let response = try JSONDecoder().decode(ChannelListResponse.self, from: jsonData)

        // Then
        XCTAssertEqual(response.kind, "youtube#channelListResponse")
        XCTAssertEqual(response.etag, "AxADw0esEfDjN28WotSettQG3ws")
        XCTAssertEqual(response.pageInfo?.totalResults, 4)
        XCTAssertEqual(response.pageInfo?.resultsPerPage, 50)
        XCTAssertEqual(response.items.count, 4)

        let item1 = response.items[0]
        XCTAssertEqual(item1.kind, "youtube#channel")
        XCTAssertEqual(item1.etag, "aHfVxMVtIfKS8OMTpie5pevcY1w")
        XCTAssertEqual(item1.id, "UCj7bSQWlq2O4lhGxGll5SUA")
        XCTAssertEqual(item1.contentDetails.relatedPlaylists.likes, "")
        XCTAssertEqual(item1.contentDetails.relatedPlaylists.uploads, "UUj7bSQWlq2O4lhGxGll5SUA")

        let item2 = response.items[1]
        XCTAssertEqual(item2.kind, "youtube#channel")
        XCTAssertEqual(item2.etag, "RB4tacbj3Dmrl-Cw9rd709CJx6Q")
        XCTAssertEqual(item2.id, "UCk73U4QT3cNDvqb_PaWM8AA")
        XCTAssertEqual(item2.contentDetails.relatedPlaylists.likes, "")
        XCTAssertEqual(item2.contentDetails.relatedPlaylists.uploads, "UUk73U4QT3cNDvqb_PaWM8AA")

        let item3 = response.items[2]
        XCTAssertEqual(item3.kind, "youtube#channel")
        XCTAssertEqual(item3.etag, "o3FZxEcMzYUOe1tRWv8QSJCLIRI")
        XCTAssertEqual(item3.id, "UC6bTF68IAV1okfRfwXIP1Cg")
        XCTAssertEqual(item3.contentDetails.relatedPlaylists.likes, "")
        XCTAssertEqual(item3.contentDetails.relatedPlaylists.uploads, "UU6bTF68IAV1okfRfwXIP1Cg")

        let item4 = response.items[3]
        XCTAssertEqual(item4.kind, "youtube#channel")
        XCTAssertEqual(item4.etag, "0kVJyTbdAk2ZBv0oXf4uK7Fg1Gc")
        XCTAssertEqual(item4.id, "UCM7-8EfoIv0T9cCI4FhHbKQ")
        XCTAssertEqual(item4.contentDetails.relatedPlaylists.likes, "")
        XCTAssertEqual(item4.contentDetails.relatedPlaylists.uploads, "UUM7-8EfoIv0T9cCI4FhHbKQ")
    }

    func generatePlaylistItemsJSON() -> String {
        """
                {
                    "kind": "youtube#channelListResponse",
                    "etag": "AxADw0esEfDjN28WotSettQG3ws",
                    "pageInfo": {
                        "totalResults": 4,
                        "resultsPerPage": 50
                    },
                    "items": [
                        {
                            "kind": "youtube#channel",
                            "etag": "aHfVxMVtIfKS8OMTpie5pevcY1w",
                            "id": "UCj7bSQWlq2O4lhGxGll5SUA",
                            "contentDetails": {
                                "relatedPlaylists": {
                                    "likes": "",
                                    "uploads": "UUj7bSQWlq2O4lhGxGll5SUA"
                                }
                            }
                        },
                        {
                            "kind": "youtube#channel",
                            "etag": "RB4tacbj3Dmrl-Cw9rd709CJx6Q",
                            "id": "UCk73U4QT3cNDvqb_PaWM8AA",
                            "contentDetails": {
                                "relatedPlaylists": {
                                    "likes": "",
                                    "uploads": "UUk73U4QT3cNDvqb_PaWM8AA"
                                }
                            }
                        },
                        {
                            "kind": "youtube#channel",
                            "etag": "o3FZxEcMzYUOe1tRWv8QSJCLIRI",
                            "id": "UC6bTF68IAV1okfRfwXIP1Cg",
                            "contentDetails": {
                                "relatedPlaylists": {
                                    "likes": "",
                                    "uploads": "UU6bTF68IAV1okfRfwXIP1Cg"
                                }
                            }
                        },
                        {
                            "kind": "youtube#channel",
                            "etag": "0kVJyTbdAk2ZBv0oXf4uK7Fg1Gc",
                            "id": "UCM7-8EfoIv0T9cCI4FhHbKQ",
                            "contentDetails": {
                                "relatedPlaylists": {
                                    "likes": "",
                                    "uploads": "UUM7-8EfoIv0T9cCI4FhHbKQ"
                                }
                            }
                        }
                    ]
                }
                """
    }
}
