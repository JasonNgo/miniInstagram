//
//  PhotoSelectorController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    fileprivate let headerID = "headerID"
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllerStyling()
        setupNavigationButtons()
        
        
        collectionView?.register(UICollectionViewCell.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerID)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupControllerStyling() {
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    fileprivate func setupNavigationButtons() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain,
                                           target: self, action: #selector(handleCancelButtonPressed))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain,
                                         target: self, action: #selector(handleNextButtonPressed))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // MARK: Selector Functions
    
    @objc func handleCancelButtonPressed() {
        print("cancel pressed")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButtonPressed() {
        print("next pressed")
    }
    
    // MARK: UICollectionView Functions
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .orange
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Header Functions
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerID,
                                                                     for: indexPath)
        header.backgroundColor = .red
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
}
