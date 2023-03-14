//
//  SearchViewController.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayFetchedPhotos(_ viewModel: SearchModel.FetchPhotos.ViewModel)
    func displaySelectedPhoto(_ viewModel: SearchModel.SelectPhoto.ViewModel)
    func displayReloadedPhotos(_ viewModel: SearchModel.ReloadPhotos.ViewModel)
}

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var router: SearchRoutingLogic?
    var interactor: (SearchBusinessLogic & SearchDataStore)?
    private var searchQuery = ""
    
    // MARK: - Constants
    private enum Constants {
        static let title = "Photos"
        static let placeholderText = "No photos"
        static let screenWidth = UIScreen.main.bounds.width
        static let spaceOffsets: CGFloat = 20
        static let sideOffsets: CGFloat = 32
        static let numberOfItemsInSection = 3
        static let titleHeight: CGFloat = 51
        static let sectionInset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    // MARK: - Views
    private let recentQueriesScene = Assembly.createRecentQueriesScene()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: recentQueriesScene)
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        searchController.showsSearchResultsController = true
        return searchController
    }()
    private let placeholderView = PlaceholderView(
        text: Constants.placeholderText,
        image: .empty,
        imageTintColor: .systemGray
    )
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = Constants.sectionInset
        layout.footerReferenceSize = CGSize(width: Constants.screenWidth, height: 50)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = interactor?.dataSource
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: String(describing: PhotoCell.self)
        )
        collectionView.register(
            LoadingFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: String(describing: LoadingFooter.self)
        )
        
        return collectionView
    }()

    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

// MARK: - SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
    func displayFetchedPhotos(_ viewModel: SearchModel.FetchPhotos.ViewModel) {
        UIView.performWithoutAnimation {
            photosCollectionView.performBatchUpdates({
                photosCollectionView.insertItems(at: viewModel.insertIndexPaths)
            }, completion: nil)
        }
    }
    
    func displaySelectedPhoto(_ viewModel: SearchModel.SelectPhoto.ViewModel) {
        router?.routeToPhotoDetail()
    }
    
    func displayReloadedPhotos(_ viewModel: SearchModel.ReloadPhotos.ViewModel) {
        photosCollectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text.map { searchQuery = $0 }
        fetchPhotos(for: searchQuery)
        placeholderView.isHidden = true
        searchController.isActive = false
        searchController.searchBar.text = searchQuery
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.selectPhoto(.init(index: indexPath.item))
    }
}

// MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = photosCollectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight * 2) {
            fetchPhotos(for: searchQuery)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: thumbnailWidth, height: thumbnailWidth + Constants.titleHeight)
    }
}

// MARK: - Methods
private extension SearchViewController {
    func fetchPhotos(for query: String) {
        interactor?.fetchPhotos(.init(
            query: query,
            photosPerPage: numberOfSections * Constants.numberOfItemsInSection
        ))
    }
}

// MARK: - Computed properties
private extension SearchViewController {
    var layoutFrame: CGRect {
        view.safeAreaLayoutGuide.layoutFrame
    }
    
    var numberOfSections: Int {
        Int(round(layoutFrame.height / thumbnailWidth))
    }
    
    var thumbnailWidth: CGFloat {
        let offsets = Constants.spaceOffsets + Constants.sideOffsets
        let width = (Constants.screenWidth - offsets) / CGFloat(Constants.numberOfItemsInSection)
        return floor(width)
    }
}

// MARK: - Setup views
private extension SearchViewController {
    func setupViews() {
        addSubviews()
        title = Constants.title
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addSubviews() {
        view.addSubview(photosCollectionView)
        view.addSubview(placeholderView)
        navigationItem.searchController = searchController
    }
    
    func setupFrames() {
        photosCollectionView.frame = view.frame
        photosCollectionView.frame.size.height -= view.safeAreaInsets.bottom
        placeholderView.frame = layoutFrame
    }
}
