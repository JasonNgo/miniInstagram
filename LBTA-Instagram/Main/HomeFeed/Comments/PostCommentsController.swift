//
//  PostCommentsController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-03.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class PostCommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    // MARK: - Properties
    
    var comment: Comment? {
        didSet {
            
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Views and Selectors
    
    let commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a comment here"
        return textfield
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmitPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, paddingTop: 0, right: containerView.rightAnchor, paddingRight: -12,
                            bottom: containerView.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0,
                            width: 50, height: 0)
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, paddingTop: 0, right: submitButton.leftAnchor, paddingRight: -12,
                                bottom: containerView.bottomAnchor, paddingBottom: 0, left: containerView.leftAnchor, paddingLeft: 12,
                                width: 0, height: 0)
        
        return containerView
    }()
    
    @objc func handleSubmitPressed() {
        print("submit pressed")
        resignFirstResponder()
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupCollectionController() {
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

} // PostCommentsController
