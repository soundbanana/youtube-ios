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

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 75
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Surname Name"
        label.textAlignment = .center
        label.font = label.font.withSize(28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                setupSignInView()
            } else {
                // Show the app's signed-in state.
                setupProfileView()
                titleLabel.text = user?.profile?.name
                guard let imageURL = user?.profile?.imageURL(withDimension: 150) else { return }
                userProfileImageView.kf.setImage(with: imageURL)
                print("Already signed in")
            }
        }
    }

    private func setupProfileView() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(closeButton)
        view.addSubview(userProfileImageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            userProfileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 150),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupSignInView() {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signIn)))
        signInButton.center = view.center

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(signInButton)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    @objc private func signIn() {
        presenter.signIn()
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }
}
