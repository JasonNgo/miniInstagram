//
//  SignUpCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-13.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class SignUpCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var signUpController: SignUpController?
    
    var successfullyLoggedIn: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let signUpController = SignUpController()
        signUpController.delegate = self
        setDeallocallable(with: signUpController)
        navigationController.pushViewController(signUpController, animated: true)
        self.signUpController = signUpController
    }
}

extension SignUpCoordinator: SignUpControllerDelegate {
    func signUpControllerDidAttemptSignUp(with values: [String : Any]) {
        FirebaseAPI.shared.createUserWithValues(values) { [unowned self] (error) in
            if let error = error {
                print("Error: \(error), Description: \(error.localizedDescription)")
                self.signUpController?.configureSignUpButton(isFormValid: true)
                self.signUpController?.showErrorAlert(error: error)
                return
            }
            
            self.successfullyLoggedIn?()
        }
    }
    
    func signUpControllerDidPressAlreadyHaveAccount() {
        navigationController.popViewController(animated: true)
    }
}
