//
//  SharePhotoController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    // MARK: - Views
    
    let photoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorFrom(r: 240, g: 240, b: 240)
        
        // setup
        setupNavigationBarButtons()
        setupViews()
    }
    
    // MARK: Set Up Functions
    
    fileprivate func setupNavigationBarButtons() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonPressed))
        let shareBarButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShareButtonPressed))
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    fileprivate func setupViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                             bottom: nil, paddingBottom: 0, left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                             width: 0, height: 100)

        containerView.addSubview(photoImageView)
        photoImageView.anchor(top: containerView.topAnchor, paddingTop: 8, right: nil, paddingRight: 0,
                              bottom: containerView.bottomAnchor, paddingBottom: -8, left: containerView.leftAnchor, paddingLeft: 8,
                              width: 84, height: 0)

        containerView.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: containerView.topAnchor, paddingTop: 8, right: containerView.rightAnchor, paddingRight: -8,
                                    bottom: containerView.bottomAnchor, paddingBottom: -8, left: photoImageView.rightAnchor, paddingLeft: 8,
                                    width: 0, height: 0)
    }
    
    // MARK: - Selector Functions
    
    @objc func handleCancelButtonPressed() {
        print("cancel pressed")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShareButtonPressed() {
        print("share pressed")
        
        guard let photoImage = photoImage else { return }
        guard let caption = descriptionTextView.text, !descriptionTextView.text.isEmpty else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let values = [
            "image_width": photoImage.size.width,
            "image_height": photoImage.size.height,
            "creation_date": Date().timeIntervalSince1970,
            "caption": caption
        ] as [String : Any]
        
        FirebaseAPI.shared.createPost(postImage: photoImage, values: values) { (error) in
            if let error = error {
                print(error)
                return
            }

            print("sucessfully saved post")
            NotificationCenter.default.post(name: HomeFeedController.updateFeedNotificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }

} // SharePhotoController
