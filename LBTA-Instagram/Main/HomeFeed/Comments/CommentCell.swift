//
//  CommentCell.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-03.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let commentTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Username Caption"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, width: 40, height: 40)
        profileImageView.center(centerX: nil, paddingCenterX: 0, centerY: centerYAnchor, paddingCenterY: 0)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentTextLabel)
        commentTextLabel.anchor(top: topAnchor, paddingTop: 0, right: rightAnchor, paddingRight: -8,
                             bottom: bottomAnchor, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 4,
                             width: 0, height: 0)
    }
    
} // CommentCell
