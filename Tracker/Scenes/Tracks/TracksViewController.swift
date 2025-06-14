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
        layout.itemSize = CGSize(width: 167, height: 148)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = [
        .init(
            title: "Whatever",
            trackers: [
                .init(
                    id: UUID(),
                    title: "Поливать растения",
                    color: .systemGreen,
                    emoji: "🔥",
                    schedule: .init()
                ),
                .init(
                    id: UUID(),
                    title: "Поливать растения",
                    color: .systemGreen,
                    emoji: "🔥",
                    schedule: .init()
                )
            ]
        ),
        .init(
            title: "Whatever",
            trackers: [
                .init(
                    id: UUID(),
                    title: "Кошка заслонила камеру на созвоне",
                    color: .systemOrange,
                    emoji: "🔥",
                    schedule: .init()
                )
            ]
        ),
        .init(
            title: "Whatever",
            trackers: [
                .init(
                    id: UUID(),
                    title: "Бабушка прислала открытку в вотсапе",
                    color: .systemTeal,
                    emoji: "🔥",
                    schedule: .init()
                )
            ]
        )
    ]
    
    private var completedTrackers: [TrackerRecord] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        trackerCollectionView.reloadData()
        
        infoImageView.isHidden = !categories.isEmpty
        infoLabel.isHidden = !categories.isEmpty
        trackerCollectionView.isHidden = categories.isEmpty
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
        view.addSubviews(infoImageView, infoLabel, trackerCollectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 8),
            infoLabel.centerXAnchor.constraint(equalTo: infoImageView.centerXAnchor)
        ])
    }
    
    @objc func presentA() {
        let abc = UINavigationController(rootViewController: ScheduleViewController())
        present(abc, animated: true)
    }
    
    private func setupNavBar() {
        let plus = UIImage(named: "plus_icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: plus, style: .plain, target: self, action: #selector(presentA))
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
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
}

// MARK: - UICollectionViewDataSource

extension TracksViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categories[section].trackers.count
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
        
        let trackerModel = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(with: trackerModel)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - TrackerCellDelegate

extension TracksViewController: TrackerCellDelegate {
    
    func didTapActionButton(_ cell: TrackerCell) {
        guard let indexPath = trackerCollectionView.indexPath(for: cell) else {
            return
        }
        
        let trackerModel = categories[indexPath.section].trackers[indexPath.row]
//        trackerModel.id
        
        cell.setIsDone(true)
//        trackerCollectionView.reloadItems(at: [indexPath])
    }
}
