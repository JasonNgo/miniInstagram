//
//  ViewController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Views

    let addPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhotoButtonPressed), for: .touchUpInside)
        return button
    }()

    let emailTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        return textField
    }()

    let usernameTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
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
        button.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        var button = UIButton(type: .system)
        
        let messageTextAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]
        let loginTextAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.colorFrom(r: 17, g: 154, b: 244)
        ]
        
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: messageTextAttributes)
        let loginText = NSAttributedString(string: "Login.", attributes: loginTextAttributes)
        attributedText.append(loginText)
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountPressed), for: .touchUpInside)
        return button
    }()

    let imagePicker: UIImagePickerController = {
        var imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        return imagePicker
    }()

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupAddPhotoButton()
        setupInputFields()
        setupAlreadyHaveAccountButton()
        
        imagePicker.delegate = self
    } // viewDidLoad

    // MARK: - Setup Functions

    fileprivate func setupAddPhotoButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: view.topAnchor, paddingTop: 40, right: nil, paddingRight: 0,
                              bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, width: 140, height: 140)
        addPhotoButton.center(centerX: view.centerXAnchor, paddingCenterX: 0, centerY: nil, paddingCenterY: 0)
    } // setupViews

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField, usernameTextField, passwordTextField, signUpButton
        ])

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, paddingTop: 20, right: view.rightAnchor, paddingRight: -40,
                         bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40,
                         width: 0, height: 200)
    }
    
    fileprivate func setupAlreadyHaveAccountButton() {
        self.view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, paddingTop: 0, right: self.view.rightAnchor, paddingRight: 0,
                                        bottom: self.view.bottomAnchor, paddingBottom: -8, left: self.view.leftAnchor, paddingLeft: 0,
                                        width: 0, height: 50)
    }

    // MARK: - Selector Functions

    @objc func handleTextInputChanges() {
        if let emailText = emailTextField.text, let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text {
            
            let isFormValid = !emailText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty

            if isFormValid {
                signUpButton.isEnabled = true
                signUpButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 244)
            } else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
            }
        }
    }

    @objc func handleSignUpButtonPressed() {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let image = addPhotoButton.imageView?.image else { return }
        
        let values = ["username": username, "email": email, "password": password, "profile_image": image] as [String: Any]
        
        FirebaseAPI.shared.createUserWithValues(values) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupTabBarController()
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    @objc func handleAddPhotoButtonPressed() {
        present(imagePicker, animated: true)
    }
    
    @objc func handleAlreadyHaveAccountPressed() {
        let _ = navigationController?.popViewController(animated: true)
    }

    // MARK: UIImagePickerDelegate

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        // create circle border
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3

        dismiss(animated: true, completion: nil)
    }
    
} // SignUpViewController
