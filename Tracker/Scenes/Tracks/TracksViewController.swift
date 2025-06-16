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
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIView.noIntrinsicMetric, height: 18)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 9
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.contentInset.top = 24
        
        collectionView.register(
            CategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tabBarSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarSeparatorBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date().dateOnly
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        reloadCollectionView()
    }
    
    // MARK: - Actions
    
    @objc private func addNewTrackButtonTapped() {
        let viewController = AddTrackViewController()
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date.dateOnly
        reloadCollectionView()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = .ypWhite
        
        setupNavBar()
        setupSearchController()
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(infoImageView, infoLabel, trackerCollectionView, tabBarSeparatorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: tabBarSeparatorView.topAnchor)
        ])
        
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
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .plusIcon.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(addNewTrackButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .ypBlue
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func reloadCollectionView() {
        let currentWeekDay = currentDate.weekDay
        
        let filteredCategories = categories.compactMap { category -> TrackerCategory? in
            let combinedTrackers = category.trackers.filter { tracker in
                if tracker.schedule.isEmpty {
                    let notCompleted = !completedTrackers.contains { $0.trackerId == tracker.id }
                    
                    let completedToday = completedTrackers.contains {
                        $0.trackerId == tracker.id && $0.date == currentDate
                    }
                    
                    return notCompleted || completedToday
                }
                
                return tracker.schedule.contains(currentWeekDay)
            }
            
            return combinedTrackers.isEmpty ? nil
            : TrackerCategory(title: category.title, trackers: combinedTrackers)
        }
        
        visibleCategories = filteredCategories
        trackerCollectionView.reloadData()
        
        infoImageView.isHidden = !visibleCategories.isEmpty
        infoLabel.isHidden = !visibleCategories.isEmpty
        trackerCollectionView.isHidden = visibleCategories.isEmpty
    }
}

// MARK: - UICollectionViewDataSource

extension TracksViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        
        let trackerModel = visibleCategories[indexPath.section].trackers[indexPath.row]
        let trackerRecords = completedTrackers.filter { $0.trackerId == trackerModel.id }
        let isDoneToday = trackerRecords.contains { $0.date == currentDate }
        let streakCount = trackerRecords.count
        
        cell.update(with: trackerModel, and: streakCount)
        cell.setIsDone(isDoneToday)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
                for: indexPath) as? CategoryHeaderView
        else {
            return UICollectionReusableView()
        }
        
        header.update(with: visibleCategories[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TracksViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 9
        
        let availableWidth = collectionView.bounds.width - spacing
        let width = availableWidth / itemsPerRow
        return CGSize(width: floor(width), height: 148)
    }
}

// MARK: - TrackerCellDelegate

extension TracksViewController: TrackerCellDelegate {
    
    func didTapActionButton(_ cell: TrackerCell) {
        guard
            let indexPath = trackerCollectionView.indexPath(for: cell),
            indexPath.section < visibleCategories.count,
            indexPath.row < visibleCategories[indexPath.section].trackers.count,
            currentDate <= Date().dateOnly
        else {
            return
        }
        
        let trackerModel = visibleCategories[indexPath.section].trackers[indexPath.row]
        let trackerRecord = TrackerRecord(trackerId: trackerModel.id, date: currentDate)
        
        if completedTrackers.contains(trackerRecord) {
            completedTrackers.remove(trackerRecord)
        } else {
            completedTrackers.insert(trackerRecord)
        }
        
        trackerCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - AddTrackViewControllerDelegate

extension TracksViewController: AddTrackViewControllerDelegate {
    
    func didCancelAddingTrack() {
        dismiss(animated: true)
    }
    
    func didFinishAddingTrack(_ newTrackerCategory: TrackerCategory) {
        if let oldCategory = categories.first(where: { $0.title == newTrackerCategory.title }) {
            let mergedCategory = TrackerCategory(
                title: oldCategory.title,
                trackers: oldCategory.trackers + newTrackerCategory.trackers)
            
            var updatedCategories = categories.filter { $0.title != oldCategory.title }
            updatedCategories.append(mergedCategory)
            categories = updatedCategories
        } else {
            let updatedCategories = categories + [newTrackerCategory]
            categories = updatedCategories
        }
        
        reloadCollectionView()
        dismiss(animated: true)
    }
}
