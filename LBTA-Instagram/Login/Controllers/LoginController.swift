//
//  LoginController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-22.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
  
  // MARK: - Views
  
  private let loginView = LoginView()
  
  // MARK: - Overrides
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    view = loginView
  }
  
  // MARK: - Lifecycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    configureViews()
  }
  
  // MARK: - Configuration Functions
  
  fileprivate func configureViews() {
    loginView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    loginView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    loginView.loginButton.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
    loginView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleTextInputChanges() {
    if let emailText = loginView.emailTextField.text,
      let passwordText = loginView.passwordTextField.text {

      let isFormValid = !emailText.isEmpty && !passwordText.isEmpty
      loginView.updateButtonStyling(isFormValid: isFormValid)
    }
  }
  
  @objc func handleLoginButtonPressed() {
    print("login pressed")

    guard let email = loginView.emailTextField.text,
      let password = loginView.passwordTextField.text else {
        return
    }
    
    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
      if let error = error {
        self.showErrorAlert()
        print("There was an error attempting to sign in: \(error)")
        return
      }
      
      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
        return
      }
      mainTabBarController.setupTabBarController()
      mainTabBarController.setupViewControllers()
      self.dismiss(animated: true, completion: nil)
    }
  }

  @objc func handleSignUpButtonPressed() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
  // MARK: - Helper Functions
  
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
