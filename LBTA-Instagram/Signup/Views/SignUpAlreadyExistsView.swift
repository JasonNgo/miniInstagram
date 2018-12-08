//
//  SignUpAlreadyExistingAccountView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpAlreadyExistsView: UIView {
  
  let alreadyHaveAccountButton: UIButton = {
    var button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    let messageTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.lightGray
    ]
    
    let loginTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 14),
      .foregroundColor: UIColor.colorFrom(r: 17, g: 154, b: 244)
    ]
    
    let attributedText = NSMutableAttributedString(
      string: "Already have an account? ",
      attributes: messageTextAttributes
    )
    
    let loginText = NSAttributedString(
      string: "Login.",
      attributes: loginTextAttributes
    )
    
    attributedText.append(loginText)
    button.setAttributedTitle(attributedText, for: .normal)
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(alreadyHaveAccountButton)
    NSLayoutConstraint.activate([
      alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      alreadyHaveAccountButton.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
