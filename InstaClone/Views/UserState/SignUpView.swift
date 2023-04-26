//
//  LoginView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit

class SignUpView: UIView {
    
    public lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        return button
    }()
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    public lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    public lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true // used to mask password text
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode // prevents autofill for password 
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    public lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.8)
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(presentSignUpController), for: .touchUpInside)
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
        setSignUpButtonConstraints()
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
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty != true && userNameTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .systemRed.withAlphaComponent(0.7)
        }
    }
    
    private func setSignUpButtonConstraints() {
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func presentSignUpController() {
        UIViewController.showViewController(LoginController())
    }
}

