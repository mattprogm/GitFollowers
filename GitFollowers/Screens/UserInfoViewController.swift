//
//  UserInfoViewController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 18/03/24.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoViewController: DataLoadingViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    let dateLabel = GFBodyLabel(textAlignment: .center)
    weak var delegate: UserInfoViewControllerDelegate!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVc))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func getUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.share.getUserInfo(for:username)
                configureUIElements(with: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGitFollowAlert(title: "Something Went Wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func configureUIElements(with user: User) {
        self.add(chieldVC: UserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(chieldVC: RepoItemViewController(user: user, delegate: self), to: self.itemViewOne)
        self.add(chieldVC: FollowerItemViewController(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func add(chieldVC: UIViewController, to containerView: UIView) {
        addChild(chieldVC)
        containerView.addSubview(chieldVC.view)
        chieldVC.view.frame = containerView.bounds
        chieldVC.didMove(toParent: self)
    }
    
    @objc func dismissVc() {
        dismiss(animated: true)
    }
    
}

extension UserInfoViewController: RepoInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGitFollowAlert(title: "Invalid Url", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
        
}

extension UserInfoViewController: FollowerItemViewControllerDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGitFollowAlert(title: "No followers", message: "This user has no followers 😔", buttonTitle: "Ok")
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        dismissVc()
    }
    
}
