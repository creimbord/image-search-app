//
//  PhotoDetailViewController.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

protocol PhotoDetailDisplayLogic: AnyObject {
    func displayPopulatedPhoto(_ viewModel: PhotoDetailModel.PopulatePhoto.ViewModel)
    func displayFetchedPhoto(_ viewModel: PhotoDetailModel.FetchPhoto.ViewModel)
}

final class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    var interactor: (PhotoDetailBusinessLogic & PhotoDetailDataStore)?
    
    // MARK: - Views
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.populatePhoto(.init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleNavigationBarApperance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

// MARK: - PhotoDetailDisplayLogic
extension PhotoDetailViewController: PhotoDetailDisplayLogic {
    func displayPopulatedPhoto(_ viewModel: PhotoDetailModel.PopulatePhoto.ViewModel) {
        title = viewModel.title
        interactor?.fetchPhoto(.init(
            id: viewModel.id,
            server: viewModel.server,
            secret: viewModel.secret
        ))
    }
    
    func displayFetchedPhoto(_ viewModel: PhotoDetailModel.FetchPhoto.ViewModel) {
        photoImageView.image = viewModel.photo
    }
}

// MARK: - Setup views
private extension PhotoDetailViewController {
    func setupViews() {
        addSubviews()
        view.backgroundColor = .black
    }
    
    func addSubviews() {
        view.addSubview(photoImageView)
    }
    
    func setupFrames() {
        photoImageView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    func toggleNavigationBarApperance() {
        navigationController?.navigationBar.isTranslucent.toggle()
        navigationController?.navigationBar.prefersLargeTitles.toggle()
    }
}
