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
    let caption: String
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.userId = dictionary["comment_user_id"] as? String ?? ""
        self.caption = dictionary["comment_caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creation_date"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
} // Comment
