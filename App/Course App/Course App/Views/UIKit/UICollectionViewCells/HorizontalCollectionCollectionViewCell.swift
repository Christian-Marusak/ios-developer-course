//
//  HorizontalCollectionCollectionViewCell.swift
//  Course App
//
//  Created by Christián on 14/05/2024.
//

import SwiftUI
import UIKit

final class HorizontalCollectionCollectionViewCell: UICollectionViewCell {
    enum MagicNumbers: CGFloat {
        case number5 = 5
        case number10 = 10
        
        func asCGFloat() -> CGFloat {
            CGFloat(self.rawValue)
        }
        func asInt() -> Int {
            Int(self.rawValue)
        }
    }
    // MARK: UI items
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.register(ImageCollectionViewCell.self)
    collectionView.register(UICollectionViewCell.self)
        return collectionView
    }()
    var data: [Joke] = []

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension HorizontalCollectionCollectionViewCell {
    func setData(_ data: [Joke]) {
        self.data = data
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalCollectionCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        logger.info("Horizontal scrolling did select item \(indexPath)")
    }
}

// MARK: - Setup UI
private extension HorizontalCollectionCollectionViewCell {
    func setupUI() {
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MagicNumbers.number5.rawValue),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: MagicNumbers.number5.rawValue),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -MagicNumbers.number5.rawValue),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -MagicNumbers.number5.rawValue)
        ])
    }
}


extension HorizontalCollectionCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.contentConfiguration = UIHostingConfiguration {
            Image(uiImage: data[indexPath.row].image ?? UIImage())
                .resizableBordered(cornerRadius: MagicNumbers.number10.rawValue)
                .scaledToFit()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension UICollectionViewCell: ReusableIdentifier {}
