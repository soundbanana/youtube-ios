//
//  AuthenticationManagerTests.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 27.05.2023.
//

import XCTest
@testable import BananaTube

class AuthenticationManagerTests: XCTestCase {

    var authenticationManager: MockAuthenticationManager!

    override func setUp() {
        super.setUp()
        authenticationManager = MockAuthenticationManager.shared
    }

    override func tearDown() {
        authenticationManager = nil
        super.tearDown()
    }

    func testSignIn_Called() {
        // Given
        let presentingViewController = UIViewController()

        // When
        authenticationManager.signIn(withPresenting: presentingViewController) { _ in }

        // Then
        XCTAssertTrue(authenticationManager.signInCalled)
        XCTAssertEqual(authenticationManager.signInPresentingViewController, presentingViewController)
        XCTAssertNotNil(authenticationManager.signInCompletion)
    }

    func testSignOut_Called() {
        // When
        authenticationManager.signOut()

        // Then
        XCTAssertTrue(authenticationManager.signOutCalled)
    }

    func testConfigureAuthorization_Called() {
        // When
        authenticationManager.configureAuthorization { _ in }

        // Then
        XCTAssertTrue(authenticationManager.configureAuthorizationCalled)
        XCTAssertNotNil(authenticationManager.configureAuthorizationCompletion)
    }
}
