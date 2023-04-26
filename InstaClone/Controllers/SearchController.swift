//
//  SearchController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/23/23.
//

import UIKit
import FirebaseAuth

class SearchController: UIViewController {
    
    private let searchView = SearchView()
    private let cellId = "cellId"
    
    private var filteredUsers = [User]() {
        didSet {
            self.searchView.collectionView.reloadData()
        }
    }
    
    private var users = [User]() {
        didSet {
            filteredUsers = users
        }
    }
    
    override func loadView() {
        super.loadView()
        view = searchView
        fetchUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        navigationItem.titleView = searchView.searchBar
        searchView.searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchView.searchBar.resignFirstResponder()
    }
    
    private func configureCV() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        searchView.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func fetchUsers() {
        guard let currentUserName = Auth.auth().currentUser?.displayName else { return }
        DataBaseService.shared.fetchUsers { [weak self] result in
            switch result {
            case .failure(let error):
                print("Could not fetch users: \(error.localizedDescription)")
            case .success(let users):
                DispatchQueue.main.async {
                    self?.users = users.filter { $0.displayName != currentUserName }
                }
            }
        }
    }
}

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchView.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserSearchCell else {
            fatalError("could not dequeue a SearchUserCell")
        }
        let user = filteredUsers[indexPath.row]
        cell.configureCell(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = 66.0
        return CGSize(width: width, height: height)
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            filteredUsers = users
            return
        }
        filteredUsers = users.filter { $0.displayName.lowercased().contains(text.lowercased()) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
