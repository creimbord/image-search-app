//
//  SearchPresenter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

protocol SearchPresentationLogic: AnyObject {
    func presentFetchedPhotos(_ response: SearchModel.FetchPhotos.Response)
    func presentSelectedPhoto(_ response: SearchModel.SelectPhoto.Response)
}

final class SearchPresenter: SearchPresentationLogic {
    
    // MARK: - Properties
    weak var viewController: SearchDisplayLogic?
    
    // MARK: - SearchPresentationLogic
    func presentFetchedPhotos(_ response: SearchModel.FetchPhotos.Response) {
        guard let photos = response.photos else { return }
        viewController?.displayFetchedPhotos(.init(photos: photos))
    }
    
    func presentSelectedPhoto(_ response: SearchModel.SelectPhoto.Response) {
        viewController?.displaySelectedPhoto(.init())
    }
}
