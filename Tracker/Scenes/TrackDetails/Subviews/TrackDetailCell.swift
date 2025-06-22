//
//  TrackDetailCell.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

final class TrackDetailCell: UITableViewCell {
    
    // MARK: - Visual Components
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var detailTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRightIcon
        imageView.contentMode = .center
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var botSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "TrackDetailCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func update(with detail: TrackerDetailsMode.DetailField, isLast: Bool) {
        detailTitleLabel.text = detail.title
        
        botSeparatorView.isHidden = isLast ? true : false
    }
    
    func setDetailSubtitle(_ subtitle: String) {
        detailSubtitleLabel.text = subtitle
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.backgroundColor = .ypBackgroundDay
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        labelsStackView.addArrangedSubviews(detailTitleLabel, detailSubtitleLabel)
        contentView.addSubviews(labelsStackView, chevronImageView, botSeparatorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            botSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            botSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            botSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
