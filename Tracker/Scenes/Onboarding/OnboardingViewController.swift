//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 18.06.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Visual Components
    
    private lazy var pages: [UIViewController] = {
        let pageOne = PageContentViewController(
            infoText: "Отслеживайте только то, что хотите",
            backgroundImage: .onboardingStepOne)
        
        let pageTwo = PageContentViewController(
            infoText: "Даже если это не литры воды и йога",
            backgroundImage: .onboardingStepTwo)
        
        return [pageOne, pageTwo]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlue.withAlphaComponent(0.3)
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        dataSource = self
        delegate = self
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(pageControl)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        let wrappedIndex = (previousIndex + pages.count) % pages.count
        
        return pages[wrappedIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = (viewControllerIndex + 1) % pages.count
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
