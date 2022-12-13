//
//  PhotoInteractor.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import Foundation

protocol PhotoBusinessLogic: AnyObject {
    func fetchThumbnail(_ request: PhotoModel.FetchThumbnail.Request)
}

final class PhotoInteractor {
    
    // MARK: - Properties
    var requestURL: URL?
    var presenter: PhotoPresentationLogic?
    var networkService: NetworkServiceProtocol?
}

// MARK: - PhotoBusinessLogic
extension PhotoInteractor: PhotoBusinessLogic {
    func fetchThumbnail(_ request: PhotoModel.FetchThumbnail.Request) {
        let image = FlickrRoute.photo(
            id: request.id,
            server: request.server,
            secret: request.secret,
            size: .thumbnail
        )
        requestURL = image.requestURL
        
        networkService?.fetch(route: image) { [weak self] result in
            switch result {
            case .success(let thumbnailData):
                DispatchQueue.main.async {
                    if image.requestURL == self?.requestURL {
                        self?.presenter?.presentFetchedThumbnail(
                            .init(thumbnailData: thumbnailData)
                        )
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
