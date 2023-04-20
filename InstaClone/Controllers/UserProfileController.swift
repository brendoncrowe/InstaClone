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
    
    override func loadView() {
        super.loadView()
        view = userProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCV()
        fetchUserInfo()
    }
    
    private func configureCV() {
        userProfileView.collectionView.dataSource = self
        userProfileView.collectionView.delegate = self
        userProfileView.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        userProfileView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
    }
    
    
    private func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        navigationItem.title = user.displayName
    }
}


extension UserProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        header.backgroundColor = .green
        return header
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
