//
//  SearchRouter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import Foundation

protocol SearchRoutingLogic {
    func routeToPhotoDetail()
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

final class SearchRouter: SearchRoutingLogic, SearchDataPassing {
    
    // MARK: - Properties
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
    // MARK: - SearchRoutingLogic
    func routeToPhotoDetail() {
        let photoDetailViewController = Assembly.createPhotoDetailScene()
        if var photoDetailDataStore = photoDetailViewController.interactor {
            passDataToPhotoDetail(destination: &photoDetailDataStore)
            navigateToPhotoDetail(destination: photoDetailViewController)
        }
    }
    
    // MARK: - Navigation
    private func navigateToPhotoDetail(destination: PhotoDetailViewController) {
        viewController?.navigationController?.pushViewController(
            destination,
            animated: true
        )
    }
    
    // MARK: - Passing data
    private func passDataToPhotoDetail(
        destination: inout PhotoDetailBusinessLogic & PhotoDetailDataStore
    ) {
        destination.photo = dataStore?.selectedPhoto
    }
}
