//
//  PhotoPreviewView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/30/23.
//

import UIKit
import Photos

class PhotoPreviewView: UIView {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        setupConstraints()
        backgroundColor = .systemBackground
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        addSubview(photoImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 64),
            cancelButton.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        self.removeFromSuperview()
    }
    
    @objc private func saveButtonTapped() {
        guard let previewImage = photoImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        } completionHandler: { success, error in
            if let error = error {
                print("Error saving to phone: \(error.localizedDescription)")
            }
        }
        print("successfully saved")
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = "Photo was saved"
            savedLabel.numberOfLines = 0
            savedLabel.textAlignment = .center
            savedLabel.font = UIFont.preferredFont(forTextStyle: .title3)
            savedLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            savedLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
            savedLabel.center = self.center
            self.addSubview(savedLabel)
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            } completion: { (_) in
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    savedLabel.alpha = 0
                } completion: { (_) in
                    savedLabel.removeFromSuperview()
                }
            }
        }
    }
}
