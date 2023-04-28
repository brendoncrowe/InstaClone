//
//  SearchedUserProfileHeader.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/26/23.
//

import UIKit
import FirebaseAuth
import Kingfisher

protocol SearchedProfileHeaderDelegate: AnyObject {
    func followButtonWasPressed(_ searchedProfileHeader: SearchedProfileHeader)
}

class SearchedProfileHeader: UICollectionViewCell {
    
    private var user: User?
    
    public weak var delegate: SearchedProfileHeaderDelegate?
    private var isFollowing = false {
        didSet {
            if isFollowing {
                unFollowButtonUI()
            } else {
                configFollowButton()
            }
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemBackground
        iv.layer.cornerRadius = 80 / 2
        return iv
    }()
    
    public lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    public lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "319\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "842\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    public lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        return button
    }()
    
    public lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    public lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    public lazy var bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
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
        setProfileImageViewConstraints()
        setupBottomToolBar()
        setUserNameLabelConstraints()
        setupUserStatsView()
        setEditProfileButtonConstraints()
        followButton.addTarget(self, action: #selector(handleFollowButton), for: .touchUpInside)
    }
    
    private func setProfileImageViewConstraints() {
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
    }
    
    private func setupBottomToolBar() {
        let topDividerView = UIView()
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        contentView.addSubview(topDividerView)
        contentView.addSubview(bottomDividerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            topDividerView.topAnchor.constraint(equalTo: stackView.topAnchor),
            topDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            bottomDividerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            bottomDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 0.7)
        ])
    }
        
    private func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUserNameLabelConstraints()  {
        contentView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            userNameLabel.bottomAnchor.constraint(equalTo: gridButton.topAnchor)
            
        ])
    }
    
    private func setEditProfileButtonConstraints() {
        contentView.addSubview(followButton)
        NSLayoutConstraint.activate([
            followButton.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 8),
            followButton.leadingAnchor.constraint(equalTo: postsLabel.leadingAnchor, constant: 8),
            followButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor),
            followButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    public func configureHeader(_ user: User, _ attributedText: NSAttributedString) {
        updateUI()
        self.user = user
        userNameLabel.text = user.displayName
        postsLabel.attributedText = attributedText
        guard let photoUrl = URL(string: user.photoURL) else { return }
        profileImageView.kf.setImage(with: photoUrl)
    }
    
    private func unFollowButtonUI() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.backgroundColor = .systemBackground
        followButton.layer.borderWidth = 1
        followButton.setTitleColor(UIColor.label, for: .normal)
        followButton.layer.cornerRadius = 3
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func configFollowButton() {
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        followButton.setTitleColor(.systemBackground, for: .normal)
        followButton.layer.cornerRadius = 3
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    @objc private func handleFollowButton() {
        guard let user = user else { return }
        if isFollowing { // remove from favorites
            DataBaseService.shared.unfollowUser(user: user) { [weak self] result in
                switch result {
                case .failure(let error):
                    print("Error unfollowing: \(error.localizedDescription)")
                case .success:
                    DispatchQueue.main.async {
                        self?.isFollowing = false
                    }
                }
            }
        } else { // add to favorites
            DataBaseService.shared.followUser(user: user) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error following user: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.isFollowing = true
                    }
                }
            }
        }
    }
    
    private func updateUI() {
        // check if item is favorited in order to update follow button
        guard let user = user else { return }
        DataBaseService.shared.checkUserIsFollowed(user: user) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error checking for following status: \(error)")
            case .success(let success):
                if success {
                    DispatchQueue.main.async {
                        self?.isFollowing = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.isFollowing = false
                    }
                }
            }
        }
    }
}
