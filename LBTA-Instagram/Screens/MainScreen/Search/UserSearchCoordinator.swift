//
//  UserSearchCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class UserSearchCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var userSearchController: UserSearchController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let layout = UICollectionViewFlowLayout()
        let userSearchController = UserSearchController(collectionViewLayout: layout)
        userSearchController.navigationItem.title = "Search"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "search_unselected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "search_selected").withRenderingMode(.alwaysOriginal)
        navigationController.pushViewController(userSearchController, animated: false)
        self.userSearchController = userSearchController
    }
}
