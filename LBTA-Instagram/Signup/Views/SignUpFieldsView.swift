//
//  SignUpFieldsView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-07.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpFieldsView: UIView {
  
  let emailTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Email"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let usernameTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Username"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let passwordTextField: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    textField.borderStyle = .roundedRect
    textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let signUpButton: UIButton = {
    var button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
    button.layer.cornerRadius = 5
    button.isEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      usernameTextField,
      passwordTextField,
      signUpButton
      ])
    
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    
    addSubview(stackView)
    stackView.anchor(
      top: topAnchor, paddingTop: 20,
      right: rightAnchor, paddingRight: -40,
      bottom: bottomAnchor, paddingBottom: -20,
      left: leftAnchor, paddingLeft: 40,
      width: 0, height: 0
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func styleSignUpButton(isFormValid: Bool) {
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 244)
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
    }
  }
  
}
