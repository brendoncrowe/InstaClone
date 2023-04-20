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
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBackground
        return iv
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
    }
    
    private func setupHeaderUI() {
        backgroundColor = .blue
        profileImageView.layer.cornerRadius = 80 / 2
    }
    
    
    func fetchProfileImage() {
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
}
