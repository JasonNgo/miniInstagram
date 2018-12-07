//
//  LoginHeaderView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {
  
  let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal))
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.colorFrom(r: 0, g: 120, b: 175)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(logoImageView)
    NSLayoutConstraint.activate([
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  
}
