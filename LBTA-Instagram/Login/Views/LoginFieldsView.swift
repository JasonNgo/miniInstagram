//
//  LoginFieldsView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class LoginFieldsView: UIView {
  
  let emailTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Email"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.font = UIFont.systemFont(ofSize: 14)
    return textField
  }()
  
  let passwordTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    textField.borderStyle = .roundedRect
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.font = UIFont.systemFont(ofSize: 14)
    return textField
  }()
  
  let loginButton: UIButton = {
    var button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
    button.layer.cornerRadius = 5
    button.isEnabled = false
    return button
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    translatesAutoresizingMaskIntoConstraints = false
    
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      passwordTextField,
      loginButton
    ])
    
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    addSubview(stackView)
    stackView.anchor(
      top: topAnchor, paddingTop: 40,
      right: rightAnchor, paddingRight: -40,
      bottom: bottomAnchor, paddingBottom: -40,
      left: leftAnchor, paddingLeft: 40,
      width: 0, height: 0
    )
  }
  
  func updateButtonStyling(isFormValid: Bool) {
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 244)
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
    }
  }
  
}
