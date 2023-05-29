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
        button.tintColor = UIColor(named: "MainText")
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
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
        label.numberOfLines = 2
        label.text = "Surname Name"
        label.textAlignment = .center
        label.textColor = UIColor(named: "MainText")
        label.font = label.font.withSize(28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "sample@sample.com"
        label.textAlignment = .center
        label.textColor = UIColor(named: "MainText")
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("sign_out_button".localized, for: .normal)
        button.backgroundColor = UIColor(red: 0.92, green: 0.81, blue: 0.37, alpha: 1)
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

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            userProfileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 150),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),

            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            emailLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            emailLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),

            signOutButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            signOutButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signOutButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    func setupSignInView() {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signIn)))
        signInButton.center = view.center

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(signInButton)
        view.addSubview(closeButton)
        view.addSubview(logoLabel)

        NSLayoutConstraint.activate([
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoLabel.heightAnchor.constraint(equalToConstant: 100),
            logoLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            logoLabel.rightAnchor.constraint(equalTo: view.rightAnchor),

            signInButton.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 10),
            signInButton.centerXAnchor.constraint(equalTo: logoLabel.centerXAnchor),

            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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
