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
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var statsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var tabBarSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarSeparatorBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private Properties
    
    private let trackerRecordStore: TrackerRecordStoreProtocol
    
    private var visibleStats: [StatsType] = []
    private var trackerRecords: [TrackerRecord] = []
    
    // MARK: - Initializers
    
    init(trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()) {
        self.trackerRecordStore = trackerRecordStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        trackerRecords = getRecordsFromStore()
        reloadTableView()
        
        trackerRecordStore.delegate = self
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
            statsTableView,
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
            statsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            statsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statsTableView.bottomAnchor.constraint(equalTo: tabBarSeparatorView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabBarSeparatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBarSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func getRecordsFromStore() -> [TrackerRecord] {
        trackerRecordStore.trackerRecords.compactMap {
            TrackerRecord(from: $0)
        }
    }
    
    private func reloadTableView() {
        let doneTrackerCount = trackerRecords.count
        
        visibleStats = doneTrackerCount > 0 ? [.totalDone(doneTrackerCount)] : []
        statsTableView.reloadData()
        
        let isEmptyResult = visibleStats.isEmpty
        infoImageView.isHidden = !isEmptyResult
        infoLabel.isHidden = !isEmptyResult
        statsTableView.isHidden = isEmptyResult
    }
}

// MARK: - UITableViewDataSource

extension StatsViewController: UITableViewDataSource {
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        visibleStats.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatsCell.identifier,
            for: indexPath) as? StatsCell
        else {
            return UITableViewCell()
        }
        
        cell.update(with: visibleStats[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        12
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

// MARK: - TrackerRecordStoreDelegate

extension StatsViewController: TrackerRecordStoreDelegate {
    
    func storeDidUpdate() {
        trackerRecords = getRecordsFromStore()
        reloadTableView()
    }
}
