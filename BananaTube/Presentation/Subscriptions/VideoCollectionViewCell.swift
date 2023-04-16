//
//  VideoCell.swift
//  YouTube
//
//  Created by Daniil Chemaev on 07.04.2023.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    private let networkImageManager = NetworkImageManager.instance

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()

    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleTextView: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)

        setConstraints()
    }

    func configureCell(
        videoInfo: Snippet,
        statistics: Statistics
    ) {
        titleLabel.text = videoInfo.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: videoInfo.publishedAt)

        subtitleTextView.text = "\(videoInfo.channelTitle!) \(statistics.viewCount) views \(date!.timeIntervalSince1970)"

        guard let url = URL(string: videoInfo.thumbnails.high.url) else { return }
        networkImageManager.image(imageURL: url) { [self] data, _ in
            let img = image(data: data)
            Task {
                thumbnailImageView.image = img
            }
        }
    }

    func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return nil
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 215),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            userProfileImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10),
            userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 50),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),

            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleTextView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)

            ]
        )
    }
}
