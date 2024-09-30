//
//  GFTabBarController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 21/03/24.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = .systemGreen
        self.viewControllers = [createSearchNavigationController(), createFavoritesListNavigationController()]

    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavoritesListNavigationController() -> UINavigationController {
        let favoriteListViewController = FavoritesListViewController()
        favoriteListViewController.title = "Favorites"
        favoriteListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteListViewController)
    }

}
