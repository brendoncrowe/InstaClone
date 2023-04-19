//
//  ViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit

class ViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
