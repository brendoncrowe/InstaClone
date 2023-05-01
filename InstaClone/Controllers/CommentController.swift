//
//  CommentController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class CommentController: UIViewController {
    
    private var post: Post
    
    init(_ post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Comments"
    }
}
