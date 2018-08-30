//
//  UserSearchCell.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-26.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let userProfileImageUrl = user?.profileImageUrl else { return }
            userProfileImage.loadImageFromUrl(userProfileImageUrl)
        }
    }
    
    // MARK: Views
    
    let userProfileImage: CustomImageView = {
        var imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        var label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var followButton: UIButton = {
        var button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleFollowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFollowButton() {
        
        
    }
    
    @objc func handleFollowButtonPressed() {
//
//        guard let user = user else { return }
//
//        if followButton.titleLabel?.text?.compare("Follow") == .orderedSame {
//            FirebaseAPI.shared.followUserWithUID(user.uuid) { (result) in
//                switch result {
//                case .success:
//                    self.followButton.setTitle("Unfollow", for: .normal)
//                case .failure:
//                    self.followButton.setTitle("Follow", for: .normal)
//                }
//            }
//        } else {
//            FirebaseAPI.shared.unfollowUserWithUID(user.uuid) { (result) in
//                switch result {
//                case .success:
//                    self.followButton.setTitle("Follow", for: .normal)
//                case .failure:
//                    self.followButton.setTitle("Unfollow", for: .normal)
//                }
//            }
//        }

    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupViews() {
        addSubview(userProfileImage)
        addSubview(usernameLabel)
        addSubview(followButton)
        
        userProfileImage.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8,
                                width: 40, height: 40)
        userProfileImage.layer.cornerRadius = 40 / 2
        userProfileImage.center(centerX: nil, paddingCenterX: 0, centerY: centerYAnchor, paddingCenterY: 0)
        
        followButton.anchor(top: nil, paddingTop: 0, right: rightAnchor, paddingRight: -8,
                            bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, width: 80, height: 40)
        followButton.center(centerX: nil, paddingCenterX: 0, centerY: centerYAnchor, paddingCenterY: 0)
        
        usernameLabel.anchor(top: nil, paddingTop: 8, right: followButton.leftAnchor, paddingRight: 8,
                             bottom: nil, paddingBottom: 0, left: userProfileImage.rightAnchor, paddingLeft: 8,
                             width: 0, height: 0)
        usernameLabel.center(centerX: nil, paddingCenterX: 0, centerY: centerYAnchor, paddingCenterY: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, paddingTop: 0, right: rightAnchor, paddingRight: 0,
                             bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0,
                             width: 0, height: 0.5)
    } 
    
} // UserSearchCell
