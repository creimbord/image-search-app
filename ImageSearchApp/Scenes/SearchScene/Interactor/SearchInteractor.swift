//
//  SearchInteractor.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

protocol SearchBusinessLogic: AnyObject {
    func fetchPhotos(_ request: SearchModel.FetchPhotos.Request)
    func selectPhoto(_ request: SearchModel.SelectPhoto.Request)
}

protocol SearchDataStore {
    var selectedPhoto: Photo? { get set }
}

final class SearchInteractor: SearchDataStore {
    
    // MARK: - Properties
    private var photos: [Photo]?
    var presenter: SearchPresentationLogic?
    var networkService: NetworkServiceProtocol?
    var decodingService: DecodingServiceProtocol?
    
    // MARK: - SearchDataStore
    var selectedPhoto: Photo?
    
}

// MARK: - SearchBusinessLogic
extension SearchInteractor: SearchBusinessLogic {
    func fetchPhotos(_ request: SearchModel.FetchPhotos.Request) {
        let search = FlickrRoute.search(
            query: request.query,
            page: request.page,
            perpage: request.photosPerPage
        )
        
        networkService?.fetch(route: search) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                
                let decodingResult = self?.decodingService?.decodeJSON(
                    PhotoSearchResult.self,
                    data: data
                )
                
                switch decodingResult {
                case .success(let searchResult):
                    let photos = searchResult.photos?.photo
                    self?.photos = photos
                    
                    DispatchQueue.main.async {
                        self?.presenter?.presentFetchedPhotos(.init(photos: photos))
                    }
                case .failure(let error):
                    debugPrint(error)
                case .none:
                    break
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func selectPhoto(_ request: SearchModel.SelectPhoto.Request) {
        selectedPhoto = photos?[request.index]
        presenter?.presentSelectedPhoto(.init())
    }
}
