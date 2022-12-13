//
//  PhotoPresenter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

protocol PhotoPresentationLogic: AnyObject {
    func presentFetchedThumbnail(_ response: PhotoModel.FetchThumbnail.Response)
}

final class PhotoPresenter: PhotoPresentationLogic {
    
    // MARK: - Properties
    weak var cell: PhotoDisplayLogic?
    
    // MARK: - PhotoPresentationLogic
    func presentFetchedThumbnail(_ response: PhotoModel.FetchThumbnail.Response) {
        guard let thumbnailData = response.thumbnailData else { return }
        guard let thumbnailImage = UIImage(data: thumbnailData) else { return }
        cell?.displayFetchedThumbnail(.init(thumbnailImage: thumbnailImage))
    }
}
