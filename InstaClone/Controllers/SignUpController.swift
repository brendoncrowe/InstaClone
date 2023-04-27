//
//  ViewController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit
import FirebaseAuth
import PhotosUI
import Mantis


class SignUpController: UIViewController {
    
    private let loginView = SignUpView()
    private var authSession = AuthenticationSession()
    private let storageService = StorageService()
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            setNewPhoto()
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
    
    private func setNewPhoto() {
        loginView.addPhotoButton.layer.cornerRadius = loginView.addPhotoButton.frame.width / 2
        loginView.addPhotoButton.layer.masksToBounds = true
        loginView.addPhotoButton.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        loginView.addPhotoButton.layer.borderWidth = 2
        loginView.addPhotoButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @objc private func signUpButtonPressed() {
        guard let email = loginView.emailTextField.text,
              !email.isEmpty,
              let displayName = loginView.userNameTextField.text,
              !displayName.isEmpty,
              let password = loginView.passwordTextField.text,
              !password.isEmpty, let selectedImage = selectedImage else { return }
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: loginView.addPhotoButton.bounds)
        authSession.createNewUser(email: email, password: password) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "There was an error creating a user: \(error.localizedDescription)")
                }
            case .success(let authDataResult):
                // call storage service first in order to get photoURL for database user
                self?.storageService.uploadPhoto(userId: authDataResult.user.uid, postId: nil, image: resizedImage) { result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Photo Error", message: "There was an error saving the profile photo: \(error.localizedDescription).")
                        }
                    case .success(let photoURL):
                        self?.createDatabaseUser(authDataResult: authDataResult, displayName: displayName, photoURL: photoURL.absoluteString)
                        DispatchQueue.main.async {
                            self?.continueSignUpFlow(displayName)
                        }
                    }
                }
            }
        }
    }
    
    private func continueSignUpFlow(_ userName: String) {
        UIViewController.showViewController(MainTabBarController())
    }
    // helper function for handleSignUp
    private func createDatabaseUser(authDataResult: AuthDataResult, displayName: String, photoURL: String) {
        DataBaseService.shared.createDataBaseUser(authDataResult: authDataResult, displayName: displayName, photoURL: photoURL) { result in
            switch result {
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
            case .success:
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName  // set the display name of current user
                request?.photoURL = URL(string: photoURL)
                request?.commitChanges(completion: { error in
                    if let error = error {
                        print("Error setting display name: \(error.localizedDescription)")
                    } else {
                        print("success creating user")
                    }
                })
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
    
    private func cropPhotoController(for image: UIImage) {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
}

extension SignUpController: PHPickerViewControllerDelegate {
    
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
                        self?.cropPhotoController(for: image)
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectedImage = image
        dismiss(animated: true)
    }
}

extension SignUpController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        selectedImage = cropped
        dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        dismiss(animated: true)
    }
}

