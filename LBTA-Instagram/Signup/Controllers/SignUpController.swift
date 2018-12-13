//
//  ViewController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

// TODO: Add activity indicator when attempting to create account

class SignUpController: UIViewController {
  
  private let signUpView = SignUpView()
  
  lazy var imagePicker: UIImagePickerController = {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = true
    imagePicker.delegate = self
    return imagePicker
  }()
  
  // MARK: - Overrides
  
  override func loadView() {
    view = signUpView
  }
  
  // MARK: - Lifecycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }
  
  // MARK: - Configuration Functions
  
  fileprivate func configureViews() {
    signUpView.addPhotoButton.addTarget(self, action: #selector(handleAddPhotoPressed), for: .touchUpInside)
    signUpView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpView.usernameTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
    signUpView.alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccountPressed), for: .touchUpInside)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleTextInputChanges() {
    if let emailText = signUpView.emailTextField.text,
      let usernameText = signUpView.usernameTextField.text,
      let passwordText = signUpView.passwordTextField.text {
      let isFormValid = !emailText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty
      signUpView.styleSignUpButton(isFormValid: isFormValid)
    }
  }
  
  @objc func handleSignUpButtonPressed() {
    guard
      let username = signUpView.usernameTextField.text,
      let email = signUpView.emailTextField.text,
      let password = signUpView.passwordTextField.text,
      let image = signUpView.addPhotoButton.imageView?.image else {
        return
    }
    
    let values: [String: Any] = [
      "username": username,
      "email": email,
      "password": password,
      "profile_image": image
    ]
    
    signUpView.styleSignUpButton(isFormValid: false)
    FirebaseAPI.shared.createUserWithValues(values) { (error) in
      if let error = error {
        print("Error: \(error), Description: \(error.localizedDescription)")
        self.signUpView.styleSignUpButton(isFormValid: true)
        self.showErrorAlert()
        return
      }
      
      guard let mainTabBarController = AppDelegate.shared.mainTabBarController else {
        return
      }
      
      mainTabBarController.setupTabBarController()
      mainTabBarController.setupViewControllers()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func handleAddPhotoPressed() {
    present(imagePicker, animated: true)
  }
  
  @objc func handleAlreadyHaveAccountPressed() {
    let _ = navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Helpers
  
  fileprivate func showErrorAlert() {
    let alertController = UIAlertController(
      title: "Unable to create account",
      message: "There was an error while attempting to create your account. Please try again.",
      preferredStyle: .alert
    )
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
}

// MARK: - UIImagePickerDelegate

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      signUpView.addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      signUpView.addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    signUpView.showBlackCircleBorder()
    dismiss(animated: true, completion: nil)
  }
  
}
