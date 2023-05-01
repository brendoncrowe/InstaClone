//
//  User.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/20/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct User: Equatable {
    let email: String
    let createdDate: Timestamp
    let displayName: String
    let userId: String
    let photoURL: String
}

extension User {
    init(_ dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? "no user email"
        self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp(date: Date())
        self.displayName = dictionary["displayName"] as? String ?? "no display name"
        self.userId = dictionary["userId"] as? String ?? "no userId"
        self.photoURL = dictionary["photoURL"] as? String ?? "no photo url"
    }
    
    init(firebaseUser: FirebaseAuth.User) {
        self.email = firebaseUser.email ?? "no user email"
        self.createdDate = Timestamp(date: firebaseUser.metadata.creationDate ?? Date())
        self.displayName = firebaseUser.displayName ?? "no display name"
        self.userId = firebaseUser.uid
        self.photoURL = firebaseUser.photoURL?.absoluteString ?? "no photo url"
    }
}
