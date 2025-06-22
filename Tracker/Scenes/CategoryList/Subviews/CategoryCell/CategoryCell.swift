//
//  CategoryCell.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Visual Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.image = .checkmarkIcon
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
    
    static let identifier = "CategoryCell"
    
    var viewModel: CategoryCellViewModel? {
        didSet {
            viewModel?.categoryTitleBinding = { [weak self] title in
                self?.titleLabel.text = title
            }
            viewModel?.isSelectedBinding = { [weak self] isSelected in
                self?.checkmarkImageView.alpha = isSelected ? 1 : 0
            }
            viewModel?.maskedCornersBinding = { [weak self] maskedCorners in
                self?.contentView.layer.maskedCorners = maskedCorners
            }
            viewModel?.isSeparatorHiddenBinding = { [weak self] isHidden in
                self?.botSeparatorView.isHidden = isHidden
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.categoryTitleBinding = nil
        viewModel?.isSelectedBinding = nil
        viewModel?.maskedCornersBinding = nil
        viewModel?.isSeparatorHiddenBinding = nil
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.backgroundColor = .ypBackgroundDay
        contentView.layer.cornerRadius = 16
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(titleLabel, checkmarkImageView, botSeparatorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            botSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            botSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            botSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            botSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
