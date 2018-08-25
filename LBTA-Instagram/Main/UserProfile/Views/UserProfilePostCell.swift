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
            fetchPostImage()
        }
    }
    
    // MARK: - Views
    
    let profilePostImageView: UIImageView = {
        var imageView = UIImageView()
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
        profilePostImageView.anchor(top: topAnchor, paddingTop: 0,
                                    right: rightAnchor, paddingRight: 0,
                                    bottom: bottomAnchor, paddingBottom: 0,
                                    left: leftAnchor, paddingLeft: 0,
                                    width: 0, height: 0)
    }
    
    fileprivate func fetchPostImage() {
        guard let postImageUrl = post?.postImageUrl else { return }
        guard let url = URL(string: postImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check for errors
            if let error = error {
                print("error attempting to fetch post image: \(error)")
                return
            }
            
            // check the response
            guard let response = response else { return }
            guard let responseHTTP = response as? HTTPURLResponse else { return }
            print("status code: \(responseHTTP.statusCode)")
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profilePostImageView.image = image
            }
        }.resume()
    }
    
} // UserProfilePostCell
