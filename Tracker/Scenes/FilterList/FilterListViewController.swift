//
//  FilterListViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 10.07.2025.
//

import UIKit

protocol FilterListDelegate: AnyObject {
    func didFinish(with filter: TrackerFilter)
}

final class FilterListViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var filtersTableView: AutoHeightTableView = {
        let tableView = AutoHeightTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: FilterListDelegate?
    
    // MARK: - Private Properties
    
    private let allFilters = TrackerFilter.allCases
    private var chosenFilter: TrackerFilter?
    
    // MARK: - Initializers
    
    init(chosenFilter: TrackerFilter?) {
        self.chosenFilter = chosenFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        filtersTableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = "Фильтры"
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(filtersTableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource

extension FilterListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.identifier,
            for: indexPath) as? FilterCell
        else {
            return UITableViewCell()
        }
        
        let filter = allFilters[indexPath.row]
        let isSelected = filter == chosenFilter
        let isLast = allFilters.count - 1 == indexPath.row
        
        cell.update(
            with: filter,
            isSelected: isSelected,
            isLast: isLast)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didFinish(with: allFilters[indexPath.row])
    }
}
