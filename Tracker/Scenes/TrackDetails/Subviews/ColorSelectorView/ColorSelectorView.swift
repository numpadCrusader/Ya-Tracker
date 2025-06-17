//
//  ColorSelectorView.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

protocol ColorSelectorViewDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

final class ColorSelectorView: UIView {
    
    // MARK: - Visual Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = "Цвет"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: ColorSelectorViewDelegate?
    
    // MARK: - Private Properties
    
    private let colorList: [UIColor] = [
        .selection1, .selection2, .selection3, .selection4, .selection5, .selection6,
        .selection7, .selection8, .selection9, .selection10, .selection11, .selection12,
        .selection13, .selection14, .selection15, .selection16, .selection17, .selection18
    ]
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
        colorCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorCollectionView.layoutIfNeeded()
        let newHeight = colorCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        if collectionViewHeightConstraint?.constant != newHeight {
            collectionViewHeightConstraint?.constant = newHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(colorCollectionView)
    }
    
    private func addConstraints() {
        collectionViewHeightConstraint = colorCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: topAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension ColorSelectorView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        colorList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCell.identifier,
            for: indexPath) as? ColorCell
        else {
            return UICollectionViewCell()
        }
        
        cell.update(with: colorList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ColorSelectorView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let inset = collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.bounds.width - inset
        let side = floor(availableWidth / itemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            indexPath.row < colorList.count,
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
        else {
            return
        }
        
        cell.setIsSelected(true)
        delegate?.didSelectColor(colorList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard
            indexPath.row < colorList.count,
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
        else {
            return
        }
        
        cell.setIsSelected(false)
    }
}
