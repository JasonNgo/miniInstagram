//
//  LoginController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-22.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
  // MARK: - Views
  
  private var loginHeaderView = LoginHeaderView()
  private var loginFieldsView = LoginFieldsView()
  private var loginSignUpView = LoginSignUpView()
  
  // MARK: - Overrides
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Lifecycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
    
    setupLoginHeaderView()
    setupLoginFieldsViews()
    setupLoginSignUpView()
  }
  
  // MARK: - Set up Functions
  
  fileprivate func setupLoginHeaderView() {
    view.addSubview(loginHeaderView)
    loginHeaderView.anchor(
      top: view.topAnchor, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 175
    )
  }

  fileprivate func setupLoginFieldsViews() {
    view.addSubview(loginFieldsView)
    loginFieldsView.anchor(
      top: loginHeaderView.bottomAnchor, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 200
    )
    
    loginFieldsView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    loginFieldsView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    loginFieldsView.loginButton.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
  }
  
  fileprivate func setupLoginSignUpView() {    
    view.addSubview(loginSignUpView)
    loginSignUpView.anchor(
      top: nil, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: view.bottomAnchor, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 75
    )
    
    loginSignUpView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleTextInputChanges() {
    if let emailText = loginFieldsView.emailTextField.text,
      let passwordText = loginFieldsView.passwordTextField.text {
      
      let isFormValid = !emailText.isEmpty && !passwordText.isEmpty
      loginFieldsView.updateButtonStyling(isFormValid: isFormValid)
    }
  }
  
  @objc func handleLoginButtonPressed() {
    print("login pressed")

    guard let email = loginFieldsView.emailTextField.text,
      let password = loginFieldsView.passwordTextField.text else {
        return
    }

    FirebaseAPI.shared.loginUserWith(email: email, password: password) { (error) in
      if let _ = error {
        self.showErrorAlert()
        return
      }

      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
      mainTabBarController.setupTabBarController()
      mainTabBarController.setupViewControllers()
      self.dismiss(animated: true, completion: nil)
    }
  }

  @objc func handleSignUpButtonPressed() {
    let signUpController = SignUpViewController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
  // MARK: - Helpers
  
  fileprivate func showErrorAlert() {
    let alertController = UIAlertController(
      title: "Unable to login",
      message: "There was an error while attempting to login. Please try again.",
      preferredStyle: .alert
    )
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
}
