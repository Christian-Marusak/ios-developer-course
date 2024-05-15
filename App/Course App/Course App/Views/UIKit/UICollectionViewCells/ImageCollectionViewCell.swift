//
//  ImageCollectionViewCell.swift
//  Course App
//
//  Created by Christián on 14/05/2024.
//


import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    let padding: CGFloat = 5
    
    // MARK: UI items
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Lifecycle
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        
        setupUI()
    }
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
}

// MARK: - Setup UI
private extension ImageCollectionViewCell {
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(
            imageView
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                imageView.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: padding
                ),
                imageView.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: padding
                ),
                imageView.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: -padding
                ),
                imageView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -padding
                )
            ]
        )
    }
}
