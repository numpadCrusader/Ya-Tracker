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
        collectionView.contentInset.bottom = 60
        collectionView.backgroundColor = .ypWhite
        
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypBlue
        button.setTitle(LocalizedStrings.filterButtonTitle, for: .normal)
        button.setTitleColor(.ypWhiteConst, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private Properties
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date().dateOnly
    private var currentFilter: TrackerFilter?
    
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
    
    @objc private func filterButtonTapped() {
        let viewController = FilterListViewController(chosenFilter: currentFilter)
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }
    
    // MARK: - Public Methods
    
    func makeMockTrackers() {
        categories = MockTrackerProvider.makeMockTrackers()
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
        view.addSubviews(
            infoImageView,
            infoLabel,
            trackerCollectionView,
            tabBarSeparatorView,
            filterButton)
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
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .plusIcon.withTintColor(.ypBlack, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(addNewTrackButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.title = LocalizedStrings.trackersSceneTitle
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
                let neverCompleted = trackerRecordStore.recordCount(for: tracker.id) == 0
                let completedToday = trackerRecordStore.hasRecord(for: tracker.id, on: currentDate)
                let isScheduledToday = tracker.schedule.contains(currentWeekDay)
                let isOneTimeTask = tracker.schedule.isEmpty
                
                let shouldInclude = isOneTimeTask ?
                    (neverCompleted || completedToday)
                    : isScheduledToday
                
                if !shouldInclude { return false }
                
                switch currentFilter {
                    case .done: return completedToday
                    case .undone: return !completedToday
                    default: return true
                }
            }
            
            return combinedTrackers.isEmpty ? nil
            : TrackerCategory(title: category.title, trackers: combinedTrackers)
        }
        
        visibleCategories = filteredCategories
        trackerCollectionView.reloadData()
        
        let isEmptyResult = visibleCategories.isEmpty
        infoImageView.isHidden = !isEmptyResult
        infoLabel.isHidden = !isEmptyResult
        trackerCollectionView.isHidden = isEmptyResult
        filterButton.isHidden = currentFilter == nil && isEmptyResult
    }
    
    private func getCategoriesFromStore() -> [TrackerCategory] {
        trackerCategoryStore.trackerCategories.compactMap {
            TrackerCategory(from: $0)
        }
    }
    
    private func pinTracker(at indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        guard
            sectionIndex < visibleCategories.count,
            rowIndex < visibleCategories[sectionIndex].trackers.count
        else {
            return
        }
        
        let trackerToPin = visibleCategories[sectionIndex].trackers[rowIndex]
        trackerStore.pinTracker(trackerToPin)
    }
    
    private func unpinTracker(at indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        guard
            sectionIndex < visibleCategories.count,
            rowIndex < visibleCategories[sectionIndex].trackers.count
        else {
            return
        }
        
        let trackerToPin = visibleCategories[sectionIndex].trackers[rowIndex]
        trackerStore.unpinTracker(trackerToPin)
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
        
        let trackerToDelete = visibleCategories[sectionIndex].trackers[rowIndex]
        
        let alert = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ) { [weak self] _ in
            self?.trackerStore.deleteTracker(trackerToDelete)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
        let isPinned = visibleCategories[indexPath.section].title == GlobalConstants.pinCategory
        
        cell.update(with: trackerModel, and: streakCount)
        cell.setIsDone(isDoneToday)
        cell.setIsPinned(isPinned)
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
        let isPinned = visibleCategories[indexPath.section].title == GlobalConstants.pinCategory
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { [weak self] _ in
            guard let self else { return nil }
            
            let pinAction = UIAction(title: isPinned ? "Открепить" : "Закрепить") { _ in
                isPinned ? self.unpinTracker(at: indexPath) : self.pinTracker(at: indexPath)
            }
            
            let editAction = UIAction(title: "Редактировать") { _ in
                self.editTracker(at: indexPath)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                self.deleteTracker(at: indexPath)
            }
            
            return UIMenu(children: [pinAction, editAction, deleteAction])
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

// MARK: - FilterListDelegate

extension TracksViewController: FilterListDelegate {
    
    func didFinish(with filter: TrackerFilter) {
        switch filter {
            case .all, .today:
                currentFilter = nil
                
                if filter == .today {
                    let today = Date()
                    datePicker.date = today
                    currentDate = today.dateOnly
                }
                
            case .done, .undone:
                currentFilter = filter
        }
        
        updateUIForFiltering()
        reloadCollectionView()
    }
    
    private func updateUIForFiltering() {
        if currentFilter != nil {
            filterButton.backgroundColor = .ypRed
            infoLabel.text = "Ничего не найдено"
            infoImageView.image = .emptySearchIcon
        } else {
            filterButton.backgroundColor = .ypBlue
            infoLabel.text = "Что будем отслеживать?"
            infoImageView.image = .star
        }
    }
}
