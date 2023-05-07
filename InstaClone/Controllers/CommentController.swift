//
//  CommentController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    private lazy var containerView: CommentAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentAccessoryView(frame: frame)
        return commentInputAccessoryView
    }()
    
    private var post: Post
    
    private var comments = [Comment]() {
        didSet {
            collectionView.reloadData()
            print(comments.count)
        }
    }
    
    init(_ post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        configureCV()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        containerView.delegate = self
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchComments() {
        DataBaseService.shared.fetchComments(postId: post.postId) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "could not load the comments for this post")
                }
            case .success(let comments):
                DispatchQueue.main.async {
                    self?.comments = comments
                }
            }
        }
    }
    
    private func configureCV() {
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 80)
    }
}

extension CommentController: CommentAccessoryViewDelegate {
    func postButtonWasPressed(_ commentAccessoryView: CommentAccessoryView, comment: String) {
        DataBaseService.shared.createComment(for: post, with: comment) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Comment Error", message: "There was an error posting the comment")
                }
            case .success:
                print("comment posted")
            }
        }
    }
}
