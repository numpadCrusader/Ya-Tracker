//
//  AddTrackViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

protocol AddTrackViewControllerDelegate: AnyObject {
    func didCancelAddingTrack()
    func didFinishAddingTrack(_ newTrackerCategory: TrackerCategory)
}

final class AddTrackViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var newHabbitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(newHabbitButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(newTaskButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: AddTrackViewControllerDelegate?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions
    
    @objc private func newHabbitButtonTapped(_ sender: UIButton) {
        let viewController = TrackDetailsViewController(trackerType: .habbit)
        viewController.delegate = self
        
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }
    
    @objc private func newTaskButtonTapped(_ sender: UIButton) {
        let viewController = TrackDetailsViewController(trackerType: .task)
        viewController.delegate = self
        
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = "Создание трекера"
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(newHabbitButton, newTaskButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            newHabbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newHabbitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            newTaskButton.topAnchor.constraint(equalTo: newHabbitButton.bottomAnchor, constant: 16),
            newTaskButton.leadingAnchor.constraint(equalTo: newHabbitButton.leadingAnchor),
            newTaskButton.trailingAnchor.constraint(equalTo: newHabbitButton.trailingAnchor),
            newTaskButton.heightAnchor.constraint(equalTo: newHabbitButton.heightAnchor)
        ])
    }
}

// MARK: - TrackDetailsViewControllerDelegate

extension AddTrackViewController: TrackDetailsDelegate {
    
    func didCancelAddingTrack() {
        delegate?.didCancelAddingTrack()
    }
    
    func didFinishAddingTrack(_ trackerCategory: TrackerCategory) {
        delegate?.didFinishAddingTrack(trackerCategory)
    }
}
