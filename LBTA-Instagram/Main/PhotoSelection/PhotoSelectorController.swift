//
//  PhotoSelectorController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    fileprivate let headerID = "headerID"
    
    var assets = [PHAsset]()
    var photos = [UIImage]()
    var selectedPhoto: UIImage?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up functions
        setupControllerStyling()
        setupNavigationButtons()
        
        // register cells and header view
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(PhotoSelectorHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        
        // fetch photos
        fetchPhotos()
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupControllerStyling() {
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    fileprivate func setupNavigationButtons() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonPressed))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButtonPressed))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // MARK: - Fetching Functions
    
    fileprivate func fetchPhotos() {
        print("fetching photos")
        
        let photos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            photos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.photos.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedPhoto == nil {
                            self.selectedPhoto = image
                        }
                    }
                    
                    if count == photos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Selector Functions
    
    @objc func handleCancelButtonPressed() {
        print("cancel pressed")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButtonPressed() {
        print("next pressed")
        guard let selectedPhoto = selectedPhoto else { return }
        
        let sharePhotoController = SharePhotoController()
        sharePhotoController.photoImage = selectedPhoto
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    // MARK: - UICollectionView Functions
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = photos[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPhoto = photos[indexPath.item]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: Header Functions
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeaderView
        header.image = selectedPhoto
        
        if let selectedPhoto = self.selectedPhoto {
            if let index = photos.index(of: selectedPhoto) {
                let selectedAsset = assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    if let image = image {
                        header.image = image
                    }
                }
            }
        }
    
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.fetchLimit = 10
        options.sortDescriptors = [sortDescriptor]
        return options
    }
    
} // PhotoSelectorController
