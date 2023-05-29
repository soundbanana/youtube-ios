//
//  VideoCell.swift
//  YouTube
//
//  Created by Daniil Chemaev on 07.04.2023.
//

import UIKit
import Kingfisher

class VideoCollectionViewCell: UICollectionViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = label.font.withSize(16)
        label.textColor = UIColor(named: "MainText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleTextView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AdditionalText")
        label.numberOfLines = 2
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "live_label".localized
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.backgroundColor = .red
        label.font = label.font.withSize(14)
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

    func show(title: String, subtitle: String, imageURL: URL, liveBroadcast: Bool) {
        titleLabel.text = title
        subtitleTextView.text = subtitle
        thumbnailImageView.kf.setImage(with: imageURL)
        if liveBroadcast { setLiveLabel() }
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 215),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            userProfileImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10),
            userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 5),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 36),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 36),

            titleLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),

            subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleTextView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    func setLiveLabel() {
        addSubview(liveLabel)
        
        NSLayoutConstraint.activate([
            liveLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -5),
            liveLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: -5),
            liveLabel.widthAnchor.constraint(equalToConstant: 38)
        ])
    }
}
