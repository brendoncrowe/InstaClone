//
//  SearchController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/23/23.
//

import UIKit

class SearchController: UIViewController {
    
    private let searchView = SearchView()
    private let cellId = "cellId"
    
    private var users = [User]() {
        didSet {
            self.searchView.collectionView.reloadData()
        }
    }
    
    private var userResults = [User]()
    
    private let searchController: UISearchController = {
        let sc = UISearchController()
        sc.loadViewIfNeeded()
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "search users"
        sc.searchBar.enablesReturnKeyAutomatically = false
        sc.searchBar.returnKeyType = UIReturnKeyType.default
        return sc
    }()
    
    override func loadView() {
        super.loadView()
        view = searchView
        fetchUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search users"
        configureCV()
    }
    
    private func configureCV() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        searchView.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func fetchUsers() {
        DataBaseService.shared.fetchUsers { [weak self] result in
            switch result {
            case .failure(let error):
                print("Could not fetch users: \(error.localizedDescription)")
            case .success(let users):
                DispatchQueue.main.async {
                    self?.users = users
                    self?.userResults = users
                }
            }
        }
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            users = userResults
            return
        }
        users = userResults.filter { $0.displayName.lowercased().contains(text.lowercased()) }
    }
}

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchView.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserSearchCell else {
            fatalError("could not dequeue a SearchUserCell")
        }
        let user = users[indexPath.row]
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
