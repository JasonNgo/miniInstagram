//
//  HomePostView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-25.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomePostViewCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            profileImageView.loadImageFromUrl(profileImageUrl)
            
            guard let postImageUrl = post?.postImageUrl else { return }
            postImageView.loadImageFromUrl(postImageUrl)
            
            setupPostCaptionAttributedText()
        }
    }
    
    // MARK: - Views
    
    let profileImageView: CustomImageView = {
        var imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    let optionsButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let postImageView: CustomImageView = {
        var imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let heartButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendToButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let ribbonButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPostTopBar()
        setupPostImageView()
        setupPostActionsBar()
        setupPostDetails()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupPostTopBar() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)

        profileImageView.anchor(top: topAnchor, paddingTop: 8,
                                right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0,
                                left: leftAnchor, paddingLeft: 8,
                                width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: topAnchor, paddingTop: 8,
                             right: optionsButton.leftAnchor, paddingRight: 8,
                             bottom: nil, paddingBottom: 0,
                             left: profileImageView.rightAnchor, paddingLeft: 8,
                             width: 0, height: 40)
    
        optionsButton.anchor(top: topAnchor, paddingTop: 8,
                             right: rightAnchor, paddingRight: -8,
                             bottom: nil, paddingBottom: 0,
                             left: usernameLabel.rightAnchor, paddingLeft: 8,
                             width: 40, height: 40)
    }

    fileprivate func setupPostImageView() {
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, paddingTop: 8,
                             right: rightAnchor, paddingRight: 0,
                             bottom: nil, paddingBottom: 0,
                             left: leftAnchor, paddingLeft: 0,
                             width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    fileprivate func setupPostActionsBar() {
        let stackView = UIStackView(arrangedSubviews: [heartButton, commentButton, sendToButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, paddingTop: 0,
                           right: nil, paddingRight: 0,
                           bottom: nil, paddingBottom: 0,
                           left: leftAnchor, paddingLeft: 4,
                           width: 120, height: 50)
        
        addSubview(ribbonButton)
        ribbonButton.anchor(top: postImageView.bottomAnchor, paddingTop: 4,
                            right: rightAnchor, paddingRight: -8,
                            bottom: nil, paddingBottom: 0,
                            left: nil, paddingLeft: 0,
                            width: 40, height: 40)
    }
    
    fileprivate func setupPostDetails() {
        addSubview(captionLabel)
        captionLabel.anchor(top: heartButton.bottomAnchor, paddingTop: 0,
                            right: rightAnchor, paddingRight: -8,
                            bottom: bottomAnchor, paddingBottom: 0,
                            left: leftAnchor, paddingLeft: 8,
                            width: 0, height: 0)
    }
    
    fileprivate func setupPostCaptionAttributedText() {
        
        guard let post = self.post else { return }
        
        let usernameTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
        let captionTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let spaceTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 6)]
        let dateTextAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ]
        
        let attributedText = NSMutableAttributedString(string: "\(post.user.username) ", attributes: usernameTextAttributes)
        let captionText = NSAttributedString(string: post.caption, attributes: captionTextAttributes)
        let spaceText = NSAttributedString(string: "\n\n", attributes: spaceTextAttributes)
        let dateText = NSAttributedString(string: "March 21, 2018", attributes: dateTextAttributes)
        
        attributedText.append(captionText)
        attributedText.append(spaceText)
        attributedText.append(dateText)
        
        captionLabel.attributedText = attributedText
    }
    
} // HomePostViewCell
