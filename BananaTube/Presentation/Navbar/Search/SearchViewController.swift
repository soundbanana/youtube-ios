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

    private let closeButton: UIButton = {
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

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search BananaTube"
        search.backgroundImage = UIImage()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(PredictionsTableViewCell.self, forCellReuseIdentifier: PredictionsTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
    }

    private func setupSearchView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(closeButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.delegate = self
        closeButton.addTarget(self, action: #selector(handleCloseButtonTapped), for: .touchUpInside)
        setupTableView()

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            closeButton.heightAnchor.constraint(equalToConstant: 22),
            closeButton.widthAnchor.constraint(equalToConstant: 22),

            searchBar.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            searchBar.leftAnchor.constraint(equalTo: closeButton.rightAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleCloseButtonTapped() {
        self.dismiss(animated: false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.search(searchText: searchBar.text!)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await presenter.predict(searchText: searchText)
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "text")
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getPredictionsListSize()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PredictionsTableViewCell.identifier, for: indexPath) as? PredictionsTableViewCell else { return UITableViewCell() }
        presenter.configureCell(cell: cell, row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.rowTapped(row: indexPath.row)
    }
}
