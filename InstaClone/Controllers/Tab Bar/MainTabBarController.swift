//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    static let notificationName = NSNotification.Name(rawValue: "HomeControllerTapped")
    
    private lazy var homeFeedController: UIViewController = {
        let viewController = UINavigationController(rootViewController: HomeFeedController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house")?.withBaselineOffset(fromBottom: UIFont.systemFontSize + 8), tag: 1)
        return viewController
    }()
    
    private lazy var searchController: UIViewController = {
        let viewController = UINavigationController(rootViewController: SearchController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass")?.withBaselineOffset(fromBottom: UIFont.systemFontSize + 8), tag: 1)
        return viewController
    }()
    
    private lazy var addPostController: UIViewController = {
        let viewController = UINavigationController(rootViewController: AddPostController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app")?.withBaselineOffset(fromBottom: UIFont.systemFontSize + 8), tag: 2)
        return viewController
    }()
    
    private lazy var favoritesController: UIViewController = {
        let viewController = UINavigationController(rootViewController: FavoritesController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart")?.withBaselineOffset(fromBottom: UIFont.systemFontSize + 8), tag: 3)
        return viewController
    }()
    
    private lazy var userProfileController: UIViewController = {
        let viewController = UINavigationController(rootViewController: CurrentUserProfileController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person")?.withBaselineOffset(fromBottom: UIFont.systemFontSize + 8), tag: 4)
        return viewController
    }()
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [homeFeedController, searchController, addPostController, favoritesController, userProfileController]
        tabBar.standardAppearance = setIconColor()
    }
    
    
    private func setIconColor() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = .label
        appearance.compactInlineLayoutAppearance.selected.iconColor = .label
        appearance.inlineLayoutAppearance.selected.iconColor = .label
        return appearance
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let photSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photSelectorController)
            present(navController, animated: true)
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navController = tabBarController.viewControllers?.first as? UINavigationController, let homeFeedController = navController.viewControllers.first as? HomeFeedController else {
            return
        }
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 0 {
            if homeFeedController.canScroll == true {
                NotificationCenter.default.post(name: MainTabBarController.notificationName, object: nil)
            }
        }
    }
}

extension UITabBarItem {
    func setIconColor(_ color: UIColor) {
        image = image?.withRenderingMode(.alwaysTemplate)
        selectedImage = selectedImage?.withRenderingMode(.alwaysTemplate)
        setTitleTextAttributes([.foregroundColor: color], for: .selected)
        setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
}
