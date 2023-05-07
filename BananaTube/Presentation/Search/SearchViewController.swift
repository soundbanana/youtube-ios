//
//  SearchViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    var presenter: SearchPresenter!

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .darkGray
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search BananaTube"
        search.backgroundImage = UIImage()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchView()
    }

    private func setupSearchView() {
        view.addSubview(closeButton)
        view.addSubview(searchBar)

        searchBar.delegate = self

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            closeButton.widthAnchor.constraint(equalToConstant: 25),

            searchBar.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            searchBar.leftAnchor.constraint(equalTo: closeButton.rightAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }

    @objc private func close() {
        self.dismiss(animated: false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            await presenter.search(searchText: searchBar.text!)
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await presenter.predict(searchText: searchText)
        }
    }
}
