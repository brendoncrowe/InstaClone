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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        navigationItem.titleView = searchView.searchBar
        searchView.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
    }
    
    private func configureCV() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        searchView.collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func fetchUsers() {
        // the below currentUser is needed to remove the current user from appearing in users array
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
        guard let cell = searchView.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchUserCell else {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        let viewController =  SearchedUserProfileController(user)
        navigationController?.pushViewController(viewController, animated: true)
    }
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
