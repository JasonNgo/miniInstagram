//
//  HomeFeedCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    private var user: User?
    private var homeFeedController: HomeFeedController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        getCurrentUser()
    }
    
    override func start() {
        guard let user = user else {
            return
        }
        
        let homeFeedController = HomeFeedController(user: user)
        homeFeedController.navigationItem.title = "Home"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "home_unselected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysOriginal)
        navigationController.pushViewController(homeFeedController, animated: false)
        self.homeFeedController = homeFeedController
    }
    
    private func getCurrentUser() {
        guard let uid = FirebaseAPI.shared.getCurrentUserUID() else {
            return
        }
        
        FirebaseAPI.shared.retrieveUserWith(uid: uid) { (user, error) in
            if let error = error {
                fatalError("On home feed but no user present: \(error)")
            }
            
            guard let user = user else {
                return
            }
            
            self.user = user
        }
    }
}
