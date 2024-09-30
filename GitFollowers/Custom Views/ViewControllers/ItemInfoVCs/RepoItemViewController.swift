//
//  RepoItemViewController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 20/03/24.
//

import UIKit

protocol RepoInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class RepoItemViewController: ItemInfoViewController {
    
    weak var delegate: RepoInfoViewControllerDelegate!

    init(user: User, delegate: RepoInfoViewControllerDelegate!) {
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
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    
}


