//
//  ViewController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

protocol SignUpControllerDelegate: AnyObject {
    func signUpControllerDidPressAlreadyHaveAccount()
    func signUpControllerDidAttemptSignUp(with values: [String: Any])
}

// TODO: Add activity indicator when attempting to create account
class SignUpController: UIViewController, Deinitcallable {
    // MARK: - View
    private let signUpView = SignUpView()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()
    
    // MARK: - Delegate
    weak var delegate: SignUpControllerDelegate?
    
    // MARK: - Deinitcallable
    var onDeinit: (() -> Void)?
    deinit {
        onDeinit?()
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        signUpView.addPhotoButton.addTarget(self, action: #selector(handleAddPhotoPressed), for: .touchUpInside)
        signUpView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        signUpView.usernameTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        signUpView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        signUpView.alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccountPressed), for: .touchUpInside)
    }
    
    // MARK: - Subview Selectors
    @objc private func handleTextInputChanges() {
        if let emailText = signUpView.emailTextField.text,
            let usernameText = signUpView.usernameTextField.text,
            let passwordText = signUpView.passwordTextField.text {
            let isFormValid = !emailText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty
            signUpView.configureSignUpButton(isFormValid: isFormValid)
        }
    }
    
    @objc private func handleSignUpButtonPressed() {
        guard let username = signUpView.usernameTextField.text,
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
        
        signUpView.configureSignUpButton(isFormValid: false)
        delegate?.signUpControllerDidAttemptSignUp(with: values)
    }
    
    @objc private func handleAddPhotoPressed() {
        present(imagePicker, animated: true)
    }
    
    @objc private func handleAlreadyHaveAccountPressed() {
        delegate?.signUpControllerDidPressAlreadyHaveAccount()
    }
    
    // MARK: - Helpers
    func showErrorAlert(error: Error) {
        let alertController = UIAlertController(
            title: "Unable to create account",
            message: "There was an error while attempting to create your account. Please try again.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func configureSignUpButton(isFormValid: Bool) {
        signUpView.configureSignUpButton(isFormValid: isFormValid)
    }
}

// MARK: - UIImagePickerDelegate
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            signUpView.configureAddPhotoButton(image: originalImage)
            signUpView.showBlackCircleBorder()
        } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            signUpView.configureAddPhotoButton(image: editedImage)
            signUpView.showBlackCircleBorder()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
