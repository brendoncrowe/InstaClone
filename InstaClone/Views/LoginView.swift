//
//  LoginView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit

class LoginView: UIView {
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Don't have an account? Sign Up", for: .normal)
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
        setSignUpButtonConstraints()
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
}
