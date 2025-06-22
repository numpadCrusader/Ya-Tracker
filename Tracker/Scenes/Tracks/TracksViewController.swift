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
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date().dateOnly
    
    // MARK: - Initializers
    
    init(
        trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore(),
        trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore(),
        trackerStore: TrackerStoreProtocol = TrackerStore()
    ) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.trackerStore = trackerStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        categories = getCategoriesFromStore()
        reloadCollectionView()
        
        trackerCategoryStore.delegate = self
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
                    let notCompleted = trackerRecordStore.recordCount(for: tracker.id) == 0
                    let completedToday = trackerRecordStore.hasRecord(for: tracker.id, on: currentDate)
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
    
    private func getCategoriesFromStore() -> [TrackerCategory] {
        trackerCategoryStore.trackerCategories.compactMap {
            TrackerCategory(from: $0)
        }
    }
    
    private func deleteTracker(at indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        guard
            sectionIndex < visibleCategories.count,
            rowIndex < visibleCategories[sectionIndex].trackers.count
        else {
            return
        }
        
        trackerStore.deleteTracker(visibleCategories[sectionIndex].trackers[rowIndex])
    }
    
    private func editTracker(at indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        guard
            sectionIndex < visibleCategories.count,
            rowIndex < visibleCategories[sectionIndex].trackers.count
        else {
            return
        }
        
        let categoryTitle = visibleCategories[sectionIndex].title
        let tracker = visibleCategories[sectionIndex].trackers[rowIndex]
        
        let viewController = TrackDetailsViewController(
            trackerDetailsMode: .edit(
                tracker: tracker,
                ofCategory: categoryTitle))
        
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
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
        let isDoneToday = trackerRecordStore.hasRecord(for: trackerModel.id, on: currentDate)
        let streakCount = trackerRecordStore.recordCount(for: trackerModel.id)
        
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { _ in
            let pin = UIAction(title: "Закрепить") { _ in}
            
            let edit = UIAction(title: "Редактировать") { [weak self] _ in
                guard let self else { return }
                self.editTracker(at: indexPath)
            }
            
            let delete = UIAction(
                title: "Удалить",
                attributes: .destructive
            ) { [weak self] _ in
                guard let self else { return }
                self.deleteTracker(at: indexPath)
            }
            
            return UIMenu(children: [pin, edit, delete])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: cell.trackerCardView.bounds, cornerRadius: 16)

        return UITargetedPreview(view: cell.trackerCardView, parameters: parameters)
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
        
        if trackerRecordStore.hasRecord(for: trackerRecord.trackerId, on: trackerRecord.date) {
            trackerRecordStore.deleteRecord(trackerRecord)
        } else {
            trackerRecordStore.addRecord(trackerRecord)
        }
        
        trackerCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - AddTrackViewControllerDelegate

extension TracksViewController: AddTrackViewControllerDelegate {
    
    func didCancelAddingTrack() {
        dismiss(animated: true)
    }
    
    func didFinishAddingTrack() {
        dismiss(animated: true)
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension TracksViewController: TrackerCategoryStoreDelegate {
    
    func storeDidUpdate() {
        categories = getCategoriesFromStore()
        reloadCollectionView()
    }
}
