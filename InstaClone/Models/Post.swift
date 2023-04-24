//
//  Post.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/24/23.
//

import Foundation
import Firebase

struct Post {
    let userId: String
    let userName: String
    let postedDate: Timestamp
    let postCaption: String
    let imageURL: String
    
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.userName = dictionary["userName"] as? String ?? "no user name"
        self.postedDate = dictionary["postedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.postCaption = dictionary["postCaption"] as? String ?? "no post caption"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
    }
}
