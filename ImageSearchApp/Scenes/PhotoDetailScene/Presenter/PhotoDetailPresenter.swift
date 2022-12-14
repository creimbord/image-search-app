//
//  PhotoDetailPresenter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

protocol PhotoDetailPresentationLogic: AnyObject {
    func presentPopulatedPhoto(_ response: PhotoDetailModel.PopulatePhoto.Response)
    func presentFetchedPhoto(_ response: PhotoDetailModel.FetchPhoto.Response)
}

final class PhotoDetailPresenter: PhotoDetailPresentationLogic {
    
    // MARK: - Properties
    weak var viewController: PhotoDetailDisplayLogic?
    
    // MARK: - PhotoDetailPresentationLogic
    func presentPopulatedPhoto(_ response: PhotoDetailModel.PopulatePhoto.Response) {
        viewController?.displayPopulatedPhoto(.init(
            id: response.id,
            title: response.title,
            server: response.server,
            secret: response.secret
        ))
    }
    
    func presentFetchedPhoto(_ response: PhotoDetailModel.FetchPhoto.Response) {
        guard let photoData = response.photoData else { return }
        guard let photo = UIImage(data: photoData) else { return }
        viewController?.displayFetchedPhoto(.init(photo: photo))
    }
}
