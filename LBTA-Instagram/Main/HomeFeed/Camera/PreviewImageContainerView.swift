//
//  PreviewImageContainerView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-02.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Photos

class PreviewImageContainerView: UIView {
    
    // MARK: - Views and Selectors
    
    var previewImage: UIImage? {
        didSet {
            previewImageView.image = previewImage
        }
    }

    let previewImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    let cancelPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancelPhoto() {
        print("cancel photo pressed")
        self.removeFromSuperview()
    }
    
    let savePhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSavePhoto() {
        print("save photo pressed")
        
        guard let previewImage = self.previewImage else { return }
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("failed to save image to photo library: \(String(describing: error))")
                return
            }
            
            print("successfully saved image to library")
            
            DispatchQueue.main.async {
                self.displaySaveMessage()
            }
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupViews() {
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, paddingTop: 0, right: rightAnchor, paddingRight: 0,
                                bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0,
                                width: 0, height: 0)
        
        addSubview(cancelPhotoButton)
        cancelPhotoButton.anchor(top: topAnchor, paddingTop: 12, right: nil, paddingRight: 0,
                                 bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 12,
                                 width: 50, height: 50)
        
        addSubview(savePhotoButton)
        savePhotoButton.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0,
                               bottom: bottomAnchor, paddingBottom: -12, left: leftAnchor, paddingLeft: 12,
                               width: 50, height: 50)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func displaySaveMessage() {
        let saveLabel: UILabel = {
            let label = UILabel()
            label.text = "Saved Successfully"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 0
            label.backgroundColor = UIColor(white: 0, alpha: 0.3)
            label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            label.center = self.center
            return label
        }()
        
        self.addSubview(saveLabel)
        saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                saveLabel.transform = .identity
            }, completion: { (completed) in
                saveLabel.removeFromSuperview()
            })
        })
    }
    
} // PreviewImageContainerView
