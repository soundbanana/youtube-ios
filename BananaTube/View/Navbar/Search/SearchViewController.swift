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

    private let backButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "MainText")
        return button
    }()

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "search_placeholder".localized
        search.backgroundImage = UIImage()
        search.backgroundColor = UIColor(named: "Background")
        search.tintColor = UIColor(named: "MainText")
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(PredictionsTableViewCell.self, forCellReuseIdentifier: PredictionsTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureTableView()
        presenter.viewDidLoad()
    }

    func update(searchBarText: String) {
        searchBar.text = searchBarText
        Task {
            await presenter.predict(searchText: searchBarText)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func setupViews() {
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(tableView)

        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem

        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }

    @objc private func handleBackButtonTapped() {
        presenter.backButtonTapped()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            presenter.search(searchText: searchBar.text!)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await presenter.predict(searchText: searchText)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "text")
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
