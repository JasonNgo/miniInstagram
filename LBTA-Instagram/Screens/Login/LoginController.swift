//
//  LoginController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-22.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

protocol LoginControllerDelegate: AnyObject {
    func loginControllerDidPressSignUpButton()
    func loginControllerDidAttemptLogin(with email: String, password: String)
}

class LoginController: UIViewController, Deinitcallable {
    // MARK: - Views
    private let loginView = LoginView()
    
    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Delegate
    weak var delegate: LoginControllerDelegate?
    
    // MARK: - Deinitcallable
    var onDeinit: (() -> Void)?
    deinit {
        onDeinit?()
    }
    
    // MARK: - Lifecycle Functions
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        loginView.emailTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        loginView.loginButton.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Selector Functions
    @objc private func handleTextInputChanges() {
        if let emailText = loginView.emailTextField.text,
            let passwordText = loginView.passwordTextField.text {
            let isFormValid = !emailText.isEmpty && !passwordText.isEmpty
            loginView.updateButtonStyling(isFormValid: isFormValid)
        }
    }
    
    @objc private func handleLoginButtonPressed() {
        guard let email = loginView.emailTextField.text,
            let password = loginView.passwordTextField.text else {
                return
        }
        
        delegate?.loginControllerDidAttemptLogin(with: email, password: password)
    }
    
    @objc private func handleSignUpButtonPressed() {
        delegate?.loginControllerDidPressSignUpButton()
    }
    
    // MARK: - Helper Functions
    func showErrorAlert(error: Error) {
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

