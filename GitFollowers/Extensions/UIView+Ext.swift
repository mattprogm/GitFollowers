//
//  UIView+Ext.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 25/03/24.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
    
}
