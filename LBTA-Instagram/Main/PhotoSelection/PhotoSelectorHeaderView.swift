//
//  PhotoSelectorHeaderView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class PhotoSelectorHeaderView: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            selectedPhotoImageView.image = image
        }
    }
    
    // MARK: - Views
    
    let selectedPhotoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(selectedPhotoImageView)
        selectedPhotoImageView.anchor(top: self.topAnchor, paddingTop: 0, right: self.rightAnchor, paddingRight: 0,
                                      bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0,
                                      width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
} // PhotoSelectorHeaderView
