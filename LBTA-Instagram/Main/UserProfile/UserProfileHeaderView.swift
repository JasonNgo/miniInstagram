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
}

class UserProfileHeaderView: UICollectionViewCell {
  
  weak var delegate: UserProfileHeaderDelegate?
  
  var user: User? {
    didSet {
      usernameLabel.text = user?.username
      determineEditProfileFollowButtonConfiguration()
      
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImageFromUrl(profileImageUrl)
    }
  }
  
  // MARK: - Views
  
  let profileImageView: CustomImageView = {
    var imageView = CustomImageView()
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let postsLabel: UILabel = {
    var label = UILabel()
    
    let numberTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
    let footerTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.lightGray
    ]
    
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: numberTextAttributes)
    let footerText = NSAttributedString(string: "posts", attributes: footerTextAttributes)
    attributedText.append(footerText)
    
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let followingLabel: UILabel = {
    var label = UILabel()
    
    let numberTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
    let footerTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.lightGray
    ]
    
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: numberTextAttributes)
    let footerText = NSAttributedString(string: "following", attributes: footerTextAttributes)
    attributedText.append(footerText)
    
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let followersLabel: UILabel = {
    var label = UILabel()
    
    let numberTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
    let footerTextAttributes: [NSAttributedStringKey: Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.lightGray
    ]
    
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: numberTextAttributes)
    let footerText = NSAttributedString(string: "followers", attributes: footerTextAttributes)
    attributedText.append(footerText)
    
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let usernameLabel: UILabel = {
    var label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 15)
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
    button.addTarget(self, action: #selector(handleEditProfileFollowButtonPressed), for: .touchUpInside)
    return button
  }()
  
  @objc func handleEditProfileFollowButtonPressed() {
    guard let uid = self.user?.uuid else { return }
    
    if editProfileFollowButton.title(for: .normal)?.compare("Edit Profile") == .orderedSame {
      // edit profile
    } else if editProfileFollowButton.title(for: .normal)?.compare("Follow") == .orderedSame {
      FirebaseAPI.shared.followUserWithUID(uid) { (error) in
        if let error = error {
          print(error)
          self.setupFollowButton()
          return
        }
        
        self.setupUnfollowButton()
      }
    } else {
      FirebaseAPI.shared.unfollowUserWithUID(uid) { (error) in
        if let error = error {
          print(error)
          self.setupUnfollowButton()
        }
        
        self.setupFollowButton()
      }
    }
  }
  
  lazy var gridButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    button.addTarget(self, action: #selector(handleGridButtonPressed), for: .touchUpInside)
    return button
  }()
  
  @objc func handleGridButtonPressed() {
    print("grid button pressed")
    gridButton.tintColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    listButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
    delegate?.userProfileHeaderGearButtonTapped(self)
  }
  
  lazy var listButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    button.addTarget(self, action: #selector(handleListButtonPressed), for: .touchUpInside)
    return button
  }()
  
  @objc func handleListButtonPressed() {
    print("list button pressed")
    gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
    listButton.tintColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    delegate?.userProfileHeaderListButtonTapped(self)
  }
  
  let bookmarkButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
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
    super.init(coder: aDecoder)
  }
  
  // MARK: - Set up Functions
  
  fileprivate func setupProfileImageView() {
    self.addSubview(profileImageView)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.anchor(top: self.topAnchor, paddingTop: 12, right: nil, paddingRight: 0,
                            bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 12,
                            width: 80, height: 80)
  }
  
  fileprivate func setupBottomToolbar() {
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
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
    
    self.addSubview(stackView)
    self.addSubview(topDividerView)
    self.addSubview(bottomDividerView)
    
    stackView.anchor(top: nil, paddingTop: 0, right: self.rightAnchor, paddingRight: 0,
                     bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0,
                     width: 0, height: 50)
    
    topDividerView.anchor(top: stackView.topAnchor, paddingTop: 0, right: self.rightAnchor, paddingRight: 0,
                          bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0,
                          width: 0, height: 0.5)
    
    bottomDividerView.anchor(top: nil, paddingTop: 0, right: self.rightAnchor, paddingRight: 0,
                             bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0,
                             width: 0, height: 0.5)
  }
  
  fileprivate func setupUsernameLabel() {
    self.addSubview(usernameLabel)
    usernameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 4, right: self.rightAnchor, paddingRight: 12,
                         bottom: gridButton.topAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 12,
                         width: 0, height: 0)
  }
  
  fileprivate func setupUserStatsView() {
    let stackView = UIStackView(arrangedSubviews: [postsLabel, followingLabel, followersLabel])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    self.addSubview(stackView)
    stackView.anchor(top: self.topAnchor, paddingTop: 8, right: self.rightAnchor, paddingRight: -12,
                     bottom: nil, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 12,
                     width: 0, height: 50)
  }
  
  fileprivate func setupEditProfileButton() {
    self.addSubview(editProfileFollowButton)
    editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, paddingTop: 0, right: self.rightAnchor, paddingRight: -12,
                                   bottom: nil, paddingBottom: 0, left: profileImageView.rightAnchor, paddingLeft: 12,
                                   width: 0, height: 34)
  }
  
  // MARK: - Helper Functions
  
  fileprivate func determineEditProfileFollowButtonConfiguration() {
    guard let uid = user?.uuid else { return }
    let currentUUID = FirebaseAPI.shared.getCurrentUserUID()
    
    // user is not the current logged user
    if currentUUID != uid {
      FirebaseAPI.shared.fetchFollowingListForCurrentUser { (following, error) in
        if let error = error {
          print(error)
          return
        }
        
        guard let following = following else { return }
        if let _ = following.index(of: uid) {
          self.setupUnfollowButton()
        } else {
          self.setupFollowButton()
        }
      }
    }
  }
  
  fileprivate func setupFollowButton() {
    editProfileFollowButton.setTitle("Follow", for: .normal)
    editProfileFollowButton.backgroundColor = UIColor.colorFrom(r: 17, g: 154, b: 237)
    editProfileFollowButton.setTitleColor(.white, for: .normal)
    editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
  }
  
  fileprivate func setupUnfollowButton() {
    editProfileFollowButton.setTitle("Unfollow", for: .normal)
    editProfileFollowButton.backgroundColor = .white
    editProfileFollowButton.setTitleColor(.black, for: .normal)
  }
  
}
