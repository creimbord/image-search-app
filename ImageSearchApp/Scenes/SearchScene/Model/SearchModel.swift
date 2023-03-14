//
//  SearchModel.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

enum SearchModel {
    
    // Fetch photos by provided query
    enum FetchPhotos {
        struct Request {
            let query: String
            let photosPerPage: Int
        }
        
        struct Response {
            let oldPhotosCount: Int
            let newPhotosCount: Int
        }
        
        struct ViewModel {
            let insertIndexPaths: [IndexPath]
        }
    }
    
    // Select the concrete photo
    enum SelectPhoto {
        struct Request {
            let index: Int
        }
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    // Reload the photos collection view
    enum ReloadPhotos {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
}
