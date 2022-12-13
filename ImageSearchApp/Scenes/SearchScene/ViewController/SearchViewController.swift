//
//  SearchViewController.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayFetchedPhotos(_ viewModel: SearchModel.FetchPhotos.ViewModel)
}

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var interactor: SearchBusinessLogic?
    private var photos: [Photo] = []
    private var searchQuery = ""
    
    // MARK: - Constants
    private enum Constants {
        static let title = "Photos"
        static let placeholderText = "No photos"
        static let screenWidth = UIScreen.main.bounds.width
        static let spaceOffsets: CGFloat = 20
        static let sideOffsets: CGFloat = 32
        static let numberOfItemsInSection: CGFloat = 3
        static let sectionInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: - Views
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()

    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

// MARK: - SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
    func displayFetchedPhotos(_ viewModel: SearchModel.FetchPhotos.ViewModel) {
        photos = viewModel.photos
        photosCollectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text.map { searchQuery = $0 }
        let rows = round(layoutFrame.height / thumbnailSize)
        
        interactor?.fetchPhotos(.init(
            query: searchQuery,
            page: 1,
            photosPerPage: Int(rows * Constants.numberOfItemsInSection)
        ))
        searchController.isActive = false
        searchController.searchBar.text = searchQuery
    }
}

// MARK: - Computed properties
private extension SearchViewController {
    var layoutFrame: CGRect {
        view.safeAreaLayoutGuide.layoutFrame
    }
    
    var thumbnailSize: CGFloat {
        let offsets = Constants.spaceOffsets + Constants.sideOffsets
        return (Constants.screenWidth - offsets) / Constants.numberOfItemsInSection
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
        photosCollectionView.frame = layoutFrame
        placeholderView.frame = layoutFrame
    }
}
