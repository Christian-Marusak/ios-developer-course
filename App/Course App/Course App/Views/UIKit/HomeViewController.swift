//
//  HomeViewController.swift
//  Course App
//
//  Created by Christián on 13/05/2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    let logger = Logger()
    // swiftlint:disable:next prohibited_interface_builder
    @IBOutlet private var categoriesCollectionView: UICollectionView!
    
    // MARK: Data Source
    private lazy var dataProvider = MockDataProvider()
    
    typealias DataSource = UICollectionViewDiffableDataSource<
        SectionData,
        [Joke]
    >
    typealias Snapshot = NSDiffableDataSourceSnapshot<
        SectionData,
        [Joke]
    >
    
    private lazy var dataSource = makeDataSource()
    private lazy var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        readData()
    }
}

// MARK: HELPER
struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(
        context: Context
    ) -> HomeViewController {
        HomeViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: HomeViewController,
        context: Context
    ) {
    }
}

// MARK: - UICollectionViewFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath )
    -> CGSize { return CGSize(width: collectionView.bounds.width - 8, height: collectionView.bounds.height / 3) }
}

// MARK: - UICollectionViewDiffableDataSource
private extension HomeViewController {
    func readData() {
        dataProvider.$data.sink {[weak self] data in
            debugPrint(
                data
            )
            self?.applySnapshotData(
                data: data,
                animatingDifferences: true
            )
        }
        .store(
            in: &cancellables
        )
    }
    
    func applySnapshotData(
        data: [SectionData],
        animatingDifferences: Bool = true
    ) {
        guard dataSource.snapshot().numberOfSections == 0 else {
            let snapshot = dataSource.snapshot()
            //            snapshot.moveItem((data.first?.jokes.first)!, afterItem: (data.first?.jokes.last)!)
            dataSource.apply(
                snapshot,
                animatingDifferences: animatingDifferences
            )
            return
        }
        
        
        var snapshot = Snapshot()
        snapshot.appendSections(
            data
        )
        data.forEach { section in
            snapshot.appendItems(
                [section.jokes],
                toSection: section
            )
        }
        
        dataSource.apply(
            snapshot,
            animatingDifferences: animatingDifferences
        )
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: categoriesCollectionView) { collectionView, indexPath, _ in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let collectionCell: HorizontalCollectionCollectionViewCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            collectionCell.images = section.jokes.map {
                $0.image
            }
            
            return collectionCell
        }
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let labelCell: LabelCollectionViewCell = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            labelCell.nameLabel.text = section.title
            return labelCell
        }
        
        return dataSource
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        debugPrint(
            "I have tapped \(indexPath)"
        )
    }
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        debugPrint(
            "Will display \(indexPath)"
        )
    }
}


// MARK: UI Setup

private extension HomeViewController {
    func setup() {
        setupCollectionView()
    }
    
    
    func setupCollectionView() {
        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.isPagingEnabled = true
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(
            HorizontalCollectionCollectionViewCell.self
        )
        categoriesCollectionView.register(
            LabelCollectionViewCell.self,
            forSuplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 4,
            bottom: 0,
            right: 4
        )
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(
            width: categoriesCollectionView.contentSize.width,
            height: 30
        )
        categoriesCollectionView.setCollectionViewLayout(
            layout,
            animated: false
        )
    }
}
