//
//  ViewController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Views
    let addPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let signUpButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupViews() {
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: self.view.topAnchor, paddingTop: 40,
                              right: nil, paddingRight: 0,
                              bottom: nil, paddingBottom: 0,
                              left: nil, paddingLeft: 0,
                              width: 140, height: 140)
        addPhotoButton.center(X: self.view.centerXAnchor, paddingCenterX: 0, Y: nil, paddingCenterY: 0)
        
        setupInputFields()
    } // setupViews

    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, paddingTop: 20,
                         right: self.view.rightAnchor, paddingRight: -40,
                         bottom: nil, paddingBottom: 0,
                         left: self.view.leftAnchor, paddingLeft: 40,
                         width: 0, height: 200)
        
    } // setupInputFields
    
}

