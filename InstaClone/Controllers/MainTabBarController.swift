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
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile_unselected"), selectedImage: UIImage(named: "profile_selected"))
        viewController.tabBarItem.tag = 0
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [userProfileController]
    }
}
