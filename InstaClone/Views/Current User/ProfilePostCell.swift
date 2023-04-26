//
//  UserProfilePostCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit
import Kingfisher

class ProfilePostCell: UICollectionViewCell {
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
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
        setImageViewConstraints()
    }
    
    public func setCellImage(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        imageView.kf.setImage(with: url)
    }
    
    private func setImageViewConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }
}
