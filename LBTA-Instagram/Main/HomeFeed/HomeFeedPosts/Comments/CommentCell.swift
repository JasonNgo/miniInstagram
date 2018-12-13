//
//  CommentCell.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-03.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var post: Post?
    
    var comment: Comment? {
        didSet {
            captionTextView.text = comment?.caption
            fetchUserWithId(comment?.userId ?? "")
        }
    }
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImageFromUrl(profileImageUrl)
            
            setupCommentCaptionAttributedText()
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 8, right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 8, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(captionTextView)
        captionTextView.anchor(top: topAnchor, paddingTop: 4, right: rightAnchor, paddingRight: 4,
                               bottom: bottomAnchor, paddingBottom: 4, left: profileImageView.rightAnchor, paddingLeft: 4,
                               width: 0, height: 0)
        
        let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        
        addSubview(dividerView)
        dividerView.anchor(top: nil, paddingTop: 0, right: rightAnchor, paddingRight: 0,
                           bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0,
                           width: 0, height: 0.5)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUserWithId(_ id: String) {
        FirebaseAPI.shared.retrieveUserWith(uid: id) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = user else { return }
            self.user = user
        }
    }
    
    fileprivate func setupCommentCaptionAttributedText() {
        guard let comment = self.comment else { return }
        guard let user = self.user else { return }
        
        let usernameTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
        let captionTextAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        
        let attributedText = NSMutableAttributedString(string: "\(user.username) ", attributes: usernameTextAttributes)
        let captionText = NSAttributedString(string: comment.caption, attributes: captionTextAttributes)
    
        attributedText.append(captionText)
        captionTextView.attributedText = attributedText
    }
    
} // CommentCell
