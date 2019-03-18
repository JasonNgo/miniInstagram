//
//  PhotoSelectionCoordinator.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class PhotoSelectionCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var photoSelectorController: PhotoSelectorController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        navigationController.pushViewController(photoSelectorController, animated: false)
    }
}
