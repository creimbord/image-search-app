//
//  PhotoDetailInteractor.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import Foundation

protocol PhotoDetailBusinessLogic: AnyObject {
    func populatePhoto(_ request: PhotoDetailModel.PopulatePhoto.Request)
    func fetchPhoto(_ request: PhotoDetailModel.FetchPhoto.Request)
}

protocol PhotoDetailDataStore {
    var photo: Photo? { get set }
}

final class PhotoDetailInteractor: PhotoDetailDataStore {
    
    // MARK: - Properties
    var presenter: PhotoDetailPresentationLogic?
    var networkService: NetworkServiceProtocol?
    
    // MARK: - PhotoDetailDataStore
    var photo: Photo?
    
}

// MARK: - PhotoDetailBusinessLogic
extension PhotoDetailInteractor: PhotoDetailBusinessLogic {
    func populatePhoto(_ request: PhotoDetailModel.PopulatePhoto.Request) {
        guard let photo = photo else { return }
        presenter?.presentPopulatedPhoto(.init(
            id: photo.id,
            title: photo.title,
            server: photo.server,
            secret: photo.secret
        ))
    }
    
    func fetchPhoto(_ request: PhotoDetailModel.FetchPhoto.Request) {
        let image = FlickrRoute.photo(
            id: request.id,
            server: request.server,
            secret: request.secret,
            size: .large
        )
        
        networkService?.fetch(route: image) { [weak presenter] result in
            switch result {
            case .success(let photoData):
                DispatchQueue.main.async {
                    presenter?.presentFetchedPhoto(.init(photoData: photoData))
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
