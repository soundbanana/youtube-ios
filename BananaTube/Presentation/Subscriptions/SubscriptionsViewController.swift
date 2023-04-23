//
//  SubscriptionsViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class SubscriptionsViewController: UIViewController {

    var collectionView: UICollectionView! = nil

    var presenter: SubscriptionsPresenter!

    var subscriptionsList: [Item] = []

    override func viewDidLoad() {
        configureCollectionView()
        setupViews()
        presenter.obtainData()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        navigationItem.leftBarButtonItem = createCustomTitleButton(imageName: "light-icon", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", selector: nil)
        let searchButton = createCustomButton(imageName: "magnifyingglass", selector: nil)

        navigationItem.rightBarButtonItems = [accountButton, searchButton]
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

extension SubscriptionsViewController {

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

extension SubscriptionsViewController: UICollectionViewDelegate { }

extension SubscriptionsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        subscriptionsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell
            else {
            return UICollectionViewCell()
        }

        let sub = subscriptionsList[indexPath.row]

        cell.configureCell(videoInfo: sub.snippet!, statistics: sub.statistics!)
        return cell
    }
}
