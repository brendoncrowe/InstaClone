//
//  StorageService.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/19/23.
//

import UIKit
import FirebaseStorage

class StorageService {
    
    public let storageReference = Storage.storage().reference()
    
    public func uploadPhoto(userId: String? = nil, postId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) ->()) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        var photoReference: StorageReference!
        
        if let userId = userId {
            photoReference = storageReference.child("UserProfilePhotos/\(userId).jpg")
        } else if let postId = postId {
            photoReference = storageReference.child("PostPhotos/\(postId).jpg")
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metaData) { metaData, error in
            if let error = error {
                completion(.failure(error))
            } else if let _ = metaData {
                photoReference.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
