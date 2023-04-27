//
//  SearchUserCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/25/23.
//

import UIKit
import Kingfisher

class SearchUserCell: UICollectionViewCell {
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.width / 2
    }
    
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
        setUsernameLabelConstraints()
        setSeparatorViewConstraints()
    }
    
    private func setProfileImageViewConstraints() {
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
        
        ])
    }
    
    private func setUsernameLabelConstraints() {
        addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setSeparatorViewConstraints() {
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    public func configureCell(_ user: User) {
        guard let imageURL = URL(string: user.photoURL) else {return }
        usernameLabel.text = user.displayName
        profileImageView.kf.setImage(with: imageURL)
    }
}
