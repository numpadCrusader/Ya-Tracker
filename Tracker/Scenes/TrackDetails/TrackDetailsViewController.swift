//
//  TrackDetailsViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

protocol TrackDetailsDelegate: AnyObject {
    func didCancelAddingTrack()
    func didFinishAddingTrack()
}

final class TrackDetailsViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .onDrag
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var trackTitleTextField: PaddedTextField = {
        let trailingButton = UIButton(type: .custom)
        trailingButton.setImage(.xIcon, for: .normal)
        trailingButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        let grayColor: UIColor = .ypGray
        let attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [.foregroundColor: grayColor])
        
        let textField = PaddedTextField()
        textField.delegate = self
        textField.attributedPlaceholder = attributedPlaceholder
        textField.backgroundColor = .ypBackgroundDay
        textField.tintColor = .ypBlue
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17)
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.rightView = trailingButton
        textField.rightViewMode = .never
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypRed
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var emojiSelectorView: EmojiSelectorView = {
        let view = EmojiSelectorView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorSelectorView: ColorSelectorView = {
        let view = ColorSelectorView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: TrackDetailsDelegate?
    
    // MARK: - Private Properties
    
    private let trackerStore: TrackerStoreProtocol
    
    private let trackerType: TrackerType
    private let trackerDetails: [TrackerType.Detail]
    
    private var chosenCategory: String = "Тестовая категория"
    private var chosenWeekDays: Set<WeekDay> = [] {
        didSet {
            isCreateButtonEnabled()
        }
    }
    private var chosenEmoji: String?
    private var chosenColor: UIColor?

    // MARK: - Initializers
    
    init(
        trackerType: TrackerType,
        trackerStore: TrackerStoreProtocol = TrackerStore()
    ) {
        self.trackerType = trackerType
        trackerDetails = trackerType.details
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
        trackerDetailsTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        delegate?.didCancelAddingTrack()
    }
    
    @objc private func createButtonTapped() {
        let trackTitle = trackTitleTextField.text?.trimmingCharacters(in: .whitespaces) ?? "Трекер"
        let emoji = chosenEmoji ?? "🤖"
        let color = chosenColor ?? .systemIndigo
        
        let tracker = Tracker(
            id: UUID(),
            title: trackTitle,
            color: color,
            emoji: emoji,
            schedule: chosenWeekDays)
        
        trackerStore.addNewTracker(tracker, toCategory: chosenCategory)
        delegate?.didFinishAddingTrack()
    }
    
    @objc private func textFieldDidChange() {
        isCreateButtonEnabled()
        isClearTextButtonVisible()
    }
    
    @objc private func clearText() {
        trackTitleTextField.text = ""
        isClearTextButtonVisible()
        isWarningLabelHidden(true)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = trackerType.title
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerStackView,
            trackerDetailsTableView,
            emojiSelectorView,
            colorSelectorView,
            botButtonStackView)
        
        headerStackView.addArrangedSubviews(trackTitleTextField, warningLabel)
        botButtonStackView.addArrangedSubviews(cancelButton, createButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            trackTitleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            trackerDetailsTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 24),
            trackerDetailsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerDetailsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            emojiSelectorView.topAnchor.constraint(equalTo: trackerDetailsTableView.bottomAnchor, constant: 32),
            emojiSelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiSelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            colorSelectorView.topAnchor.constraint(equalTo: emojiSelectorView.bottomAnchor, constant: 40),
            colorSelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorSelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            botButtonStackView.topAnchor.constraint(equalTo: colorSelectorView.bottomAnchor, constant: 40),
            botButtonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            botButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            botButtonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botButtonStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func routeToSchedule() {
        let viewController = ScheduleViewController(chosenWeekDays: chosenWeekDays)
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }
    
    private func isCreateButtonEnabled() {
        let hasTrackTitle = !(trackTitleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let hasChosenWeekDays = trackerType == .task ? true : !chosenWeekDays.isEmpty
        let hasChosenEmoji = chosenEmoji != nil ? true : false
        let hasChosenColor = chosenColor != nil ? true : false
        let isEnabled = hasTrackTitle && hasChosenWeekDays && hasChosenEmoji && hasChosenColor
        
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
    
    private func isClearTextButtonVisible() {
        if trackTitleTextField.isFirstResponder,
           !(trackTitleTextField.text?.isEmpty ?? true) {
            trackTitleTextField.rightViewMode = .always
        } else {
            trackTitleTextField.rightViewMode = .never
        }
    }
    
    private func isWarningLabelHidden(_ isHidden: Bool) {
        if warningLabel.isHidden == isHidden {
            return
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.warningLabel.isHidden = isHidden
        }
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
        
        let trackerDetail = trackerDetails[indexPath.row]
        
        cell.update(
            with: trackerDetail,
            isLast: indexPath.row == trackerDetails.count - 1)
        
        if trackerDetail == .category {
            cell.setDetailSubtitle(chosenCategory)
        }
        
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

// MARK: - ScheduleDelegate

extension TrackDetailsViewController: ScheduleDelegate {
    
    func didFinish(with days: Set<WeekDay>) {
        chosenWeekDays = days
        
        guard 
            let index = trackerDetails.firstIndex(where: { $0 == .schedule}),
            let cell = trackerDetailsTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TrackDetailCell
        else {
            return
        }
        
        cell.setDetailSubtitle(makeChosenDaysString(from: days))
    }
    
    private func makeChosenDaysString(from days: Set<WeekDay>) -> String {
        if days == Set(WeekDay.allCases) {
            return "Каждый день"
        }
        
        return WeekDay.allCases
            .filter { days.contains($0) }
            .map { $0.shortName }
            .joined(separator: ", ")
    }
}

// MARK: - UITextFieldDelegate

extension TrackDetailsViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let isAllowedToType = updatedText.count <= 38
        isWarningLabelHidden(isAllowedToType)
        
        return isAllowedToType
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackTitleTextField.resignFirstResponder()
        return true
    }
}

// MARK: - EmojiSelectorViewDelegate

extension TrackDetailsViewController: EmojiSelectorViewDelegate {
    
    func didSelectEmoji(_ emoji: String) {
        chosenEmoji = emoji
        isCreateButtonEnabled()
    }
}

// MARK: - ColorSelectorViewDelegate

extension TrackDetailsViewController: ColorSelectorViewDelegate {
    
    func didSelectColor(_ color: UIColor) {
        chosenColor = color
        isCreateButtonEnabled()
    }
}
