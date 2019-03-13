//
//  UserProfileHeaderView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

protocol UserProfileHeaderDelegate: AnyObject {
  func userProfileHeaderGearButtonTapped(_ userProfileHeaderView: UserProfileHeaderView)
  func userProfileHeaderListButtonTapped(_ userProfileHeaderView: UserProfileHeaderView)
  func userProfileHeaderEditOrFollowButtonTapped(_ userProfileHeaderView: UserProfileHeaderView)
}

class UserProfileHeaderView: UICollectionViewCell {
  
  weak var delegate: UserProfileHeaderDelegate?
  
  var user: User? {
    didSet {
      usernameLabel.text = user?.username
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImageFromUrl(profileImageUrl)
    }
  }
  
  var isFollowing = false
  
  enum HeaderLabelType {
    case posts
    case following
    case followers
  }
  
  // MARK: - Views
  
  let profileImageView: CustomImageView = {
    var imageView = CustomImageView()
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let postsLabel: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let numberTextAttributes = [
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
    ]
    let footerTextAttributes = [
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
      NSAttributedStringKey.foregroundColor: UIColor.lightGray
    ]
    let attributedText = NSMutableAttributedString(
      string: "0\n",
      attributes: numberTextAttributes
    )
    let footerText = NSAttributedString(
      string: "posts",
      attributes: footerTextAttributes
    )
    attributedText.append(footerText)
    label.attributedText = attributedText
    
    return label
  }()
  
  let followingLabel: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let numberTextAttributes = [
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
    ]
    let footerTextAttributes = [
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
      NSAttributedStringKey.foregroundColor: UIColor.lightGray
    ]
    let attributedText = NSMutableAttributedString(
      string: "0\n",
      attributes: numberTextAttributes
    )
    let footerText = NSAttributedString(
      string: "following",
      attributes: footerTextAttributes
    )
    
