//
//  UserProfilePostCell.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfilePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.postImageUrl else { return }
            profilePostImageView.loadImageFromUrl(postImageUrl)
        }
    }
    
    // MARK: - Views
    
    let profilePostImageView: CustomImageView = {
        var imageView = CustomImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(profilePostImageView)
        profilePostImageView.anchor(top: topAnchor, paddingTop: 0, right: rightAnchor, paddingRight: 0,
                                    bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0,
                                    width: 0, height: 0)
    } // setupViews
    
} // UserProfilePostCell
