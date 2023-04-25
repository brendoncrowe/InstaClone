//
//  CaptionController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
        guard let postCaption = captionView.textView.text, !postCaption.isEmpty, let userName = Auth.auth().currentUser?.displayName else { return }
        let uploadImage = image
        // TODO: Send post to firebase db as well as store post image
        DataBaseService.shared.createPost(postCaption: postCaption, userName: userName) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Upload Error", message: "There was an error uploading the post. Try again.")
                }
            case .success(let docRef):
                self?.storageService.uploadPhoto(postId: docRef, image: uploadImage) { [weak self] result in
                    switch result {
                    case .failure:
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Photo Error", message: "Could not upload photo.")
                        }
                    case .success(let url):
                        self?.updateItemImageURL(url, documentId: docRef)
                    }
                }
            }
        }
    }
    
    private func updateItemImageURL(_ url: URL, documentId: String) {
        // update an existing document on Firebase
        Firestore.firestore().collection(DataBaseService.postsCollections).document(documentId).updateData(["imageURL": url.absoluteString]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to update item", message: "\(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}
