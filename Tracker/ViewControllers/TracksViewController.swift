//
//  TracksViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 05.05.2025.
//

import UIKit

final class TracksViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = .white
        
        addSubviews()
        addConstraints()
        setupNavBar()
        setupSearchController()
    }
    
    private func addSubviews() {
        view.addSubviews(infoImageView, infoLabel)
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
    }
    
    private func setupNavBar() {
        let plus = UIImage(named: "plus_icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: plus, style: .plain, target: nil, action: nil)
        
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }
}