    attributedText.append(footerText)
    label.attributedText = attributedText
    return label
  }()
  
  let followersLabel: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let numberTextAttributes = [
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
    ]
    let footerTextAttributes = [
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
      NSAttributedStringKey.foregroundColor: UIColor.lightGray
    ]
    let attributedText = NSMutableAttributedString(
      string: "0\n",
      attributes: numberTextAttributes
    )
    let footerText = NSAttributedString(
      string: "followers",
      attributes: footerTextAttributes
    )
    
    attributedText.append(footerText)
    label.attributedText = attributedText
    return label
  }()
  
  let usernameLabel: UILabel = {
    var label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 15)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var editProfileFollowButton: UIButton = {
    var button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleEditProfileFollowButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var gridButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    button.addTarget(self, action: #selector(handleGridButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var listButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    button.addTarget(self, action: #selector(handleListButtonPressed), for: .touchUpInside)
    return button
  }()
  
  let likesButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  // MARK: - Init Functions
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupProfileImageView()
    setupUserStatsView()
    setupEditProfileButton()
    setupBottomToolbar()
    setupUsernameLabel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Set up Functions
  
  fileprivate func setupProfileImageView() {
    addSubview(profileImageView)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.anchor(
      top: self.topAnchor, paddingTop: 12,
      right: nil, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: self.leftAnchor, paddingLeft: 12,
      width: 80, height: 80
    )
  }
  
  fileprivate func setupBottomToolbar() {
    let stackView = UIStackView(arrangedSubviews: [
      gridButton,
      listButton
    ])
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    let topDividerView: UIView = {
      let view = UIView()
      view.backgroundColor = .lightGray
      return view
    }()
    
    let bottomDividerView: UIView = {
      let view = UIView()
      view.backgroundColor = .lightGray
      return view
    }()
    
    addSubview(stackView)
    stackView.anchor(
      top: nil, paddingTop: 0,
      right: rightAnchor, paddingRight: 0,
      bottom: bottomAnchor, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 0,
      width: 0, height: 50
    )
    
    addSubview(topDividerView)
    topDividerView.anchor(
      top: stackView.topAnchor, paddingTop: 0,
      right: rightAnchor, paddingRight: 0,
      bottom: nil, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 0,
      width: 0, height: 0.5
    )
    
    addSubview(bottomDividerView)
    bottomDividerView.anchor(
      top: nil, paddingTop: 0,
      right: rightAnchor, paddingRight: 0,
      bottom: bottomAnchor, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 0,
      width: 0, height: 0.5
    )
  }
  
  fileprivate func setupUsernameLabel() {
    addSubview(usernameLabel)
    usernameLabel.anchor(
      top: profileImageView.bottomAnchor, paddingTop: 4,
      right: rightAnchor, paddingRight: 12,
      bottom: gridButton.topAnchor, paddingBottom: 0,
      left: leftAnchor, paddingLeft: 12,
      width: 0, height: 0
    )
  }
  
  fileprivate func setupUserStatsView() {
    let stackView = UIStackView(arrangedSubviews: [
      postsLabel,
      followingLabel,
      followersLabel
    ])
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.anchor(
      top: topAnchor, paddingTop: 8,
      right: rightAnchor, paddingRight: 12,
      bottom: nil, paddingBottom: 0,
      left: profileImageView.rightAnchor, paddingLeft: 12,
      width: 0, height: 50
    )
  }
  
  fileprivate func setupEditProfileButton() {
    addSubview(editProfileFollowButton)
    editProfileFollowButton.anchor(
      top: postsLabel.bottomAnchor, paddingTop: 0,
      right: rightAnchor, paddingRight: 12,
      bottom: nil, paddingBottom: 0,
      left: profileImageView.rightAnchor, paddingLeft: 12,
      width: 0, height: 34
    )
  }
  
  fileprivate func setupFollowButton() {
    editProfileFollowButton.setTitle("Follow", for: .normal)
    editProfileFollowButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    editProfileFollowButton.setTitleColor(.white, for: .normal)
    editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    isFollowing = false
  }
  
  fileprivate func setupUnfollowButton() {
    editProfileFollowButton.setTitle("Unfollow", for: .normal)
    editProfileFollowButton.backgroundColor = .white
    editProfileFollowButton.setTitleColor(.black, for: .normal)
    isFollowing = true
  }
  
  // MARK: - Selector Functions
  
  @objc func handleEditProfileFollowButtonPressed() {
    print("Edit/Follow button pressed")
    delegate?.userProfileHeaderEditOrFollowButtonTapped(self)
  }
  
  @objc func handleGridButtonPressed() {
    print("grid button pressed")
    gridButton.tintColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    listButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
    delegate?.userProfileHeaderGearButtonTapped(self)
  }
  
  @objc func handleListButtonPressed() {
    print("list button pressed")
    gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
    listButton.tintColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    delegate?.userProfileHeaderListButtonTapped(self)
  }
  
  // MARK: - Styling Functions
  
  func showEditProfileButton() {
    editProfileFollowButton.setTitle("Edit Profile", for: .normal)
    editProfileFollowButton.setTitleColor(.black, for: .normal)
    editProfileFollowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    editProfileFollowButton.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func updateFollowButtonConfiguration(isFollowing: Bool) {
    if isFollowing {
      setupUnfollowButton()
    } else {
      setupFollowButton()
    }
  }
  
  func updateLabel(of type: HeaderLabelType, with count: Int) {
    let numberTextAttributes = [
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
    ]
    
    let footerTextAttributes = [
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
      NSAttributedStringKey.foregroundColor: UIColor.lightGray
    ]
    
    let attributedText = NSMutableAttributedString(
      string: "\(count)\n",
      attributes: numberTextAttributes
    )
    
    let footerText: NSAttributedString
    
    switch type {
    case .posts:
      footerText = NSAttributedString(
        string: "posts",
        attributes: footerTextAttributes
      )
      
      attributedText.append(footerText)
      postsLabel.attributedText = attributedText
    case .following:
      footerText = NSAttributedString(
        string: "following",
        attributes: footerTextAttributes
      )
      attributedText.append(footerText)
      followingLabel.attributedText = attributedText
    case .followers:
      footerText = NSAttributedString(
        string: "followers",
        attributes: footerTextAttributes
      )
      attributedText.append(footerText)
      followersLabel.attributedText = attributedText
    }
  }
  
}
