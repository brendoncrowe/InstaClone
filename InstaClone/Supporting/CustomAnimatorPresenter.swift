//
//  ViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class CustomAnimatorPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // custom animation transition
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from) else { return }
        containerView.addSubview(toView)
        
        let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        } completion: { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
