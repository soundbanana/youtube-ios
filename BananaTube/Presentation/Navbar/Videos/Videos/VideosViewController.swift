//
//  VideosCollectionView.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit

class VideosViewController: UIViewController {
    var presenter: VideosPresenter!

    var collectionView: UICollectionView! = nil

    var videosList: [Item] = []

    private let backButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "MainText")
        return button
    }()

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search BananaTube"
        search.sizeToFit()
        search.backgroundImage = UIImage()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureCollectionView()
        setupViews()
        Task {
            await presenter.obtainData()
        }
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        self.edgesForExtendedLayout = []

        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem

        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    @objc private func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func update(searchBarText: String) {
        searchBar.text = searchBarText
    }
}

extension VideosViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return self.createVideosSection()
    }

    private func createVideosSection() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(300))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - UICollectionViewDelegate

extension VideosViewController: UICollectionViewDelegate { }

extension VideosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        presenter.configureCell(cell: cell, row: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(row: indexPath.row)
    }
}

extension VideosViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        presenter.showSearch()
    }
}
