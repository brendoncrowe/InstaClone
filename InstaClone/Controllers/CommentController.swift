//
//  CommentController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit
import FirebaseFirestore

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private var listener: ListenerRegistration?
    
    private lazy var containerView: CommentAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentAccessoryView(frame: frame)
        return commentInputAccessoryView
    }()
    
    private var post: Post
    
    private var comments = [Comment]() {
        didSet {
            collectionView.reloadData()
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
        listener?.remove()
    }
    
    override var inputAccessoryView: UIView? {
        containerView.delegate = self
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchComments() {
        listener = Firestore.firestore().collection(DataBaseService.postsCollections).document(post.postId).collection(DataBaseService.commentsCollection).addSnapshotListener({ [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Could not load comments", message: error.localizedDescription)
                }
            } else if let snapshot = snapshot {
                let comments = snapshot.documents.map { Comment($0.data()) }
                self?.comments = comments.sorted { $0.postedDate.dateValue() < $1.postedDate.dateValue() }
            }
        })
    }
    
    private func configureCV() {
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell else {
            fatalError("could not dequeue a comment cell")
        }
        let comment = comments[indexPath.row]
        cell.configureCell(with: comment)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // returning a dynamic cell size
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        let comment = comments[indexPath.row]
        dummyCell.configureCell(with: comment)
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 100)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
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
