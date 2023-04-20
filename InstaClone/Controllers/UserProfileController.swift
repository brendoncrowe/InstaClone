//
//  UserProfileController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth

class UserProfileController: UIViewController {
    
    private let userProfileView = UserProfileView()
    private let user = Auth.auth().currentUser
    private let cellId = "cellId"
    
    override func loadView() {
        super.loadView()
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = user?.displayName
        configureCV()
        configureSettingsTabBarButton()
    }
    
    private func configureCV() {
        userProfileView.collectionView.dataSource = self
        userProfileView.collectionView.delegate = self
        userProfileView.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        userProfileView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func configureSettingsTabBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc private func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                UserProfileController.showViewController(LoginController())
            } catch {
                self?.showAlert(title: "Error", message: "There was an error logging out: \(error)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension UserProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .systemOrange
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader else { fatalError("could not load header") }
        return header
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
