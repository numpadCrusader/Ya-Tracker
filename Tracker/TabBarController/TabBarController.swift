//
//  TabBarController.swift
//  Tracker
//
//  Created by Nikita Khon on 07.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - UITabBarController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tracksViewController = makeTracksViewController()
        let statsViewController = makeStatsViewController()
        viewControllers = [tracksViewController, statsViewController]
        
        tabBar.tintColor = .ypBlue
    }
    
    // MARK: - Private Methods
    
    private func makeTracksViewController() -> UIViewController {
        let viewController = TracksViewController()
        
        viewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tracks_icon"),
            selectedImage: nil
        )
        
        return viewController
    }
    
    private func makeStatsViewController() -> UIViewController {
        let viewController = StatsViewController()
        
        viewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats_icon"),
            selectedImage: nil
        )
        
        return viewController
    }
}
