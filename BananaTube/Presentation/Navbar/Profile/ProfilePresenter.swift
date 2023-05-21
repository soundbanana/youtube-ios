//
//  ProfilePresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 27.04.2023.
//

import UIKit

class ProfilePresenter {
    weak var view: ProfileViewController?
    var navigationController: UINavigationController?
    private var authenticationManager = AuthenticationManager.shared

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
