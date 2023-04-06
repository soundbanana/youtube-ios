//
//  VideoCell.swift
//  YouTube
//
//  Created by Daniil Chemaev on 07.04.2023.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setConstraints()
        self.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
        setConstraints()
    }

    func setupView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }

    func configureCell(name: String) {
        label.text = name
    }


    func setConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
            ]
        )
    }
}

