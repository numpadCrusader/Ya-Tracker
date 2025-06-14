//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Nikita Khon on 14.06.2025.
//

import UIKit

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
        return daySwitch
    }()
    
    private lazy var botSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "ScheduleCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func update(with day: WeekDay) {
        dayLabel.text = day.name
        
        botSeparator.isHidden = day == .sunday ? true : false
        
        contentView.layer.maskedCorners = switch day {
            case .monday: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .sunday: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default: []
        }
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.backgroundColor = .ypBackgroundDay
        contentView.layer.cornerRadius = 16
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(dayLabel, daySwitch, botSeparator)
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
            botSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            botSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            botSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
