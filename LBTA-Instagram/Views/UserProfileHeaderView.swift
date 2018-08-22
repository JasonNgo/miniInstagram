//
//  UserProfileHeaderView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionViewCell {
    
    var user: User? {
        didSet {
            fetchProfileImage()
        }
    }
    
    // MARK: - Views
    
    let profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // MARK: - Init Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        setupProfileImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Set up Functions
    
    fileprivate func setupProfileImageView() {
        self.addSubview(profileImageView)
        
        profileImageView.anchor(top: self.topAnchor, paddingTop: 12, right: nil, paddingRight: 0,
                                bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 12,
                                width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    fileprivate func fetchProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check for errors
            if let err = error {
                print("error attempting to fetch profile image: \(err)")
                return
            }
            
            // check the response
            guard let response = response else { return }
            guard let responseHTTP = response as? HTTPURLResponse else { return }
            print("status code: \(responseHTTP.statusCode)")
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }
    
} // UserProfileHeaderView

