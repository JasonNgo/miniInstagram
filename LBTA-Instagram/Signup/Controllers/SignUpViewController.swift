//
//  ViewController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  // MARK: - Views
  private let addPhotoView = SignUpAddPhotoView()
  private let signUpFieldsView = SignUpFieldsView()
  private let signUpAlreadyExistsView = SignUpAlreadyExistsView()
  
  let imagePicker: UIImagePickerController = {
    var imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = true
    return imagePicker
  }()
  
  // MARK: - Lifecycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    imagePicker.delegate = self
    
    setupAddPhotoButton()
    setupInputFields()
    setupAlreadyHaveAccountButton()
  }
  
  // MARK: - Setup Functions
  
  fileprivate func setupAddPhotoButton() {
    view.addSubview(addPhotoView)
    addPhotoView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 175
    )
    
    addPhotoView.addPhotoButton.addTarget(self, action: #selector(handleAddPhotoPressed), for: .touchUpInside)
  }
  
  fileprivate func setupInputFields() {
    view.addSubview(signUpFieldsView)
    signUpFieldsView.anchor(
      top: addPhotoView.bottomAnchor, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 250
    )
    
    signUpFieldsView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpFieldsView.usernameTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpFieldsView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
    signUpFieldsView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
  }
  
  fileprivate func setupAlreadyHaveAccountButton() {
    view.addSubview(signUpAlreadyExistsView)
    signUpAlreadyExistsView.anchor(
      top: nil, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: view.bottomAnchor, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 75
    )
    
    signUpAlreadyExistsView.alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccountPressed), for: .touchUpInside)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleTextInputChanges() {
    if let emailText = signUpFieldsView.emailTextField.text,
      let usernameText = signUpFieldsView.usernameTextField.text,
      let passwordText = signUpFieldsView.passwordTextField.text {
      let isFormValid = !emailText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty
      signUpFieldsView.styleSignUpButton(isFormValid: isFormValid)
    }
  }
  
  @objc func handleSignUpButtonPressed() {
    guard
      let username = signUpFieldsView.usernameTextField.text,
      let email = signUpFieldsView.emailTextField.text,
      let password = signUpFieldsView.passwordTextField.text,
      let image = addPhotoView.addPhotoButton.imageView?.image else {
        return
    }
    
    let values: [String: Any] = [
      "username": username,
      "email": email,
      "password": password,
      "profile_image": image
    ]
    
    FirebaseAPI.shared.createUserWithValues(values) { (error) in
      if let _ = error {
        self.showErrorAlert()
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      addPhotoView.setImage(image: originalImage.withRenderingMode(.alwaysOriginal))
    } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      addPhotoView.setImage(image: editedImage.withRenderingMode(.alwaysOriginal))
    }
    
    addPhotoView.showBlackCircleBorder()
    dismiss(animated: true, completion: nil)
  }
  
}
