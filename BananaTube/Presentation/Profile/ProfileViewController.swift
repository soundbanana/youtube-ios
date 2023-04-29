//
//  ProfileViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 27.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSignInButton()
    }

    private func setupSignInButton() {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signIn)))
        signInButton.center = view.center
        view.addSubview(signInButton)
    }

    @objc private func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                print("Error because \(String(describing: error?.localizedDescription))")
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Error in getting Token")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, _ in
                print(result?.user.email ?? "No user found")
            }
        }
    }
}
