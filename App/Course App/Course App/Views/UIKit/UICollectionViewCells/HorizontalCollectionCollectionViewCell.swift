//
//  HorizontalCollectionCollectionViewCell.swift
//  Course App
//
//  Created by Christián on 14/05/2024.
//

import UIKit
import SwiftUI

final class HorizontalCollectionCollectionViewCell: UICollectionViewCell {
    private let padding: CGFloat = 5
    // MARK: UI items
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
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
    private var didTapCallback: Action<Joke>?
    
}

// MARK: - Public methods
extension HorizontalCollectionCollectionViewCell {
    
    func configure(_ data: [Joke], callback: Action<Joke>? = nil) {
        self.data = data
        collectionView.reloadData()
        self.didTapCallback = callback
    }
    
    func setData(_ data: [Joke]) {
        self.data = data
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalCollectionCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCallback?(data[indexPath.row])
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
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
            
//            Image(uiImage: data[indexPath.row].image ?? UIImage())
//                .resizableBordered(cornerRadius: 10)
//                .scaledToFit()
            if let url = try?
                           ImagesRouter.size300x200.asURLRequest().url {
                           AsyncImage(url: url) { image in
                               image.resizableBordered(cornerRadius: 3)
                                   .scaledToFit()
                           } placeholder: {
                               Color.gray
                           }
                       } else {
                           Text("ERROR MESSAGE")
                       }
        
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension UICollectionViewCell: ReusableIdentifier {}
