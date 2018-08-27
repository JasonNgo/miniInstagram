//
//  User.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-22.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

struct User {
    
    let uuid: String
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.uuid = dictionary["uuid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profile_image_url"] as? String ?? ""
    }
    
} // User
