//
//  LibraryViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class LibraryViewController: UIViewController {
    var presenter: LibraryPresenter!

    let testButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Test", for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()

        view.addSubview(testButton)
        testButton.addTarget(self, action: #selector(foo), for: .touchUpInside)

        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc func foo() {
        CoreDataManager.shared.createVideo("testtesttest", url: "google.com")
        print(CoreDataManager.shared.fetchVideos().first?.url)
        print(CoreDataManager.shared.fetchVideo(with: "testtesttest")?.url)
        Task {
            await presenter.obtainData()
        }
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = createCustomTitleButton(imageName: "light-icon", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", selector: #selector(showProfile))
        let searchButton = createCustomButton(imageName: "magnifyingglass", selector: #selector(showSearch))

        navigationItem.rightBarButtonItems = [accountButton, searchButton]
    }

    @objc func showSearch() {
        presenter.showSearch()
    }

    @objc func showProfile() {
        presenter.showProfile()
    }
}
