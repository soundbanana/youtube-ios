//
//  AuthenticationManager.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 21.05.2023.
//

import Foundation
import Firebase
import GoogleSignIn
import GoogleAPIClientForREST

enum State {
    case authorized
    case unauthorized
}

class AuthenticationManager {
    static let shared = AuthenticationManager()

    private(set) var state: State = .unauthorized

    func signIn(withPresenting presentingViewController: UIViewController, completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let scopes = [kGTLRAuthScopeYouTubeReadonly]

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, hint: "Hint", additionalScopes: scopes) { result, error in
            guard error == nil else {
                completion(error)
                return
            }

            guard let user = result?.user,
                let idToken = user.idToken?.tokenString else {
                completion(error)
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            GoogleServices.youtubeService.authorizer = user.fetcherAuthorizer

            Auth.auth().signIn(with: credential) { result, error in
                if error != nil || result == nil {
                    print("Error while signing in \(String(describing: error!.localizedDescription))")
                    completion(error)
                } else {
                    self.state = .authorized
                    UserStore.shared.signIn()
                    Constants.USER_EMAIL = result!.user.email!
                    completion(nil)
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            Constants.USER_EMAIL = ""
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        self.state = .unauthorized
        UserStore.shared.signOut()
    }

    func configureAuthorization(completion: @escaping (_ user: GIDGoogleUser?) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
            completion(user)
        }
    }
}
