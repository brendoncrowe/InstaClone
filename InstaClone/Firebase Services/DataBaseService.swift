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
}
