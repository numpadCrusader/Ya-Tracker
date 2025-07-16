//
//  StatsCell.swift
//  Tracker
//
//  Created by Nikita Khon on 16.07.2025.
//

import UIKit

final class StatsCell: UITableViewCell {
    
    // MARK: - Visual Components
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "StatsCell"
    
    // MARK: - Private Properties
    
    private let gradientBorder = CAGradientLayer()
    private let maskLayer = CAShapeLayer()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewCell
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientBorder()
    }
    
    // MARK: - Public Methods
    
    func update(with stat: StatsType, count: String) {
        counterLabel.text = count
        descriptionLabel.text = stat.title
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(counterLabel, descriptionLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func addGradientBorder() {
        gradientBorder.removeFromSuperlayer()
        
        gradientBorder.frame = bounds
        gradientBorder.colors = [
            UIColor.selection3.cgColor,
            UIColor.selection9.cgColor,
            UIColor.selection1.cgColor,
        ]
        gradientBorder.startPoint = CGPoint(x: 1, y: 0.5)
        gradientBorder.endPoint = CGPoint(x: 0, y: 0.5)
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: 16)
        let borderMask = CAShapeLayer()
        borderMask.path = path.cgPath
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = UIColor.black.cgColor
        borderMask.lineWidth = 1.0
        gradientBorder.mask = borderMask
        
        layer.addSublayer(gradientBorder)
    }
}
