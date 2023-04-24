//
//  PhotoSelectorController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/23/23.
//

import UIKit

class PhotoSelectorController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        setupNavButtons()
    }
    
    private func setupNavButtons() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleDone))
    }
    
   @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        print("done")
    }
}
