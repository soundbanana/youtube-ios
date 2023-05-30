//
//  ApiError.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 24.05.2023.
//

import Foundation

struct APIError: Codable {
    let error: ErrorDetails
}

struct ErrorDetails: Codable {
    let code: Int
    let message: String
    let errors: [ErrorReason]
}

struct ErrorReason: Codable {
    let message: String
    let domain: String
    let reason: String
    let location: String
    let locationType: String
}
