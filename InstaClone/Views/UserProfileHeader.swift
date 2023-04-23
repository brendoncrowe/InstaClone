//
//  UserProfileCollectionViewHeader.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth
import Kingfisher

class UserProfileHeader: UICollectionViewCell {
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.fill")
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBackground
        return iv
    }()
    
    public lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    public lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
        setupHeaderUI()
        fetchProfileImage()
        setProfileImageViewConstraints()
        setupBottomToolBar()
        setUserNameLabelConstraints()
        setupUserStatsView()
        setEditProfileButtonConstraints()
    }
    
    private func setupHeaderUI() {
        guard let user = Auth.auth().currentUser else { return }
        profileImageView.layer.cornerRadius = 80 / 2
        userNameLabel.text = user.displayName
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
                    self?.profileImageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    private func setProfileImageViewConstraints() {
        addSubview(profileImageView)
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
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
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
            bottomDividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
        
    private func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUserNameLabelConstraints()  {
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            userNameLabel.bottomAnchor.constraint(equalTo: gridButton.topAnchor)
            
        ])
    }
    
    private func setEditProfileButtonConstraints() {
        addSubview(editProfileButton)
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 8),
            editProfileButton.leadingAnchor.constraint(equalTo: postsLabel.leadingAnchor, constant: 8),
            editProfileButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor),
            editProfileButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
