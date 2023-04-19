//
//  LoginView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit

class LoginView: UIView {
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true // used to mask password text
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.systemBackground, for: .normal)
        return button
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
        setAddPhotoButtonConstraints()
        setupInputFields()
    }
    
    private func setAddPhotoButtonConstraints() {
        addSubview(addPhotoButton)
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 140),
            addPhotoButton.widthAnchor.constraint(equalTo: addPhotoButton.heightAnchor)
        ])
    }
    
    private func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        
        // stackView constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
