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
    private var homeFeedController: HomeFeedController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let layout = UICollectionViewFlowLayout()
        let homeFeedController = HomeFeedController(collectionViewLayout: layout)
        homeFeedController.navigationItem.title = "Home"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "home_unselected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysOriginal)
        navigationController.pushViewController(homeFeedController, animated: false)
        self.homeFeedController = homeFeedController
    }
}
