//
//  UIViewController+Ext.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 07/03/24.
//

import UIKit
import SafariServices


extension UIViewController {
    
    func presentGitFollowAlert(title: String, message: String, buttonTitle: String) {
            let alertVC = GitFollowAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func presentDefaultError() {
            let alertVC = GitFollowAlertViewController(title: "Something Went Wrong", message: "Unable to complete task.", buttonTitle: "Ok")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
    }
    
    
    
}


