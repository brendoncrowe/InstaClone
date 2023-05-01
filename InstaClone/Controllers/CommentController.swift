//
//  CommentController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class CommentController: UICollectionViewController {
    
    var customInputView: UIView!
    var sendButton: UIButton!
    let textField = CommentTextView()
    
    private var post: Post
    
    init(_ post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Comments"
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        
        if customInputView == nil {
            customInputView = CustomView()
            customInputView.backgroundColor = UIColor.systemGroupedBackground
            textField.placeholder = "enter comment"
            textField.font = .systemFont(ofSize: 15)
            textField.layer.cornerRadius = 5
            
            customInputView.autoresizingMask = .flexibleHeight
            
            customInputView.addSubview(textField)
            
            sendButton = UIButton(type: .system)
            sendButton.isEnabled = true
            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            sendButton.setTitle("Send", for: .normal)

            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            customInputView?.addSubview(sendButton)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            textField.maxHeight = 80
            
            textField.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor, constant: 12).isActive = true
            
            textField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: -8
                ).isActive = true
            
            textField.topAnchor.constraint(
                equalTo: customInputView.topAnchor,
                constant: 12
                ).isActive = true
            
            textField.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            
            sendButton.trailingAnchor.constraint(
                equalTo: customInputView.trailingAnchor,
                constant: -12
                ).isActive = true
            
            sendButton.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
        }
        return customInputView
    }
    
    @objc func handleSend() {
        print("works")
        self.textField.resignFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
}
