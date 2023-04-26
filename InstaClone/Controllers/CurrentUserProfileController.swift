//
//  UserProfileController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class CurrentUserProfileController: UIViewController {
    
    private let userProfileView = UserProfileView()
    private let user = Auth.auth().currentUser
    private var listener: ListenerRegistration?
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.userProfileView.collectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = user?.displayName
        configureCV()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSettingsTabBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    private func fetchPosts() {
        DataBaseService.shared.fetchUsersPosts(userId: user!.uid) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error fetching user's posts: \(error)")
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts
                }
            }
        }
    }
    
    private func configureCV() {
        userProfileView.collectionView.dataSource = self
        userProfileView.collectionView.delegate = self
        userProfileView.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        userProfileView.collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func configureSettingsTabBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc private func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                CurrentUserProfileController.showViewController(LoginController())
            } catch {
                self?.showAlert(title: "Error", message: "There was an error logging out: \(error)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func editButtonPressed() {
        print("tapped")
    }
}

extension CurrentUserProfileController: UICollectionViewDataSource {
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? UserProfileHeader else { fatalError("could not load header") }
        let attributedText = NSMutableAttributedString(string: "\(posts.count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        header.configureHeader(user!, attributedText)
        return header
    }
}

extension CurrentUserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
