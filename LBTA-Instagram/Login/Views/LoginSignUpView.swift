//
//  LoginSignUpView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class LoginSignUpView: UIView {
  
  let signUpButton: UIButton = {
    var button = UIButton(type: .system)
    
    let messageTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.lightGray
    ]
    
    let signUpTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 14),
      .foregroundColor: UIColor.colorFrom(r: 17, g: 154, b: 244)
    ]
    
    let attributedText = NSMutableAttributedString(
      string: "Don't have an account? ",
      attributes: messageTextAttributes
    )
    
    let signUpText = NSAttributedString(
      string: "Press here to sign up",
      attributes: signUpTextAttributes
    )
    
    attributedText.append(signUpText)
    button.setAttributedTitle(attributedText, for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false

    addSubview(signUpButton)
    signUpButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      signUpButton.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
