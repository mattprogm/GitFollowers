//
//  FollowerItemViewController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 20/03/24.
//

import UIKit

protocol FollowerItemViewControllerDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class FollowerItemViewController: ItemInfoViewController {
    
    weak var delegate: FollowerItemViewControllerDelegate!
    
    init(user: User, delegate: FollowerItemViewControllerDelegate!) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItens()
    }
    
    private func configureItens() {
        itemInfoViewOne.set(itemInfoType: .following, withCount: user.following)
        itemInfoViewTwo.set(itemInfoType: .followers, withCount: user.followers)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
    
}
