//
//  SearchedUserController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/26/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchedUserProfileController: UIViewController {
    
    private let mainView = SearchedUserView()
    private let user: User
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    
    private func fetchPosts() {
        DataBaseService.shared.fetchUsersPosts(userId: user.userId) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error fetching user's posts: \(error)")
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts.sorted { $0.postedDate.dateValue() > $1.postedDate.dateValue() }
                }
            }
        }
    }
    
    private func configureCV() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(SearchedProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        mainView.collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    @objc func editButtonPressed() {
        print("tapped")
    }
}

extension SearchedUserProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ProfilePostCell else {
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

extension SearchedUserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
