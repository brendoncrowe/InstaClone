//
//  LoginView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit

class LoginView: UIView {
    
    private lazy var logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 12),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        return view
    }()
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
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
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    public lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(presentSignUpController), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .systemRed.withAlphaComponent(0.7)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setSignUpButtonConstraints()
        setLogoContainerViewConstraints()
        setupInputFields()
    }
    
    @objc private func presentSignUpController() {
        UIViewController.showViewController(SignUpController())
    }
    
    private func setSignUpButtonConstraints() {
        addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setLogoContainerViewConstraints() {
        addSubview(logoContainerView)
        NSLayoutConstraint.activate([
            logoContainerView.topAnchor.constraint(equalTo: topAnchor),
            logoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        
        // stackView constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
}
