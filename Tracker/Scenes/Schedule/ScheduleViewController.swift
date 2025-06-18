//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 14.06.2025.
//

import UIKit

protocol ScheduleDelegate: AnyObject {
    func didFinish(with days: Set<WeekDay>)
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var daysTableView: AutoHeightTableView = {
        let tableView = AutoHeightTableView()
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: ScheduleDelegate?
    
    // MARK: - Private Properties
    
    private let weekDays = WeekDay.allCases
    private var chosenWeekDays: Set<WeekDay>
    
    // MARK: - Initializers
    
    init(chosenWeekDays: Set<WeekDay> = []) {
        self.chosenWeekDays = chosenWeekDays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        daysTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonTapped() {
        delegate?.didFinish(with: chosenWeekDays)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = "Расписание"
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(daysTableView, confirmButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            daysTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            daysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: daysTableView.bottomAnchor, constant: 24),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.identifier,
            for: indexPath) as? ScheduleCell
        else {
            return UITableViewCell()
        }
        
        let day = weekDays[indexPath.row]
        let isOn = chosenWeekDays.contains(day)
        
        cell.update(with: day, isOn: isOn)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - ScheduleCellDelegate

extension ScheduleViewController: ScheduleCellDelegate {
    
    func didToggleSwitch(for cell: ScheduleCell, isOn: Bool) {
        guard 
            let indexPath = daysTableView.indexPath(for: cell),
            indexPath.row < weekDays.count
        else {
            return
        }
        
        let day = weekDays[indexPath.row]
        switch (day, isOn) {
            case (let day, false): chosenWeekDays.remove(day)
            case (let day, true): chosenWeekDays.insert(day)
        }
    }
}
