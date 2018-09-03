//
//  Comment.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-03.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

struct Comment {
    
    let userId: String
    let userProfileImageUrl: String
    let caption: String
    
    init(dictionary: [String: Any]) {
        userId = dictionary["comment_user_id"] as? String ?? ""
        userProfileImageUrl = dictionary["comment_user_profile_image_url"] as? String ?? ""
        caption = dictionary["comment_caption"] as? String ?? ""
    }
    
} // Comment
