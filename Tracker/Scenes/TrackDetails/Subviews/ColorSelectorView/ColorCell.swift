//
//  ColorCell.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Visual Components
    
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
    }
    
    func setIsSelected(_ isSelected: Bool, with color: UIColor) {
        let borderColor: UIColor = isSelected ? color.withAlphaComponent(0.3) : color
        contentView.layer.borderColor = borderColor.cgColor
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        let initialBorderColor: UIColor = .ypWhite
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = initialBorderColor.cgColor
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(colorView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
