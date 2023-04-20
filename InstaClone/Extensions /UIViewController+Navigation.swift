//
//  UIViewController+Navigation.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit

extension UIViewController {
    
    private static func resetWindow(with rootViewController: UIViewController) {
        // the below code gets access to the window property in the sceneDelegate
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate, let window = sceneDelegate.window else {
            fatalError("could not reset window rootViewController")
        }
        window.rootViewController = rootViewController
    }
    
    public static func showViewController(_ viewController: UIViewController) {
        resetWindow(with: viewController)
    }
}

