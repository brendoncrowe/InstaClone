//
//  ViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit
import FirebaseAuth
import PhotosUI

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private var authSession = AuthenticationSession()
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            loginView.addPhotoButton.layer.cornerRadius = loginView.addPhotoButton.frame.width / 2
            loginView.addPhotoButton.layer.masksToBounds = true
            loginView.addPhotoButton.layer.borderColor = UIColor.black.cgColor
            loginView.addPhotoButton.layer.borderWidth = 1
            loginView.addPhotoButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        loginView.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonPressed), for: .touchUpInside)
    }
    
    @objc private func signUpButtonPressed() {
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
                self?.createDatabaseUser(authDataResult: authDataResult, userName: userName, photoURL: "")
            }
        }
    }
    
    // helper function for handleSignUp
    private func createDatabaseUser(authDataResult: AuthDataResult, userName: String, photoURL: String) {
        DataBaseService.shared.createDataBaseUser(authDataResult: authDataResult, userName: userName, photoURL: photoURL) { result in
            switch result {
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
            case .success:
                print("user created")
            }
        }
    }
    
    private func changeProfileImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let phpController = PHPickerViewController(configuration: configuration)
        if let sheet = phpController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        phpController.delegate = self
        present(phpController, animated: true)
    }
    
    @objc private func addPhotoButtonPressed() {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.changeProfileImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension LoginViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let error = error {
                        self?.showAlert(title: "Image Error", message: "Could not set image: \(error)")
                        return
                    }
                    guard let image = image as? UIImage else {
                        print("could not typecast image data")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.selectedImage = image
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectedImage = image
        dismiss(animated: true)
    }
}

