//
//  HomeFeedCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit
import Kingfisher

// MARK: *** Because a resized image was saved to firebase storage for purposes of saving space, the quality of the image won't be 100% when setting the image for the homeFeed controller ***


class HomeFeedCell: UICollectionViewCell {
    
    public lazy var userProfilePhotoimageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBlue
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    public lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "UserName"
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    public lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        optionsButton.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupProfilePhotoConstraints()
        setupImageViewConstraints()
        setupOptionsButtonConstraints()
        setupProfileNameLabelConstraints()
    }
    
    private func setupProfilePhotoConstraints() {
        addSubview(userProfilePhotoimageView)
        NSLayoutConstraint.activate([
            userProfilePhotoimageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            userProfilePhotoimageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userProfilePhotoimageView.widthAnchor.constraint(equalToConstant: 40),
            userProfilePhotoimageView.heightAnchor.constraint(equalTo: userProfilePhotoimageView.widthAnchor)
        ])
    }
    
    private func setupProfileNameLabelConstraints() {
        addSubview(profileNameLabel)
        NSLayoutConstraint.activate([
            profileNameLabel.topAnchor.constraint(equalTo: topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: userProfilePhotoimageView.trailingAnchor, constant: 8),
            profileNameLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: userProfilePhotoimageView.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupOptionsButtonConstraints() {
        addSubview(optionsButton)
        NSLayoutConstraint.activate([
            optionsButton.topAnchor.constraint(equalTo: topAnchor),
            optionsButton.bottomAnchor.constraint(equalTo: imageView.topAnchor),
            optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    public func configureCellPhoto(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        imageView.kf.setImage(with: url)
    }
    
    @objc private func handleOptions(_ sender: UIButton) {
        sender.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.isHighlighted = false
        }
        print("tapped")
    }
}
