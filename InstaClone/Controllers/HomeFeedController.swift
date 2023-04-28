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
    private var refreshControl: UIRefreshControl!

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
        getFollowedUsers()
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        homeFeedView.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getFollowedUsers), for: .valueChanged)
    }
    
    @objc private func getFollowedUsers() {
        DataBaseService.shared.fetchFollowedUsers { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let userIds):
                DispatchQueue.main.async {
                    self?.fetchPosts(userIds)
                }
            }
        }
    }
    
    private func fetchPosts(_ userIds: [String]) {
        DataBaseService.shared.fetchFollowedUsersPosts(userIds) { [weak self] result in
            DispatchQueue.main.async {
                 self?.refreshControl.endRefreshing()
             }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts
                }
            }
        }
    }
    
    private func setupCV() {
        homeFeedView.collectionView.dataSource = self
        homeFeedView.collectionView.delegate = self
        homeFeedView.collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
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
        // TODO: refactor below method 
        cell.configureCell(post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height: CGFloat = 56 //userProfile image view (40) plus top and bottom padding of 8
        height += width
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
}

extension HomeFeedController: UICollectionViewDelegateFlowLayout {

}
