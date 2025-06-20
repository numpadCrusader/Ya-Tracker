//
//  InitialViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

final class InitialViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ypLogo
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Private Properties
    
    private let userDefaultsService = UserDefaultsService.shared
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !userDefaultsService.hasLaunched {
            routeToOnboardingScene()
        } else {
            switchToTabBarController()
        }
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = .ypBlue
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func routeToOnboardingScene() {
        let viewController = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = TabBarController()
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {})
    }
}
