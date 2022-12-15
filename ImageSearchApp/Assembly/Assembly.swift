//
//  Assembly.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

enum Assembly {
    static func createSearchScene() -> UINavigationController {
        let router = SearchRouter()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let viewController = SearchViewController()
        let networkService = NetworkService()
        let decodingService = DecodingService()
        let dataSource = SearchDataSource()
        
        router.dataStore = interactor
        router.viewController = viewController
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        interactor.networkService = networkService
        interactor.decodingService = decodingService
        viewController.router = router
        viewController.interactor = interactor
        
        return UINavigationController(rootViewController: viewController)
    }
    
    static func createPhotoDetailScene() -> PhotoDetailViewController {
        let presenter = PhotoDetailPresenter()
        let interactor = PhotoDetailInteractor()
        let viewController = PhotoDetailViewController()
        let networkService = NetworkService()
        
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.networkService = networkService
        viewController.interactor = interactor
        
        return viewController
    }
    
    static func createRecentQueriesScene() -> RecentQueriesViewController {
        let presenter = RecentQueriesPresenter()
        let interactor = RecentQueriesInteractor()
        let viewController = RecentQueriesViewController()
        let dataSource = RecentQueriesDataSource()
        
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.dataSource = dataSource
        viewController.interactor = interactor
        
        return viewController
    }
    
    static func preparePhotoScene(for cell: PhotoCell) {
        let presenter = PhotoPresenter()
        let interactor = PhotoInteractor()
        let networkService = NetworkService()
        
        presenter.cell = cell
        interactor.presenter = presenter
        interactor.networkService = networkService
        cell.interactor = interactor
    }
}
