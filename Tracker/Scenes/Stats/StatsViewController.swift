//
//  StatsViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 07.05.2025.
//

import UIKit

final class StatsViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sadEmojiIcon
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isHidden = true
        return label
    }()
    
    private lazy var tabBarSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarSeparatorBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        navigationItem.title = LocalizedStrings.statsSceneTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(
            infoImageView,
            infoLabel,
            tabBarSeparatorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            infoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 8),
            infoLabel.centerXAnchor.constraint(equalTo: infoImageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabBarSeparatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBarSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
