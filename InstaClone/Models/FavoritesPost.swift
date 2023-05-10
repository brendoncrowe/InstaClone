//
//  FavoritesPost.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/9/23.
//

import Foundation
import Firebase

struct FavoritedPost {
    let userId: String
    let userPhotoURL: String
    let displayName: String
    let postedDate: Timestamp
    let postCaption: String
    let postId: String
    let imageURL: String
    
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.userPhotoURL = dictionary["userPhotoURL"] as? String ?? "no user photo url"
        self.postId = dictionary["postId"] as? String ?? "no item id"
        self.displayName = dictionary["displayName"] as? String ?? "no display name"
        self.postedDate = dictionary["postedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.postCaption = dictionary["postCaption"] as? String ?? "no post caption"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
    }
}
