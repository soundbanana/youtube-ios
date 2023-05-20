//
//  ProfilePresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 27.04.2023.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleAPIClientForREST

class ProfilePresenter {
    weak var view: ProfileViewController?
    var navigationController: UINavigationController?

    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        // Create Google Sign In scopes object.
        let scopes = [kGTLRAuthScopeYouTubeReadonly]
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: view!, hint: "Hint", additionalScopes: scopes) { result, error in
            guard error == nil else {
                print("Error because \(String(describing: error?.localizedDescription))")
                return
            }

            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
                else {
                print("Error because \(String(describing: error?.localizedDescription))")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            GoogleServices.youtubeService.authorizer = user.fetcherAuthorizer

            Auth.auth().signIn(with: credential) { result, error in
                if error != nil {
                    print("Error while signing in \(String(describing: error!.localizedDescription))")
                    return
                } else {
                    guard let userEmail = result?.user.email else {
                        print("No email found")
                        return
                    }
                    Constants.USER_EMAIL = userEmail
                    print(userEmail)
                    // TODO add alert when sign in is failed
                    self.view?.dismiss(animated: true)
                }
            }
        }
    }

    func signOut() {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        self.view?.dismiss(animated: true)
    }

    func configureData() {
        guard let currentUser = Auth.auth().currentUser else {
            view?.setupSignInView()
            return
        }
        view?.setupProfileView()

        let title = currentUser.displayName!
        let email = currentUser.email!

        // Just for better quality
        GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
            guard error == nil || user == nil else { return }
            guard let imageURL = user?.profile?.imageURL(withDimension: 0) else { return }
            view?.show(title: title, email: email, imageURL: imageURL)
        }
    }
}
