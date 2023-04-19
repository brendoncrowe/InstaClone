//
//  ViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private var authSession = AuthenticationSession()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loginView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    @objc func handleSignUp() {
        guard let email = loginView.emailTextField.text,
              !email.isEmpty,
              let userName = loginView.userNameTextField.text,
              !userName.isEmpty,
              let password = loginView.passwordTextField.text,
              !password.isEmpty else { return }
        
        authSession.createNewUser(email: email, password: password) { [weak self] result in
            switch result {
            case .failure(let error):
                print("there was an error creating a user: \(error.localizedDescription)")
            case .success(let authDataResult):
                print("created user: \(authDataResult.user.uid)")
                // after creating a user, store that user to the dataBase
                self?.createDatabaseUser(authDataResult: authDataResult, userName: userName)
            }
        }
    }
    
    // helper function for handleSignUp
    private func createDatabaseUser(authDataResult: AuthDataResult, userName: String) {
        DataBaseService.shared.createDataBaseUser(authDataResult: authDataResult, userName: userName) { result in
            switch result {
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
            case .success:
                print("user created")
            }
        }
    }
}

