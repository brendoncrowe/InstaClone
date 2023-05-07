//
//  CommentView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

protocol CommentAccessoryViewDelegate: NSObject {
    func postButtonWasPressed(_ commentAccessoryView: CommentAccessoryView)
}

class CommentAccessoryView: UIView {
    
    weak var delegate: CommentAccessoryViewDelegate?
    
    public let textView: FlexibleTextView = {
        let tv = FlexibleTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.autocapitalizationType = .none
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        return tv
    }()
    
    private let postButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setTitle("Post", for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        viewConfiguration()
        addSubview(textView)
        addSubview(postButton)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            textView.trailingAnchor.constraint(equalTo: postButton.leadingAnchor)
            
        ])
        NSLayoutConstraint.activate([
            postButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            postButton.widthAnchor.constraint(equalToConstant: 50),
            postButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        postButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private func viewConfiguration() {
        postButton.isEnabled = false
        textView.delegate = self
        textView.layer.cornerRadius = 8
        textView.maxHeight = 100
        autoresizingMask = .flexibleHeight
        backgroundColor = .systemGroupedBackground
    }
    
    @objc func handleSend() {
        delegate?.postButtonWasPressed(self)
        textView.resignFirstResponder()
        textView.text.removeAll()
        postButton.isEnabled = false
    }
}

extension CommentAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty else {
            postButton.isEnabled = false
            return
        }
        postButton.isEnabled = true
    }
}
