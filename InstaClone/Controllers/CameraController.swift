//
//  CameraController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/28/23.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    var outPut = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var customAnimationPresenter = CustomAnimatorPresenter()
    var customAnimationDismisser = CustomAnimatorDismisser()
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.right.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCaptureSession()
        setupConstraints()
        capturePhotoButton.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
        transitioningDelegate = self
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print(error)
        }
        if captureSession.canAddOutput(outPut) {
            captureSession.addOutput(outPut)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
    
    private func setupConstraints() {
        view.addSubview(capturePhotoButton)
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            capturePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            capturePhotoButton.widthAnchor.constraint(equalToConstant: 80),
            capturePhotoButton.heightAnchor.constraint(equalTo: capturePhotoButton.widthAnchor),
            capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        outPut.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func dismissCamera() {
        dismiss(animated: true)
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let previewImage = UIImage(data: imageData) else { return }
        let containerView = PhotoPreviewView()
        self.view.addSubview(containerView)
        containerView.frame = view.frame
        containerView.photoImageView.image = previewImage
    }
}

extension CameraController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
}
