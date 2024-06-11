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
    
    struct SectionData: Identifiable, Hashable {
        let id = UUID()
        let title: String
        var jokes: [Joke]

        init(title: String, jokes: [JokeResponse], likes: [String: Bool]) {
            self.title = title
            self.jokes = jokes.map { Joke(jokeResponse: $0, liked: likes[$0.id] ?? false) }
        }
    }
    
    let logger = Logger()
    @IBOutlet private var categoriesCollectionView: UICollectionView!
    
    // MARK: Private Variables
    
    private let jokeService: JokesServicing = JokeService(apiManager: APIManager())
    @Published private var data: [SectionData] = []
    private let store: StoreManaging = FirebaseStoreManager()
    private lazy var dataSource = makeDataSource()
    private lazy var cancellables = Set<AnyCancellable>()
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData,[Joke]>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData,[Joke]>
    enum MagicNumbers: CGFloat {
        case number10 = 10
        case number5 = 5
        case number8 = 8
        case number3 = 3
        case number4 = 4
        case number30 = 30
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        title = "Categories"
        readData()
        fetchData()
        
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
        $data.sink { [weak self] data in
            self?.applySnapshotData(data: data, animatingDifferences: true)
        }
        .store(in: &cancellables)
    }
    
    func applySnapshotData(
        data: [SectionData],
        animatingDifferences: Bool = true
    ) {
        guard dataSource.snapshot().numberOfSections == .zero else {
            let snapshot = dataSource.snapshot()
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
            collectionCell.setData(section.jokes)
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
        categoriesCollectionView.isPagingEnabled = true
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

//MARK: Data Fetching
extension HomeViewController {
    @MainActor
    func storeLike(joke: Joke) {
        Task {
            try await store.storeLike(jokeId: joke.id, liked: !joke.liked)
        }
    }
    @MainActor
    func fetchData() {
        Task {
            let categories = try await jokeService.fetchCategories()

            try await withThrowingTaskGroup(of: JokeResponse.self) { [weak self] group in
                guard let self else {
                    return
                }

                categories.forEach { category in
                    for _ in 1...5 {
                        group.addTask {
                            try await self.jokeService.fetchJokeForCategory(category)
                        }
                    }
                }

                var jokesResponses: [JokeResponse] = []
                var likes: [String: Bool] = [:]
                for try await jokeResponse in group {
                    jokesResponses.append(jokeResponse)
                    let liked = try? await store.fetchLiked(jokeId: jokeResponse.id)
                    likes[jokeResponse.id] = liked ?? false
                }

                let dataDictionary = Dictionary(grouping: jokesResponses) { $0.categories.first ?? "" }
                var sectionData = [SectionData]()
                for key in dataDictionary.keys {
                    sectionData.append(SectionData(title: key, jokes: dataDictionary[key] ?? [], likes: likes))
                }
                data = sectionData
            }
        }
    }
}
