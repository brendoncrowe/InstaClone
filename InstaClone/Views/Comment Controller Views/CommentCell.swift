//
//  CommentCell.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/7/23.
//

import UIKit
import Kingfisher

class CommentCell: UICollectionViewCell {
    
    private lazy var profilePhotoView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    private lazy var commentTextView: UITextView = {
       let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
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
        setProfilePhotoImageConstraints()
        setCommentLabelConstraints()
    }
    
    private func setProfilePhotoImageConstraints() {
        addSubview(profilePhotoView)
        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profilePhotoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profilePhotoView.widthAnchor.constraint(equalToConstant: 40),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setCommentLabelConstraints() {
        addSubview(commentTextView)
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            commentTextView.leadingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: 8),
            commentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            commentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4)
        ])
    }
    
    public func configureCell(with comment: Comment) {
        let attributedText = NSMutableAttributedString(string: comment.displayName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.label])
        attributedText.append(NSAttributedString(string: " " + comment.commentText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label]))
        commentTextView.attributedText = attributedText
        guard let photoURL = URL(string: comment.userPhotoURL) else { return }
        profilePhotoView.kf.setImage(with: photoURL)
    }
}
