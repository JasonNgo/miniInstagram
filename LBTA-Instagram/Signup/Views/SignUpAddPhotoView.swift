//
//  SignUpAddPhotoView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpAddPhotoView: UIView {
  
  let addPhotoButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.clipsToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(addPhotoButton)
    NSLayoutConstraint.activate([
      addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      addPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      addPhotoButton.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
      addPhotoButton.widthAnchor.constraint(lessThanOrEqualToConstant: 150)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setImage(image: UIImage) {
    addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
  }
  
  func showBlackCircleBorder() {
    addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
    addPhotoButton.layer.masksToBounds = true
    addPhotoButton.layer.borderColor = UIColor.black.cgColor
    addPhotoButton.layer.borderWidth = 3
  }
  
}
