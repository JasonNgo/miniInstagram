//
//  UserSeachController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-26.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

enum UserSearchResult {
    case success
    case failure(Error)
}

enum FollowUserResult {
    case success
    case failure(Error)
}

enum UnfollowUserResult {
    case success
    case failure(Error)
}

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate let cellId = "cellId"
    
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "enter username"
        searchBar.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.colorFrom(r: 240, g: 240, b: 240)
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupSearchBar()
        setupCollectionView()
        
        fetchListOfUsers()
    }
    
    // MARK: - Setup functions
    
    fileprivate func setupSearchBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(searchBar)
        searchBar.anchor(top: navBar.topAnchor, paddingTop: 0,
                         right: navBar.rightAnchor, paddingRight: -8,
                         bottom: navBar.bottomAnchor, paddingBottom: 0,
                         left: navBar.leftAnchor, paddingLeft: 8,
                         width: 0, height: 0)
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        print(user.username)
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let layout = UICollectionViewLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        userProfileController.userId = user.uuid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        collectionView?.reloadData()
    }
    
    // MARK: - Fetching Functions
    
    fileprivate func fetchListOfUsers() {
        FirebaseAPI.shared.fetchUsersWithSearch("Dummy") { (users, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let users = users else { return }
            self.users = users
            self.filteredUsers = users
            
            self.collectionView?.reloadData()
        }
    }
    
}
