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
    static let commentsCollection = "comments"
    static let favoritesCollection = "favorites"
    
    private let dataBase = Firestore.firestore()
    // creating a user for the users collection in the database to more easily access
    
    // MARK: User methods
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
    
    
    public func fetchUser(_ uid: String, completion: @escaping (Result<User, Error>) ->()) {
        dataBase.collection(DataBaseService.usersCollection).document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document {
                let data = document.data()
                let createdDate = data?["createdDate"] as? Timestamp ?? Timestamp(date: Date())
                let displayName = data?["displayName"] as? String ?? ""
                let userId = data?["userId"] as? String ?? ""
                let photoURL = data?["photoURL"] as? String ?? ""
                let user = User(email: nil, createdDate: createdDate, displayName: displayName, userId: userId, photoURL: photoURL)
                completion(.success(user))
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
        dataBase.collection(DataBaseService.usersCollection).document(currentUser.uid).collection(DataBaseService.followingCollection).document(user.userId).setData(["userName": user.displayName, "userId": user.userId, "photoURL": user.photoURL, "followedDate": Timestamp(date: Date())]) { error in
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
     
    // MARK: Post methods
    public func createPost(postCaption: String, user: FirebaseAuth.User, completion: @escaping (Result<String, Error>) -> ()){
        let docRef = dataBase.collection(DataBaseService.postsCollections).document()
        dataBase.collection(DataBaseService.postsCollections).document(docRef.documentID).setData(["postCaption" : postCaption, "postId": docRef.documentID, "postedDate": Timestamp(date: Date()), "displayName": user.displayName!, "userId": user.uid, "userPhotoURL": user.photoURL!.absoluteString]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
    }
    
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
    
    // MARK: Comment methods
    public func createComment(for post: Post, with text: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let currentDatabaseUser = Auth.auth().currentUser else { return }
        let user = User(firebaseUser: currentDatabaseUser)
        let docRef = dataBase.collection(DataBaseService.commentsCollection).document()
        dataBase.collection(DataBaseService.postsCollections).document(post.postId).collection(DataBaseService.commentsCollection).document(docRef.documentID)      .setData(["userId": user.userId, "userPhotoURL": user.photoURL, "displayName": user.displayName, "postedDate": Timestamp(date: Date()), "commentText": text]) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(true))
        }
    }
    
    public func fetchComments(postId: String, completion: @escaping (Result<[Comment], Error>) ->()) {
        dataBase.collection(DataBaseService.postsCollections).document(postId).collection(DataBaseService.commentsCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let comments = snapshot.documents.map { Comment( $0.data()) }
                completion(.success(comments))
            }
        }
    }
    
    // MARK: Favorite method
    public func favoritePost(post: Post, completion: @escaping (Result<Bool, Error>) ->()) {
        guard let user = Auth.auth().currentUser else { return }
        dataBase.collection(DataBaseService.usersCollection).document(user.uid).collection(DataBaseService.favoritesCollection).document(post.postId).setData(["postCaption" : post.postCaption, "postId": post.postId, "postedDate": Timestamp(date: Date()), "displayName": post.displayName, "userId": post.userId, "userPhotoURL": post.userPhotoURL]) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(true))
        }
    }
}
