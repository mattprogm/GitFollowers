//
//  GFAvatarImageView.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 08/03/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.share.cache
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
        Task {
            image = await NetworkManager.share.downloadImage(from: url) ?? placeholderImage
        }
    }
        
}
