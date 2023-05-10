//
//  HomeFeedCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit
import Kingfisher
import FirebaseAuth

protocol HomeFeedCellDelegate: NSObject {
    func commentButtonTapped(_ homeFeedCell: HomeFeedCell, for post: Post)
    func profileNameButtonTapped(_ homeFeedCell: HomeFeedCell, for post: Post)
    func favoriteButtonTapped(_ homeFeedCell: HomeFeedCell, for post: Post)
}

class HomeFeedCell: UICollectionViewCell {
    
    public weak var delegate: HomeFeedCellDelegate?
    private var currentPost: Post?
    
    public lazy var userProfilePhotoimageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    public lazy var profileNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Username", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public lazy var photoImageView: UIImageView = {
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
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.isEnabled = true
        return button
    }()
    
    public lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    fileprivate func setupAttributedCaption(_ post: Post) {
        let attributedText = NSMutableAttributedString(string: post.displayName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.postCaption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.postedDate.dateValue().timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        captionLabel.attributedText = attributedText
    }
    
    private func commonInit() {
        setupProfilePhotoConstraints()
        setupImageViewConstraints()
        setupOptionsButtonConstraints()
        setupProfileNameLabelConstraints()
        setupActionButtons()
        setupCaptionLabelConstraints()
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        optionsButton.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        profileNameButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)

    }
    
    private func setupProfilePhotoConstraints() {
        contentView.addSubview(userProfilePhotoimageView)
        NSLayoutConstraint.activate([
            userProfilePhotoimageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            userProfilePhotoimageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userProfilePhotoimageView.widthAnchor.constraint(equalToConstant: 40),
            userProfilePhotoimageView.heightAnchor.constraint(equalTo: userProfilePhotoimageView.widthAnchor)
        ])
    }
    
    private func setupProfileNameLabelConstraints() {
        contentView.addSubview(profileNameButton)
        NSLayoutConstraint.activate([
            profileNameButton.topAnchor.constraint(equalTo: topAnchor),
            profileNameButton.leadingAnchor.constraint(equalTo: userProfilePhotoimageView.trailingAnchor, constant: 8),
            profileNameButton.bottomAnchor.constraint(equalTo: photoImageView.topAnchor),
        ])
    }
    
    private func setupImageViewConstraints() {
        contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: userProfilePhotoimageView.bottomAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        ])
    }
    
    private func setupOptionsButtonConstraints() {
        contentView.addSubview(optionsButton)
        NSLayoutConstraint.activate([
            optionsButton.topAnchor.constraint(equalTo: topAnchor),
            optionsButton.bottomAnchor.constraint(equalTo: photoImageView.topAnchor),
            optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            optionsButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        addSubview(bookmarkButton)
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCaptionLabelConstraints() {
        contentView.addSubview(captionLabel)
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    public func configureCell(_ post: Post) {
        self.currentPost = post
        profileNameButton.setTitle(post.displayName, for: .normal)
        setupAttributedCaption(post)
        guard let photoURL = URL(string: post.imageURL), let profileImageURL = URL(string: post.userPhotoURL) else { return }
        photoImageView.kf.setImage(with: photoURL)
        userProfilePhotoimageView.kf.setImage(with: profileImageURL)
    }
    
    // MARK: Button Actions
    
    @objc private func handleOptions() {
        print("options")
    }
    
    @objc private func handleComment() {
        if let post = currentPost {
            delegate?.commentButtonTapped(self, for: post)
        }
    }
    
    @objc func handleProfileButton() {
        if let post = currentPost {
            delegate?.profileNameButtonTapped(self, for: post)
        }
    }
    
    @objc func handleLike() {
        if let post = currentPost {
            delegate?.favoriteButtonTapped(self, for: post)
        }
    }
}
