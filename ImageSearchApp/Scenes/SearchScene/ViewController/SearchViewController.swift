//
//  SearchViewController.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let title = "Images"
        static let placeholderText = "No images"
        static let sectionInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    private let placeholderView = PlaceholderView(
        text: Constants.placeholderText,
        image: .empty,
        imageTintColor: .systemGray
    )
    private lazy var imagesCollectionView: UICollectionView = {
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

// MARK: - Computed properties
private extension SearchViewController {
    var layoutFrame: CGRect {
        view.safeAreaLayoutGuide.layoutFrame
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
        view.addSubview(imagesCollectionView)
        view.addSubview(placeholderView)
        navigationItem.searchController = searchController
    }
    
    func setupFrames() {
        imagesCollectionView.frame = layoutFrame
        placeholderView.frame = layoutFrame
    }
}
