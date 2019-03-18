//
//  ApplicationCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-13.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    private var mainTabBarController: MainTabBarController?
    private var loginCoordinator: LoginCoordinator?
    
    init(window: UIWindow) {
        FirebaseApp.configure()
        self.window = window
        self.navigationController = UINavigationController()
        super.init()
    }
    
    override func start() {
        if Auth.auth().currentUser == nil {
            showLoginScreen()
        } else {
            showMainScreen()
        }
        
        window.makeKeyAndVisible()
    }
    
    private func showLoginScreen() {
        window.rootViewController = navigationController
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        
        loginCoordinator.stop = { [weak self] in
            self?.loginCoordinator = nil
        }
        
        loginCoordinator.successfullyLoggedIn = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.showMainScreen()
        }
        
        loginCoordinator.start()
        self.loginCoordinator = loginCoordinator
    }
    
    private func showMainScreen() {
        let mainTabBarController = MainTabBarController()
        window.rootViewController = mainTabBarController
        self.mainTabBarController = mainTabBarController
    }
}

