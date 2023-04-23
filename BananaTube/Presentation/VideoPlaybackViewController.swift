//
//  VideoPlaybackViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 23.04.2023.
//

import UIKit
import SwiftUI
import youtube_ios_player_helper

class VideoPlaybackViewController: UIViewController {
    var playerView: YTPlayerView!

    override func viewDidLoad() {
        view.backgroundColor = .purple
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
