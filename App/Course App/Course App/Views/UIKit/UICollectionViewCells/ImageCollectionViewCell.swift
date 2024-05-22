//
//  ImageCollectionViewCell.swift
//  Course App
//
//  Created by Christián on 14/05/2024.
//


import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    enum MagicNumbers: CGFloat {
        case number10 = 10
        case number5 = 5
    }
    
    // MARK: UI items
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = MagicNumbers.number10.rawValue
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
                    constant: MagicNumbers.number5.rawValue
                ),
                imageView.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: MagicNumbers.number5.rawValue
                ),
                imageView.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: -MagicNumbers.number5.rawValue
                ),
                imageView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -MagicNumbers.number5.rawValue
                )
            ]
        )
    }
}
