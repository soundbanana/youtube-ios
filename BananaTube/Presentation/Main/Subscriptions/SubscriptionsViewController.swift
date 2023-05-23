//
//  SubscriptionsViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class SubscriptionsViewController: UIViewController {
    var presenter: SubscriptionsPresenter!

    private var activityIndicator: UIActivityIndicatorView!

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "Background")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        return collectionView
    }()

    lazy var noUserLabel: UILabel = {
        let label = UILabel()
        label.text = "No account provided"
        label.textColor = UIColor(named: "MainText")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLoadingIndicator()
    }

    func showLoadingIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showAuthorizedState() {
        noUserLabel.removeFromSuperview()
        setupAuthorizedView()
        setupNavigationBar()
    }

    func showUnauthorizedState() {
        collectionView.removeFromSuperview()
        setupNoUserView()
        setupNavigationBar()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(named: "Background")
        setupNavigationBar()
    }

    private func setupAuthorizedView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        self.edgesForExtendedLayout = []
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.refreshControl = refreshControl
    }

    private func setupNoUserView() {
        view.addSubview(noUserLabel)
        NSLayoutConstraint.activate([
            noUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noUserLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.bringSubviewToFront(activityIndicator)
    }

    @objc private func refresh(sender: UIRefreshControl) {
        Task {
            await presenter.obtainData()
            sender.endRefreshing()
            collectionView.reloadData()
        }
    }

    private func setupNavigationBar() {
        createCustomNavigationBar()

        navigationItem.leftBarButtonItem = createCustomTitle(text: "🍌BananaTube", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", selector: #selector(showProfile))
        let searchButton = createCustomButton(imageName: "magnifyingglass", selector: #selector(showSearch))

        navigationItem.rightBarButtonItems = [accountButton, searchButton]
    }

    func reloadData() {
        collectionView.reloadData()
    }

    @objc func showSearch() {
        presenter.showSearch()
    }

    @objc func showProfile() {
        presenter.showProfile()
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
        return presenter.getCollectionViewSize()
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
