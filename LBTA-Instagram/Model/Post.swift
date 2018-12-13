//
//  Post.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Foundation

struct Post {
  let user: User
  var postId: String?
  let caption: String
  let imageWidth: Int
  let imageHeight: Int
  let postImageUrl: String
  let creationDate: Date
  var isLiked = false
  
  init(user: User, valuesDict: [String: Any]) {
    self.user = user
    self.caption = valuesDict["caption"] as? String ?? ""
    self.imageWidth = valuesDict["image_width"] as? Int ?? 0
    self.imageHeight = valuesDict["image_height"] as? Int ?? 0
    self.postImageUrl = valuesDict["post_image_url"] as? String ?? ""
    self.creationDate = Date(timeIntervalSince1970: valuesDict["creation_date"] as? Double ?? 0)
  }
  
}
