//
//  TrackDetailsViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

protocol TrackDetailsDelegate: AnyObject {
    func didFinishAddingTrack()
}

final class TrackDetailsViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var trackTitleTextField: PaddedTextField = {
        let grayColor: UIColor = .ypGray
        let attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [.foregroundColor: grayColor])
        
        let textField = PaddedTextField()
        textField.attributedPlaceholder = attributedPlaceholder
        textField.backgroundColor = .ypBackgroundDay
        textField.tintColor = .ypBlue
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17)
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var trackerDetailsTableView: AutoHeightTableView = {
        let tableView = AutoHeightTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackDetailCell.self, forCellReuseIdentifier: TrackDetailCell.identifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var botButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let redColor: UIColor = .ypRed
        
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(redColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = redColor.cgColor
        button.addTarget(self, action: #selector(cancelCreateButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(cancelCreateButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private Properties
    
    weak var delegate: TrackDetailsDelegate?
    
    // MARK: - Private Properties
    
    private let trackerType: TrackerType
    private let trackerDetails: [TrackerType.Detail]

    // MARK: - Initializers
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        trackerDetails = trackerType.details
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        trackerDetailsTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func cancelCreateButtonTapped() {
        delegate?.didFinishAddingTrack()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = trackerType.title
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(
            trackTitleTextField,
            trackerDetailsTableView,
            botButtonStackView)
        
        botButtonStackView.addArrangedSubviews(cancelButton, createButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackTitleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            trackerDetailsTableView.topAnchor.constraint(equalTo: trackTitleTextField.bottomAnchor, constant: 24),
            trackerDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            botButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            botButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            botButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            botButtonStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func routeToSchedule() {
        let navController = UINavigationController(rootViewController: ScheduleViewController())
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TrackDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackDetailCell.identifier,
            for: indexPath) as? TrackDetailCell
        else {
            return UITableViewCell()
        }
        
        cell.update(
            with: trackerDetails[indexPath.row],
            isLast: indexPath.row == trackerDetails.count - 1)
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension TrackDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if trackerDetails[indexPath.row] == .schedule {
            routeToSchedule()
        }
    }
}
