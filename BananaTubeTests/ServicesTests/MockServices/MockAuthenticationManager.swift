//
//  MockAuthenticationManager.swift
//  BananaTubeTests
//
//  Created by Daniil Chemaev on 27.05.2023.
//

import UIKit
import GoogleSignIn
@testable import BananaTube

class MockAuthenticationManager: AuthenticationManagerProtocol {

    static let shared = MockAuthenticationManager()

    var signInCalled = false
    var signInPresentingViewController: UIViewController?
    var signInCompletion: ((Error?) -> Void)?

    var signOutCalled = false

    var configureAuthorizationCalled = false
    var configureAuthorizationCompletion: ((GIDGoogleUser?) -> Void)?

    func signIn(withPresenting presentingViewController: UIViewController, completion: @escaping (Error?) -> Void) {
        signInCalled = true
        signInPresentingViewController = presentingViewController
        signInCompletion = completion
    }

    func signOut() {
        signOutCalled = true
    }

    func configureAuthorization(completion: @escaping (GIDGoogleUser?) -> Void) {
        configureAuthorizationCalled = true
        configureAuthorizationCompletion = completion
    }
}

