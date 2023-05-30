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

    private let playerView: YTPlayerView = {
        let view = YTPlayerView()
        view.backgroundColor = UIColor(named: "Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor(named: "MainText")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleTextView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AdditionalText")
        label.numberOfLines = 2
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
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
        view.addSubview(playerView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleTextView)
        setConstraints()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 215),
            playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.rightAnchor),

            titleLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),

            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleTextView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            subtitleTextView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
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

    func updateUIViewController(_ uiViewController: VideoPlaybackViewController, context: Context) {}
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
