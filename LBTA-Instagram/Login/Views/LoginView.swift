//
//  LoginView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-12.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class LoginView: UIView {
  
  // MARK: - Header Views
  
  let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal))
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let logoBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.colorFrom(r: 0, g: 120, b: 175)
    return view
  }()
  
  // MARK: - Field Views
  
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
  
  // MARK: - Sign Up Views
  
  let signUpButton: UIButton = {
    var button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
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
  
  // MARK: - Initializers
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    createHeaderSubviews()
    createFieldSubviews()
    createSignUpButtonSubview()
  }
  
  // MARK: - Subviews Creation Helpers
  
  fileprivate func createHeaderSubviews() {
    addSubview(logoBackgroundView)
    logoBackgroundView.anchor(
      top: topAnchor, paddingTop: 0,
      right: rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 0,
      width: 0, height: 175
    )

    addSubview(logoImageView)
    logoImageView.center(
      centerX: logoBackgroundView.centerXAnchor, paddingCenterX: 0,
      centerY: logoBackgroundView.centerYAnchor, paddingCenterY: 0
    )
  }
  
  fileprivate func createFieldSubviews() {
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      passwordTextField,
      loginButton
    ])
    
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    stackView.anchor(
      top: logoBackgroundView.bottomAnchor, paddingTop: 40,
      right: rightAnchor, paddingRight: 40,
      bottom: nil, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 40,
      width: 0, height: 150
    )
  }
  
  fileprivate func createSignUpButtonSubview() {
    addSubview(signUpButton)
    signUpButton.anchor(
      top: nil, paddingTop: 0,
      right: rightAnchor, paddingRight: 20,
      bottom: bottomAnchor, paddingBottom: 10,
      left: leftAnchor, paddingLeft: 20,
      width: 0, height: 50
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
