//
//  HomeFeedCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomeFeedCell: UICollectionViewCell {
    
    public lazy var userProfilePhotoimageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
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
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    public lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true

        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " Some caption text that will describe the post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
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
    
    private func commonInit() {
        guard let user = Auth.auth().currentUser else { return }
        setupProfilePhotoConstraints()
        setupImageViewConstraints()
        setupOptionsButtonConstraints()
        setupProfileNameLabelConstraints()
        fetchProfileImage()
        setupActionButtons()
        setupCaptionLabelConstraints()
        profileNameLabel.text = user.displayName
        optionsButton.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
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
        contentView.addSubview(profileNameLabel)
        NSLayoutConstraint.activate([
            profileNameLabel.topAnchor.constraint(equalTo: topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: userProfilePhotoimageView.trailingAnchor, constant: 8),
            profileNameLabel.bottomAnchor.constraint(equalTo: photoImageView.topAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -8)
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
            bookmarkButton.rightAnchor.constraint(equalTo: rightAnchor),
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
    
    
    public func configureCellPhoto(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        photoImageView.kf.setImage(with: url)
    }
    
    private func fetchProfileImage() {
        guard let user = Auth.auth().currentUser else { return }
        DataBaseService.shared.fetchUserProfileImage(userId: user.uid) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let photoURL):
                let url = URL(string: photoURL)
                DispatchQueue.main.async {
                    self?.userProfilePhotoimageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    
    @objc private func handleOptions() {
        print("tapped")
    }
}
