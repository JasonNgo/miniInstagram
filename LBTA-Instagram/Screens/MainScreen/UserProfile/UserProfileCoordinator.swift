//
//  UserProfileCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var userProfileController: UserProfileController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        userProfileController.navigationItem.title = "User"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysOriginal)
        navigationController.pushViewController(userProfileController, animated: false)
        self.userProfileController = userProfileController
    }
    
}
