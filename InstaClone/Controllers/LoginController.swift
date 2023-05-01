//
//  LoginController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    private let loginView = LoginView()
    private let authSession = AuthenticationSession()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        guard let email = loginView.emailTextField.text, !email.isEmpty, let password = loginView.passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Missing Fields", message: "Please make sure all fields are filled correctly.")
            return
        }
        authSession.signInExistingUser(email: email, password: password) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Login Error", message: "There is no account associated with the information entered. Make sure to enter in the correct login information.")
                }
            case .success(let user):
                DispatchQueue.main.async {
                    self?.navigateToMainView(user)
                }
            }
        }
    }
    
    private func navigateToMainView(_ user: User) {
        UIViewController.showViewController(MainTabBarController(user))
    }
}
