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
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Mazda RX-7 from the bush is back | NIGHTRIDE"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleTextView: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 2
        label.text = "71K views  12 hours ago"
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupViews()
        playerView.load(withVideoId: "ZRt9KJtNSJg", playerVars: ["playsinline": 1])
    }

    func update(video: Item) {
        titleLabel.text = video.snippet?.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = Date().addingTimeInterval(dateFormatter.date(from: video.snippet!.publishedAt)!.timeIntervalSinceNow)

        let formatter = RelativeDateTimeFormatter()
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        subtitleTextView.text = "\(video.snippet!.channelTitle!) \(video.statistics!.viewCount) views \(relativeDate)"
        titleLabel.text = video.snippet?.title
    }

    private func setupViews() {
        view.addSubview(playerView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleTextView)
        setConstraints()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 215),
            playerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

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
    func updateUIViewController(_ uiViewController: VideoPlaybackViewController, context: Context) {
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
