//
//  LabelCollectionViewCell.swift
//  Course App
//
//  Created by Christián on 14/05/2024.
//

import UIKit

final class LabelCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    lazy var nameLabel = UILabel()
    let padding: CGFloat = 5
    
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
            "Init(coder:) has not been implemented"
        )
    }
}


private extension LabelCollectionViewCell {
    func setupUI() {
        addSubviews()
        configureLabel()
        setupConstrains()
    }
    
    func addSubviews() {
        addSubview(
            nameLabel
        )
    }
    
    func configureLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
    }
    
    func setupConstrains() {
        NSLayoutConstraint.activate(
            [
                nameLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: padding
                ),
                nameLabel.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: padding
                ),
                nameLabel.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: -padding
                ),
                nameLabel.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -padding
                )
            ]
        )
    }
}
