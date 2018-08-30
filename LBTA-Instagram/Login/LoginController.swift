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
    
    let logoHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorFrom(r: 0, g: 120, b: 175)
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        return view
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
    
    let loginButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        var button = UIButton(type: .system)
        
        let messageTextAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]
        let signUpTextAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.colorFrom(r: 17, g: 154, b: 244)
        ]
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: messageTextAttributes)
        let signUpText = NSAttributedString(string: "Sign up.", attributes: signUpTextAttributes)
        attributedText.append(signUpText)
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        setupHeaderView()
        setupLoginViews()
        setupSignUpButton()
    }
    
    // MARK: - Set up Functions
    
    fileprivate func setupHeaderView() {
        self.view.addSubview(logoHeaderView)
        logoHeaderView.anchor(top: self.view.topAnchor, paddingTop: 0, right: self.view.rightAnchor, paddingRight: 0,
                              bottom: nil, paddingBottom: 0, left: self.view.leftAnchor, paddingLeft: 0,
                              width: 0, height: 150)
    }
    
    fileprivate func setupSignUpButton() {
        self.view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, paddingTop: 0, right: self.view.rightAnchor, paddingRight: 0,
                            bottom: self.view.bottomAnchor, paddingBottom: -8, left: self.view.leftAnchor, paddingLeft: 0,
                            width: 0, height: 50)
    }
    
    fileprivate func setupLoginViews() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
    
        stackView.anchor(top: logoHeaderView.bottomAnchor, paddingTop: 40, right: self.view.rightAnchor, paddingRight: -40,
                         bottom: nil, paddingBottom: 0, left: self.view.leftAnchor, paddingLeft: 40,
                         width: 0, height: 140)
    }
    
    // MARK: - Selector Functions
    
    @objc func handleTextInputChanges() {
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
            let isFormValid = !emailText.isEmpty && !passwordText.isEmpty
            
            if isFormValid {
                loginButton.isEnabled = true
                loginButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 244)
            } else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = UIColor.colorFrom(r: 149, g: 204, b: 244)
            } // if
        } // if let
    } // handleTextInputChanges
    
    @objc func handleLoginButtonPressed() {
        print("login pressed")
        
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        FirebaseAPI.shared.loginUserWith(email: emailText, password: passwordText) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupTabBarController()
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        } // loginUserWith
    }
    
    @objc func handleSignUpButtonPressed() {
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
