//
//  VideoPlaybackViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 23.04.2023.
//

import UIKit
import SwiftUI
import youtube_ios_player_helper

class VideoPlaybackViewController: UIViewController, YTPlayerViewDelegate {
    var presenter: VideoPlaybackPresenter!

    private let backButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "MainText")
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let playerView: YTPlayerView = {
        let view = YTPlayerView()
        view.backgroundColor = UIColor(named: "Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(named: "MainText")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleTextView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AdditionalText")
        label.numberOfLines = 0
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        setupViews()
        presenter.configureData()
        createCustomNavigationBar()
    }

    func show(title: String, subtitle: String, videoId: String) {
        titleLabel.text = title
        subtitleTextView.text = subtitle
        playerView.load(withVideoId: videoId, playerVars: ["playsinline": 1])
    }

    private func setupViews() {
        setupNavigationBar()
        view.addSubview(playerView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleTextView)
        setConstraints()
    }

    private func setupNavigationBar() {
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor)
        ])

        let backButtonItem = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 215),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            subtitleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoPlaybackViewController
    func makeUIViewController (context: Context) -> VideoPlaybackViewController {
        VideoPlaybackViewController()
    }

    func updateUIViewController(_ uiViewController: VideoPlaybackViewController, context: Context) { }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
