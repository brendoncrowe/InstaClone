//
//  DatabaseService.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DataBaseService {
    
    static let shared = DataBaseService()
    private init() {}
    
    static let usersCollection = "users"
    static let postsCollections = "posts"
    
    private let dataBase = Firestore.firestore()
    // creating a user for the users collection in the database to more easily access
    public func createDataBaseUser(authDataResult: AuthDataResult, displayName: String, photoURL: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let email = authDataResult.user.email else { return }
        dataBase.collection(DataBaseService.usersCollection).document(authDataResult.user.uid).setData(["email": email, "createdDate": Timestamp(date: Date()), "userId": authDataResult.user.uid, "displayName": displayName, "photoURL": photoURL]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func createPost(postCaption: String, userName: String, completion: @escaping (Result<String, Error>) -> ()){
        guard let user = Auth.auth().currentUser else { return }
        let docRef = dataBase.collection(DataBaseService.postsCollections).document()
        dataBase.collection(DataBaseService.postsCollections).document(docRef.documentID).setData(["postCaption" : postCaption, "postedData": Timestamp(date: Date()), "userName": userName, "userId": user.uid]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
    }
    
    public func fetchUserProfileImage(userId: String, completion: @escaping (Result<String, Error>) ->()) {
        dataBase.collection(DataBaseService.usersCollection).document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                guard let photoURL = snapshot.get("photoURL") as? String else { return }
                completion(.success(photoURL))
            }
        }
    }
    
    public func fetchCurrentUsersPosts(userId: String, completion: @escaping (Result<[Post], Error>) ->()) {
        guard let user = Auth.auth().currentUser else { return }
        dataBase.collection(DataBaseService.postsCollections).whereField("userId", isEqualTo: user.uid).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                completion(.success(posts.sorted { $0.postedDate.dateValue() > $1.postedDate.dateValue() }))
            }
        }
    }
}
