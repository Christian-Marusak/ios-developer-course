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

enum HomeViewEvent {
    case itemTapped(Joke)
}

final class HomeViewController: UIViewController {
    let logger = Logger()
    // swiftlint:disable:next prohibited_interface_builder
    @IBOutlet private var categoriesCollectionView: UICollectionView!
    
    // MARK: Data Source
    private var dataProvider: RealDataProvider = RealDataProvider()
    
    typealias DataSource = UICollectionViewDiffableDataSource<
        SectionData,
        [Joke]
    >
    typealias Snapshot = NSDiffableDataSourceSnapshot<
        SectionData,
        [Joke]
    >
    enum MagicNumbers: CGFloat {
        case number10 = 10
        case number5 = 5
        case number8 = 8
        case number3 = 3
        case number4 = 4
        case number30 = 30
    }
    private lazy var dataSource = makeDataSource()
    private lazy var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<HomeViewEvent, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        title = "Categories"
        dataProvider.fetchData()
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
    -> CGSize { CGSize(width: collectionView.bounds.width - MagicNumbers.number8.rawValue, height: collectionView.bounds.height / MagicNumbers.number3.rawValue) }
}

// MARK: - UICollectionViewDiffableDataSource
private extension HomeViewController {
    func readData() {
        dataProvider.$data.sink { [weak self] data in
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
//        guard dataSource.snapshot().numberOfSections == .zero else {
//            let snapshot = dataSource.snapshot()
//            dataSource.apply(
//                snapshot,
//                animatingDifferences: animatingDifferences
//            )
//            return
//        }
        
        
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
        let dataSource = DataSource(collectionView: categoriesCollectionView) {
            collectionView,
            indexPath,
            _ in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let collectionCell: HorizontalCollectionCollectionViewCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            collectionCell.configure(section.jokes,
                                     callback: { [weak self] joke in
                self?.eventSubject.send(.itemTapped(joke))
            },
                                     didLike: { [weak self] joke in
                self?.dataProvider.storeLike(joke: joke)
            })
            return collectionCell
        }
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let labelCell = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            labelCell.contentConfiguration = UIHostingConfiguration {
                HeaderView(title: section.title)
            }
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
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(UICollectionViewCell.self)
        categoriesCollectionView.register(
            HorizontalCollectionCollectionViewCell.self
        )
        categoriesCollectionView.register(
//            LabelCollectionViewCell.self,
    UICollectionViewCell.self,
    forSuplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = MagicNumbers.number8.rawValue
        layout.minimumInteritemSpacing = MagicNumbers.number10.rawValue
        layout.sectionInset = UIEdgeInsets(
            top: .zero,
            left: MagicNumbers.number4.rawValue,
            bottom: .zero,
            right: MagicNumbers.number4.rawValue
        )
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(
            width: categoriesCollectionView.contentSize.width,
            height: MagicNumbers.number30.rawValue
        )
        categoriesCollectionView.setCollectionViewLayout(
            layout,
            animated: false
        )
    }
}

// MARK: - EventEmitting
extension HomeViewController: EventEmitting {
    var eventPublisher: AnyPublisher<HomeViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
