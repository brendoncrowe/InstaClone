//
//  CaptionController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit

class CaptionController: UIViewController {
    
    private let captionView = CaptionView()
    private let storageService = StorageService()
    private var image: UIImage
    
    override func loadView() {
        super.loadView()
        view = captionView
    }
    
    init(_ image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configurePostButton()
        captionView.setCaptionViewImage(image)
    }
    
    private func configurePostButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostButton))
    }
    
    @objc private func handlePostButton() {
        // TODO: Send post to firebase db as well as store post image

    }
}
