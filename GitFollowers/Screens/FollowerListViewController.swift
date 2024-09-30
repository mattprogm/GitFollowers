//
//  FollowerListViewController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 07/03/24.
//

import UIKit

class FollowerListViewController: DataLoadingViewController {
    
    enum Section {
        case main
    }
    
    var hasMoreFollowers = true
    var page = 1
    var username: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var isLoadingMoreFollowers = false
    var isSearching = false
    var followers: [Follower] = []
    var filterFollowers: [Follower] = []
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No Followers"
            config.secondaryText = "This user has no followers. Go follow them!"
            contentUnavailableConfiguration = config
        } else if isSearching && filterFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: SFSymbols.favoriteIcon, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManager.share.getUserInfo(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGitFollowAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.uptadeWith(favorite: favorite, actionType: .add) {[weak self] error in
            guard let self else {return}
            guard let error else {
                DispatchQueue.main.async {
                    self.presentGitFollowAlert(title: "Success!", message: "You have successfully favorited this user 🎉 ", buttonTitle: "Ok")
                }
                
                return
            }
            DispatchQueue.main.async {
                self.presentGitFollowAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getFollowers (username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.share.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let gfError = error as? GFError {
                    presentGitFollowAlert(title: "Bad Stuff Happened", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                isLoadingMoreFollowers = false
                dismissLoadingView()
            }
        }
        
//        NetworkManager.share.getFollowers(for: username, page: page) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//              
//            case .failure(let error):
//                self.presentGitFollowAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
//            }
//            
//            self.isLoadingMoreFollowers = false
//        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.followers.append(contentsOf: followers)
        self.updateData(on: self.followers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayour(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseID, for: indexPath) as! FollowerCollectionViewCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
}

//MARK: - CollectionViewDelegate

extension FollowerListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY  = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // W ? T : F TERNARY OPERATOR
        let activeArray = isSearching ? filterFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoViewController()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        
        present(navController, animated: true)
        
    }
    
}

//MARK: - Search

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filterFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            setNeedsUpdateContentUnavailableConfiguration()
            return
        }
        
        isSearching = true
        filterFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filterFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }

}

extension FollowerListViewController: UserInfoViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filterFollowers.removeAll()
        page = 1
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
        navigationItem.searchController?.searchBar.text = ""
    }
    
}
