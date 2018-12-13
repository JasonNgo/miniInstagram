//
//  UIImageView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

class CustomImageView: UIImageView {
  
  var lastUrlUsedToLoadImage: String?
  
  func loadImageFromUrl(_ urlString: String) {
    image = nil
    guard let url = URL(string: urlString) else { return }
    lastUrlUsedToLoadImage = urlString
    sd_setImage(with: url, completed: nil)
  }
  
}
