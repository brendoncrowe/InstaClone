//
//  Comment.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import Foundation
import Firebase

struct Comment {
    let userId: String
    let userPhotoURL: String
    let displayName: String
    let postedDate: Timestamp
    let commentText: String
    
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.userPhotoURL = dictionary["userPhotoURL"] as? String ?? "no user photo url"
        self.displayName = dictionary["displayName"] as? String ?? "no display name"
        self.postedDate = dictionary["postedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["commentText"] as? String ?? "no comment text"
    }
}
