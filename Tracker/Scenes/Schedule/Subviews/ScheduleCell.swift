//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Nikita Khon on 14.06.2025.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didToggleSwitch(for cell: ScheduleCell, isOn: Bool)
}

final class ScheduleCell: UITableViewCell {
    
    // MARK: - Visual Components
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .ypBlue
        daySwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        daySwitch.setContentHuggingPriority(.required, for: .horizontal)
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return daySwitch
    }()
    
    private lazy var botSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "ScheduleCell"
    weak var delegate: ScheduleCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func update(with day: WeekDay, isOn: Bool) {
        dayLabel.text = day.name
        daySwitch.isOn = isOn
        
        botSeparatorView.isHidden = day == .sunday ? true : false
        
        contentView.layer.maskedCorners = switch day {
            case .monday: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .sunday: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default: []
        }
    }
    
    // MARK: - Actions
    
    @objc private func switchToggled(_ sender: UISwitch) {
        delegate?.didToggleSwitch(for: self, isOn: sender.isOn)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.backgroundColor = .ypBackgroundDay
        contentView.layer.cornerRadius = 16
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(dayLabel, daySwitch, botSeparatorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.trailingAnchor.constraint(equalTo: daySwitch.leadingAnchor, constant: -16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            botSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            botSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            botSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
