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
    
    public func createPost(postCaption: String, user: FirebaseAuth.User, completion: @escaping (Result<String, Error>) -> ()){
        let docRef = dataBase.collection(DataBaseService.postsCollections).document()
        dataBase.collection(DataBaseService.postsCollections).document(docRef.documentID).setData(["postCaption" : postCaption, "postedDate": Timestamp(date: Date()), "userName": user.displayName!, "userId": user.uid, "userPhotoURL": user.photoURL!.absoluteString]) { error in
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
    
    public func fetchUsers(completion: @escaping (Result<[User], Error>) ->()) {
        dataBase.collection(DataBaseService.usersCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let users = snapshot.documents.map { User($0.data())}
                completion(.success(users))
            }
        }
    }

//    public func fetchCurrentUser(completion: @escaping (Result<User, Error>) ->()) {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        dataBase.collection(DataBaseService.usersCollection).document(userId).getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let document = document {
//                let data = document.data()
//                let email = data?["email"] as? String ?? "no email"
//                let displayName = data?["displayName"] as? String ?? "no name"
//                let userId = userId
//                let photoURL = data?["photoURL"] as? String ?? "no photo url"
//                let createdDate = data?["createdDate"] as? Timestamp ?? Timestamp(date: Date())
//                let currentUser = User(email: email, createdDate: createdDate, displayName: displayName, userId: userId, photoURL: photoURL)
//                completion(.success(currentUser))
//            }
//        }
//    }
    
    // MARK: used snapshot listener instead of the below instance method for fetching user's posts
    public func fetchUsersPosts(userId: String, completion: @escaping (Result<[Post], Error>) ->()) {
        dataBase.collection(DataBaseService.postsCollections).whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                completion(.success(posts.sorted { $0.postedDate.dateValue() < $1.postedDate.dateValue() }))
            }
        }
    }
}
