//
//  MainFeedController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth

class HomeFeedController: UIViewController {
    
    private let homeFeedView = HomeFeedView()
    private let cellId = "cellId"
    
    private var posts = [Post]() {
        didSet {
            homeFeedView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        view = homeFeedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2")?.withTintColor(.label))
        setupCV()
        fetchPosts()
    }
    
    private func setupCV() {
        homeFeedView.collectionView.dataSource = self
        homeFeedView.collectionView.delegate = self
        homeFeedView.collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func fetchPosts() {
        guard let user = Auth.auth().currentUser else { return }
        DataBaseService.shared.fetchCurrentUsersPosts(userId: user.uid) { [weak self] result in
            switch result {
            case .failure:
                print("could not load posts")
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts
                }
            }
        }
    }
}

extension HomeFeedController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = homeFeedView.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeFeedCell else {
            fatalError("could not dequeue a HomeFeedCell")
        }
        let post = posts[indexPath.row]
        cell.configureCellPhoto(post.imageURL)
        return cell
    }
}

extension HomeFeedController: UICollectionViewDelegateFlowLayout {

}
