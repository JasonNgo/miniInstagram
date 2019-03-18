//
//  LoginCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-13.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var loginController: LoginController?
    private var signUpCoordinator: SignUpCoordinator?
    
    var successfullyLoggedIn: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let loginController = LoginController()
        loginController.delegate = self
        setDeallocallable(with: loginController)
        navigationController.pushViewController(loginController, animated: true)
        self.loginController = loginController
    }
}

extension LoginCoordinator: LoginControllerDelegate {
    func loginControllerDidAttemptLogin(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (_, error) in
            if let error = error {
                self.loginController?.showErrorAlert(error: error)
                return
            }
            
            self.successfullyLoggedIn?()
        }
    }
    
    func loginControllerDidPressSignUpButton() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        
        signUpCoordinator.stop = { [weak self] in
            self?.signUpCoordinator = nil
        }
        
        signUpCoordinator.successfullyLoggedIn = { [weak self] in
            self?.navigationController.popViewController(animated: false)
            self?.successfullyLoggedIn?()
        }
        
        signUpCoordinator.start()
        self.signUpCoordinator = signUpCoordinator
    }
}
