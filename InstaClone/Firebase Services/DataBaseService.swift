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
    static let followingCollection = "following"
    
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
        dataBase.collection(DataBaseService.postsCollections).document(docRef.documentID).setData(["postCaption" : postCaption, "postedDate": Timestamp(date: Date()), "displayName": user.displayName!, "userId": user.uid, "userPhotoURL": user.photoURL!.absoluteString]) { error in
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
    
    public func fetchFollowedUsers(completion: @escaping (Result<[String], Error>) ->()) {
        guard let user = Auth.auth().currentUser else { return }
        var userIds = [String]()
        dataBase.collection(DataBaseService.usersCollection).document(user.uid).collection(DataBaseService.followingCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let count = snapshot.documents.count
                if count > 0  {
                    let followedUsers = snapshot.documents.map { User($0.data()) }
                    for user in followedUsers {
                        userIds.append(user.userId)
                    }
                    completion(.success(userIds))
                } else {
                    completion(.success([""]))
                }
            }
        }
    }
    
    public func followUser(user: User, completion: @escaping (Result<Bool, Error>) ->()) {
        guard let currentUser = Auth.auth().currentUser else { return }
        dataBase.collection(DataBaseService.usersCollection).document(currentUser.uid).collection(DataBaseService.followingCollection).document(user.userId).setData(["userName": user.displayName, "userId": user.userId, "email": user.email, "photoURL": user.photoURL, "followedDate": Timestamp(date: Date())]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func unfollowUser(user: User, completion: @escaping (Result<Bool, Error>) ->()) {
        guard let currentUser = Auth.auth().currentUser else { return }
        dataBase.collection(DataBaseService.usersCollection).document(currentUser.uid).collection(DataBaseService.followingCollection).document(user.userId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func checkUserIsFollowed(user: User, completion: @escaping (Result<Bool, Error>) ->()) {
        guard let currentUser = Auth.auth().currentUser else { return }
        dataBase.collection(DataBaseService.usersCollection).document(currentUser.uid).collection(DataBaseService.followingCollection).whereField("userId", isEqualTo: user.userId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot { // the below code is a simple logic check for documents stored when a user is followed
                let count = snapshot.documents.count
                if count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    // MARK: used snapshot listener instead of the below instance method for fetching user's posts
    public func fetchUserPosts(userId: String, completion: @escaping (Result<[Post], Error>) ->()) {
        dataBase.collection(DataBaseService.postsCollections).whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                completion(.success(posts.sorted { $0.postedDate.dateValue() < $1.postedDate.dateValue() }))
            }
        }
    }
    
    public func fetchFollowedUsersPosts(_ userIds: [String], completion: @escaping (Result<[Post], Error>) ->()) {
        dataBase.collection(DataBaseService.postsCollections).whereField("userId", in: userIds).addSnapshotListener({ snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                completion(.success( posts.sorted { $0.postedDate.dateValue() > $1.postedDate.dateValue() }))
            }
        })
    }
}
