//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private lazy var userProfileController: UIViewController = {
        let viewController = UINavigationController(rootViewController: UserProfileController())
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem.tag = 0
        return viewController
    }()
    
    private lazy var mainFeedController: UIViewController = {
        let viewController = UINavigationController(rootViewController: MainFeedController())
        viewController.tabBarItem = UITabBarItem(title: "feed", image: UIImage(systemName: "newspaper"), tag: 1)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [mainFeedController, userProfileController]
    }
}
