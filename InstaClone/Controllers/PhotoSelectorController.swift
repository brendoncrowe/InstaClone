//
//  PhotoSelectorController.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/23/23.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private var images = [UIImage]()
    private var assets = [PHAsset]()
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        setupNavButtons()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhotos()
        
    }
    
    private func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        fetchOptions.fetchLimit = 30
        return fetchOptions
    }
    
    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { [weak self] asset, count, stop in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        self?.images.append(image)
                        self?.assets.append(asset)
                        
                        if self?.selectedImage == nil {
                            self?.selectedImage = image
                        }
                    }
                }
                if count == allPhotos.count - 1 {
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setupNavButtons() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButton))
    }
    
    @objc private func handleCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func handleNextButton() {
        guard let image = selectedImage else { return }
        let captionController = CaptionController(image)
        navigationController?.pushViewController(captionController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? PhotoSelectorHeader else {
            fatalError("could not load PhotoSelectorHeader")
        }
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { image, info in
                    if let image = image {
                        header.configureHeaderPhoto(image)
                    }
                }
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        collectionView.reloadData()
        // makes the collection view scroll to the top
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoSelectorCell else { fatalError("Could not load a PhotoSelectorCell")}
        let image = images[indexPath.row]
        cell.configureCellPhoto(image)
        return cell
    }
}
