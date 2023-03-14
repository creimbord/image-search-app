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
    func reloadPhotos(_ request: SearchModel.ReloadPhotos.Request)
}

protocol SearchDataStore {
    var selectedPhoto: Photo? { get set }
    var dataSource: SearchDataSource? { get }
}

final class SearchInteractor: SearchDataStore {
    
    // MARK: - Properties
    var presenter: SearchPresentationLogic?
    var networkService: NetworkServiceProtocol?
    var decodingService: DecodingServiceProtocol?

    // MARK: - SearchDataStore
    var selectedPhoto: Photo?
    var dataSource: SearchDataSource?
    
    // MARK: - Pagination
    private var isLastPage = false
    private var isPaginating = false
    private var searchQuery = ""
    private var currentPage = 1
    private var totalPagesCount = 1
    private var oldPhotosCount = 0
    private var photosPerPage = 0
    
}

// MARK: - SearchBusinessLogic
extension SearchInteractor: SearchBusinessLogic {
    func fetchPhotos(_ request: SearchModel.FetchPhotos.Request) {
        resetPaginationIfNeeded(for: request.query)
        
        guard isPaginationEnabled else { return }
        isPaginating = true
        photosPerPage = request.photosPerPage
        
        let search = FlickrRoute.search(
            query: request.query,
            page: currentPage,
            perpage: photosPerPage
        )
        
        networkService?.fetch(route: search) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data else { self?.stopPagination(); return }
                
                let decodingResult = self?.decodingService?.decodeJSON(
                    PhotoSearchResult.self,
                    data: data
                )
                
                switch decodingResult {
                case .success(let searchResult):
                    do {
                        try self?.updatePhotos(searchResult.photos)
                        DispatchQueue.main.async {
                            self?.incrementPage()
                            self?.stopPagination()
                            self?.presenter?.presentFetchedPhotos(.init(
                                oldPhotosCount: self?.oldPhotosCount ?? 0,
                                newPhotosCount: self?.dataSource?.photos.count ?? 0
                            ))
                        }
                    } catch {
                        self?.stopPagination(with: error)
                    }
                case .failure(let error):
                    self?.stopPagination(with: error)
                case .none:
                    self?.stopPagination()
                    break
                }
            case .failure(let error):
                self?.stopPagination(with: error)
            }
        }
    }
    
    func selectPhoto(_ request: SearchModel.SelectPhoto.Request) {
        selectedPhoto = dataSource?.photos[request.index]
        presenter?.presentSelectedPhoto(.init())
    }
    
    func reloadPhotos(_ request: SearchModel.ReloadPhotos.Request) {
        presenter?.presentReloadedPhotos(.init())
    }
}

// MARK: - Methods
private extension SearchInteractor {
    func resetPaginationIfNeeded(for query: String) {
        guard searchQuery != query else { return }
        searchQuery = query
        isLastPage = false
        currentPage = 1
        totalPagesCount = 1
        dataSource?.photos = []
        reloadPhotos(.init())
    }
    
    func updatePhotos(_ photos: PagedPhotoSearchResult?) throws {
        guard let photos = photos else { throw DataError.photosDataIsMissing }
        setTotalPagesCount(photos.total)
        oldPhotosCount = dataSource?.photos.count ?? 0
        dataSource?.photos.append(contentsOf: photos.photo)
    }
    
    func setTotalPagesCount(_ totalPhotosCount: Int) {
        if totalPagesCount == 1 && totalPhotosCount > photosPerPage {
            totalPagesCount = totalPhotosCount / photosPerPage
        }
    }
    
    func incrementPage() {
        if (currentPage + 1) <= totalPagesCount {
            currentPage += 1
        } else {
            isLastPage = true
        }
    }
    
    func stopPagination(with error: Error? = nil) {
        isPaginating = false
        error.map { debugPrint($0.localizedDescription) }
    }
}

// MARK: - Computed properties
private extension SearchInteractor {
    var isPaginationEnabled: Bool {
        let searchQueryIsNotEmpty = !searchQuery.isEmpty
        let pagesCountIsNotExceeded = currentPage <= totalPagesCount
        return !isPaginating && !isLastPage && searchQueryIsNotEmpty && pagesCountIsNotExceeded
    }
}
