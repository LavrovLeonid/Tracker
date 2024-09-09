//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/7/24.
//

import UIKit

final class OnboardingPageViewController: UIViewController, PresentingViewController, OnboardingPageViewControllerProtocol {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .onboardingPrimary
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    func configure(backgroundImage: UIImage, text: String) {
        backgroundImageView.image = backgroundImage
        textLabel.text = text
    }
    
    func setupView() {
        
    }
    
    func setupSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(textLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
