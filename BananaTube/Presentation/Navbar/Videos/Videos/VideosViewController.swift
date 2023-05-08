//
//  VideosCollectionView.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit

class VideosViewController: UIViewController {
    var collectionView: UICollectionView! = nil

    var presenter: VideosPresenter!

    var videosList: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupViews()
        presenter.obtainData()
        print(videosList)
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        self.edgesForExtendedLayout = []
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
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
//        presenter.showDetails(row: indexPath.row)
    }
}
