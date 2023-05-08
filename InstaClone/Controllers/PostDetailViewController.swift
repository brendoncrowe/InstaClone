//
//  PostDetailViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/7/23.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    private let postDetailView = PostDetailView()
    private let post: Post
    
    init(_ post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = postDetailView
        navigationItem.title = "Photo"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    private func configureUI() {
        postDetailView.profileNameLabel.text = post.displayName
        postDetailView.setupAttributedCaption(post)
        guard let photoURL = URL(string: post.imageURL), let profileImageURL = URL(string: post.userPhotoURL) else { return }
        postDetailView.photoImageView.kf.setImage(with: photoURL)
        postDetailView.userProfilePhotoimageView.kf.setImage(with: profileImageURL)
    }
}
