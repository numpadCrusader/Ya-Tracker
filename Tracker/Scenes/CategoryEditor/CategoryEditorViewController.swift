//
//  CategoryEditorViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 21.06.2025.
//

import UIKit

final class CategoryEditorViewController: UIViewController {
    
    // MARK: - Visual Components
    
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
            string: "Введите название категории",
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
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private Properties
    
    private let editorType: CategoryEditorType
    private let trackerCategoryStore: TrackerCategoryStoreProtocol
    
    // MARK: - Initializers
    
    init(
        editorType: CategoryEditorType,
        trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    ) {
        self.editorType = editorType
        self.trackerCategoryStore = trackerCategoryStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        isDoneButtonEnabled()
        isClearTextButtonVisible()
    }
    
    @objc private func clearText() {
        trackTitleTextField.text = ""
        isClearTextButtonVisible()
        isWarningLabelHidden(true)
    }
    
    @objc private func doneButtonTapped() {
        guard let title = trackTitleTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        trackerCategoryStore.addNewCategory(title: title)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = editorType.title
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews(headerStackView, doneButton)
        headerStackView.addArrangedSubviews(trackTitleTextField, warningLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackTitleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func isDoneButtonEnabled() {
        let hasTrackTitle = !(trackTitleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        
        doneButton.isEnabled = hasTrackTitle
        doneButton.backgroundColor = hasTrackTitle ? .ypBlack : .ypGray
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

// MARK: - UITextFieldDelegate

extension CategoryEditorViewController: UITextFieldDelegate {
    
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
