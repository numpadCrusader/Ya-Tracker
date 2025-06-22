//
//  TrackerCell.swift
//  Tracker
//
//  Created by Nikita Khon on 11.06.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapActionButton(_ cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Visual Components
    
    private(set) lazy var trackerCardView: UIView = {
        let borderColor: UIColor = .trackerCellGray
        
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .trackerCellWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var streakLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.trackerCellPlusIcon, for: .normal)
        button.imageView?.contentMode = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "TrackerCell"
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func update(with viewModel: Tracker, and streakCount: Int) {
        trackerCardView.backgroundColor = viewModel.color
        emojiLabel.text = viewModel.emoji
        titleLabel.text = viewModel.title
        streakLabel.text = makeStreakLabelText(from: streakCount)
        actionButton.tintColor = viewModel.color
    }
    
    func setIsDone(_ isDone: Bool) {
        let buttonImage: UIImage = isDone ? .trackerCellDoneIcon : .trackerCellPlusIcon
        actionButton.setImage(buttonImage, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        delegate?.didTapActionButton(self)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(trackerCardView, streakLabel, actionButton)
        trackerCardView.addSubviews(emojiView, titleLabel)
        emojiView.addSubview(emojiLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackerCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            emojiView.topAnchor.constraint(equalTo: trackerCardView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerCardView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: trackerCardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trackerCardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            streakLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            streakLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),
            streakLabel.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func makeStreakLabelText(from number: Int) -> String {
        let suffix =
        switch number % 100 {
            case 11...14: "дней"
                
            default: switch number % 10 {
                case 1: "день"
                case 2...4: "дня"
                default: "дней"
            }
        }
        
        return "\(number) \(suffix)"
    }
}
