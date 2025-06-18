//
//  ColorCell.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Visual Components
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .ypWhite
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public Properties
    
    static let identifier = "ColorCell"
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func update(with color: UIColor) {
        colorView.backgroundColor = color
        borderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    func setIsSelected(_ isSelected: Bool) {
        borderView.alpha = isSelected ? 1 : 0
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews(borderView, colorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: -6),
            borderView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -6),
            borderView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 6),
            borderView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 6),
        ])
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
