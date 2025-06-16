//
//  EmojiSelectorView.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

final class EmojiSelectorView: UIView {
    
    // MARK: - Visual Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = "Emoji"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: AutoHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = AutoHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let emojiList: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension EmojiSelectorView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        emojiList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCell.identifier,
            for: indexPath) as? EmojiCell
        else {
            return UICollectionViewCell()
        }
        
        cell.update(with: emojiList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EmojiSelectorView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let availableWidth = collectionView.bounds.width
        let side = floor(availableWidth / itemsPerRow)
        return CGSize(width: side, height: side)
    }
}
