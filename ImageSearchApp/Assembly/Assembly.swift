//
//  Assembly.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

enum Assembly {
    static func createSearchScene() -> UINavigationController {
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let viewController = SearchViewController()
        let networkService = NetworkService()
        let decodingService = DecodingService()
        
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.networkService = networkService
        interactor.decodingService = decodingService
        viewController.interactor = interactor
        
        return UINavigationController(rootViewController: viewController)
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
