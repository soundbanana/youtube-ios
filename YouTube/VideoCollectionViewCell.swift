//
//  VideoCell.swift
//  YouTube
//
//  Created by Daniil Chemaev on 07.04.2023.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        return imageView
    }()

    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .purple
        label.numberOfLines = 2
        label.text = "12312312312312312317826348723846782367846278364872346823678678624786823123123123"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleTextView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.numberOfLines = 1
        label.text = "123123123123123123123123123123"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
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

    func configureCell(name: String) {
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 200),
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
