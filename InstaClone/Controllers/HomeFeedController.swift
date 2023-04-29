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
    static let notificationName = NSNotification.Name(rawValue: "HomeControllerTapped")
    private var posts = [Post]() {
        didSet {
            homeFeedView.collectionView.reloadData()
        }
    }
    
    public var canScroll = false
    
    override func loadView() {
        super.loadView()
        view = homeFeedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupCV()
        getFollowedUsers()
        configureRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: HomeFeedController.notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canScroll = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        canScroll = false
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2")?.withTintColor(.label))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(cameraButtonTapped))
    }
    
    private func setupCV() {
        homeFeedView.collectionView.dataSource = self
        homeFeedView.collectionView.delegate = self
        homeFeedView.collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
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
    
    @objc private func scrollToTop() {
            let index = IndexPath(item: 0, section: 0)
            homeFeedView.collectionView.scrollToItem(at: index, at: .bottom, animated: true)
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
    
    @objc private func cameraButtonTapped() {
        let controller =  CameraController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
        
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
        let height: CGFloat = 176 + width //userProfile image view (40) plus top and bottom padding of 8
        return CGSize(width: width, height: height)
    }
}

extension HomeFeedController: UICollectionViewDelegateFlowLayout {

}
