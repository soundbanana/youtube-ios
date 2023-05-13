//
//  LibraryViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class LibraryViewController: UIViewController {
    var presenter: LibraryPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
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
