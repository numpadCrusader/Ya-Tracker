//
//  EmojiCell.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Visual Components
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "EmojiCell"
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    func update(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    func setIsSelected(_ isSelected: Bool) {
        contentView.backgroundColor = isSelected ? .ypLightGray : .clear
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.layer.cornerRadius = 16
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(emojiLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
