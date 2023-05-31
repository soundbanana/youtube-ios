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
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(named: "MainText")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let logoLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "🍌BananaTube"
        titleLabel.textColor = UIColor(named: "MainText")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 50)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 75
        imageView.backgroundColor = UIColor(named: "MainText")
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Full Name"
        label.textAlignment = .center
        label.textColor = UIColor(named: "MainText")
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "sample@sample.com"
        label.textAlignment = .center
        label.textColor = UIColor(named: "MainText")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let signInButton: GIDSignInButton = {
        let button = GIDSignInButton(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("sign_out_button".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(named: "MainButton")
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        presenter.configureData()
    }

    func show(title: String, email: String, imageURL: URL!) {
        titleLabel.text = title
        emailLabel.text = email
        userProfileImageView.kf.setImage(with: imageURL)
    }

    func setupProfileView() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)

        view.addSubview(closeButton)
        view.addSubview(userProfileImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailLabel)
        view.addSubview(signOutButton)

        let spacing: CGFloat = 16

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            userProfileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: spacing),
            userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 150),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            signOutButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    func setupSignInView() {
        signInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signIn)))
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(signInButton)
        view.addSubview(closeButton)
        view.addSubview(logoLabel)

        let spacing: CGFloat = 16

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoLabel.heightAnchor.constraint(equalToConstant: 100),
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            signInButton.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: spacing),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

    @objc private func signIn() {
        presenter.signIn()
    }

    @objc private func signOut() {
        presenter.signOut()
    }
}
