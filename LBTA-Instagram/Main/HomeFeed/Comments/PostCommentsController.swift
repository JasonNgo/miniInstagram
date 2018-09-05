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
    
    override var inputAccessoryView: UIView? { return containerView }
    override var canBecomeFirstResponder: Bool { return true }

    var post: Post?
    var user: User?
    var comments = [Comment]()

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
    
    @objc func handleSubmitPressed() {
        print("submit pressed")
        
        guard let caption = commentTextField.text, commentTextField.text?.isEmpty == false else { return }
        guard let user = self.user else { return }
        guard let post = self.post else { return }
        
        let values = [
            "comment_user_id": user.uuid,
            "comment_caption": caption,
            "creation_date": Date().timeIntervalSince1970
        ] as [String: Any]
    
        FirebaseAPI.shared.saveCommentToDatabaseForPost(post, values: values) { (error) in
            if let error = error {
                // comment wasn't saved successfully
                print(error)
                return
            }
            
            self.resignFirstResponder()
            self.fetchComments()
        }
    }
    
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
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionController()

        fetchComments()
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
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, -50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -50, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchComments() {
        FirebaseAPI.shared.fetchCommentsForPost(post!) { (comments, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let comments = comments else { return }
            self.comments = comments
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        cell.post = post
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

} // PostCommentsController
