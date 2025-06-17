//
//  EmojiSelectorView.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

protocol EmojiSelectorViewDelegate: AnyObject {
    func didSelectEmoji(_ emoji: String)
}

final class EmojiSelectorView: UIView {
    
    // MARK: - Visual Components
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIView.noIntrinsicMetric, height: 18)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        
        collectionView.register(
            CategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: EmojiSelectorViewDelegate?
    
    // MARK: - Private Properties
    
    private let emojiList: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
        emojiCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emojiCollectionView.layoutIfNeeded()
        let newHeight = emojiCollectionView.collectionViewLayout.collectionViewContentSize.height
        
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
        addSubview(emojiCollectionView)
    }
    
    private func addConstraints() {
        collectionViewHeightConstraint = emojiCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: topAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
                for: indexPath) as? CategoryHeaderView
        else {
            return UICollectionReusableView()
        }
        
        header.update(with: "Emoji")
        return header
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
        let inset = collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.bounds.width - inset
        let side = floor(availableWidth / itemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard 
            indexPath.row < emojiList.count,
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
        else {
            return
        }
        
        cell.setIsSelected(true)
        delegate?.didSelectEmoji(emojiList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard
            indexPath.row < emojiList.count,
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
        else {
            return
        }
        
        cell.setIsSelected(false)
    }
}
