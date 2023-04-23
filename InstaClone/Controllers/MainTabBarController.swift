//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private lazy var mainFeedController: UIViewController = {
        let viewController = UINavigationController(rootViewController: HomeFeedController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home_unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home_selected")?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem.tag = 0
        return viewController
    }()
    
    private lazy var searchController: UIViewController = {
        let viewController = UINavigationController(rootViewController: SearchController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "search_unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "search_selected")?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem.tag = 1
        return viewController
    }()
    
    private lazy var addPostController: UIViewController = {
        let viewController = UINavigationController(rootViewController: AddPostController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "plus_unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
        viewController.tabBarItem.tag = 2
        return viewController
    }()
    
    private lazy var likeController: UIViewController = {
        let viewController = UINavigationController(rootViewController: LikeController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem.tag = 3
        return viewController
    }()
    
    private lazy var userProfileController: UIViewController = {
        let viewController = UINavigationController(rootViewController: UserProfileController())
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile_unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "profile_selected")?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem.tag = 4
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [mainFeedController, searchController, addPostController, likeController, userProfileController]
    }
}
