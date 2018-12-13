//
//  SignUpView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-12.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpView: UIView {
  
  // MARK: - Add Photo View
  
  let addPhotoButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.clipsToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Field Views
  
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
  
  // MARK: - Already Exists View
  
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
  
  // MARK: - Overrides
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    createAddPhotoSubview()
    createFieldSubviews()
    createAlreadyExistsSubview()
  }
  
  // MARK: - Subview Creation Functions
  
  fileprivate func createAddPhotoSubview() {
    addSubview(addPhotoButton)
    addPhotoButton.anchor(
      top: safeAreaLayoutGuide.topAnchor, paddingTop: 20,
      right: nil, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: nil, paddingLeft: 0,
      width: 150, height: 150
    )
    
    addPhotoButton.center(
      centerX: centerXAnchor, paddingCenterX: 0,
      centerY: nil, paddingCenterY: 0
    )
  }
  
  fileprivate func createFieldSubviews() {
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      usernameTextField,
      passwordTextField,
      signUpButton
    ])
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    addSubview(stackView)
    stackView.anchor(
      top: addPhotoButton.bottomAnchor, paddingTop: 20,
      right: rightAnchor, paddingRight: 40,
      bottom: nil, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 40,
      width: 0, height: 200
    )
  }
  
  fileprivate func createAlreadyExistsSubview() {
    addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.anchor(
      top: nil, paddingTop: 0,
      right: rightAnchor, paddingRight: 20,
      bottom: bottomAnchor, paddingBottom: 10,
      left: leftAnchor, paddingLeft: 20,
      width: 0, height: 50
    )
  }
  
  // MARK: - Styling Functions
  
  func styleSignUpButton(isFormValid: Bool) {
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 244)
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
    }
  }
  
  func showBlackCircleBorder() {
    addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
    addPhotoButton.layer.masksToBounds = true
    addPhotoButton.layer.borderColor = UIColor.black.cgColor
    addPhotoButton.layer.borderWidth = 3
  }
  
}
