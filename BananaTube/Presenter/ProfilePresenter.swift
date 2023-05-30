//
//  ProfilePresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 27.04.2023.
//

import UIKit

class ProfilePresenter {
    private weak var view: ProfileViewController?
    private var authenticationManager: AuthenticationManager

    init(view: ProfileViewController, authenticationManager: AuthenticationManager) {
        self.view = view
        self.authenticationManager = authenticationManager
    }

    func signIn() {
        authenticationManager.signIn(withPresenting: view!) { error in
            if let error = error {
                print("Sign-in error: \(error.localizedDescription)")
            } else {
                self.view?.dismiss(animated: true)
            }
        }
    }

    func signOut() {
        authenticationManager.signOut()
        self.view?.dismiss(animated: true)
    }

    func configureData() {
        authenticationManager.configureAuthorization { [weak self] user in
            guard let title = user?.profile?.name,
                let email = user?.profile?.email,
                let imageURL = user?.profile?.imageURL(withDimension: 0) else {
                self?.view?.setupSignInView()
                return
            }
            self?.view?.setupProfileView()
            self?.view?.show(title: title, email: email, imageURL: imageURL)
        }
    }
}
