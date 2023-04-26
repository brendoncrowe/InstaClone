//
//  SearchedUserController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/26/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchedUserController: UIViewController {
    
    private let mainView = SearchedUserView()
    private let user: User
    private var listener: ListenerRegistration?
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
        }
    }
    
    init(_ user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
        override func loadView() {
            super.loadView()
            view = mainView
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = user.displayName
        configureCV()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener = Firestore.firestore().collection(DataBaseService.postsCollections).whereField("userId", isEqualTo: user.userId).addSnapshotListener({ [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Could not load posts: \(error)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                self?.posts = posts.sorted { $0.postedDate.dateValue() > $1.postedDate.dateValue() }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    
    private func configureCV() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(SearchedProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        mainView.collectionView.register(UserProfilePostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    @objc func editButtonPressed() {
        print("tapped")
    }
}

extension SearchedUserController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePostCell else {
            fatalError("could not dequeue a UserProfilePostCell")
        }
        let post = posts[indexPath.row]
        cell.setCellImage(post.imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? SearchedProfileHeader else { fatalError("could not load header") }
        let attributedText = NSMutableAttributedString(string: "\(posts.count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        header.configureHeader(user, attributedText)
        return header
    }
}

extension SearchedUserController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
