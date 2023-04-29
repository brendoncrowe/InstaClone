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
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupCaptureSession()
        setupConstraints()
        capturePhotoButton.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
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
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
    
    private func setupConstraints() {
        view.addSubview(capturePhotoButton)
        NSLayoutConstraint.activate([
            capturePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            capturePhotoButton.widthAnchor.constraint(equalToConstant: 80),
            capturePhotoButton.heightAnchor.constraint(equalTo: capturePhotoButton.widthAnchor),
            capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func handleCapturePhoto() {
        print("capturing photo")
    }
}
