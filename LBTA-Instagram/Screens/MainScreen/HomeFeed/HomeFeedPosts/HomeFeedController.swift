//
//  HomeFeedController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-25.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedController: UICollectionViewController {
    private let user: User
    private let dataSource: HomeFeedDataSource
    
    // MARK: - Styling Constants
    private var cellHeight: CGFloat {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return height
    }
    
    private var cellWidth: CGFloat {
        return view.frame.width
    }
    
    // MARK: - Notifications
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "updateHomeFeed")
    
    // MARK: - Initializer
    init(user: User) {
        self.user = user
        self.dataSource = HomeFeedDataSource(user: user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    // MARK: - Required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        
        dataSource.getItems { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        let image = #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal)
        let cameraBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCameraPressed))
        navigationItem.leftBarButtonItem = cameraBarItem
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = dataSource
        collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: dataSource.reuseId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: HomeFeedController.updateFeedNotificationName, object: nil)
    }
    
    // MARK: - Selector Functions
    @objc private func handleRefresh() {
        dataSource.getItems { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    @objc private func handleCameraPressed() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegate
extension HomeFeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - HomePostViewCellDelegate
extension HomeFeedController: HomePostViewCellDelegate {
    func didTapCommentButton(post: Post) {
        let layout = UICollectionViewFlowLayout()
        let commentsController = PostCommentsController(collectionViewLayout: layout)
        commentsController.post = post
        commentsController.user = user
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didTapLikeButton(for cell: HomePostViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell),
            let post = dataSource.item(for: indexPath.item) else {
            return
        }
        
        let values = [user.uuid: !post.isLiked]
        
        FirebaseAPI.shared.updateLikesForPost(post, values: values) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            self.dataSource.toggleIsLikedForPost(at: indexPath.item)
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
    func didTapShareButton(for cell: HomePostViewCell) {
        let vc = UIActivityViewController(activityItems: [cell.postImageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
