//
//  GitFollowAlertViewController.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 07/03/24.
//

import UIKit

class GitFollowAlertViewController: UIViewController {
    
    let containerView = GFAlertContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let errorMessageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(color: .systemPink, title: "Ok", systemImageName: "checkmark.circle")
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, errorMessageLabel)
        
//        configureBackgroundBlur()
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureErrorMessageLabel()
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong :c"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dissmissViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureErrorMessageLabel() {
        errorMessageLabel.text = message ?? "Unable to complete request"
        errorMessageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            errorMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            errorMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            errorMessageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

//    func configureBackgroundBlur() {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.alpha = 0.80
//        blurredEffectView.frame = self.view.bounds
//        self.view.addSubview(blurredEffectView)
//    }
    
    @objc func dissmissViewController() {
        dismiss(animated: true)
    }
}