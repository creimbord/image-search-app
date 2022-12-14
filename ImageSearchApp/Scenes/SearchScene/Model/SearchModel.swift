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
            let page: Int
            let photosPerPage: Int
        }
        
        struct Response {
            let photos: [Photo]?
        }
        
        struct ViewModel {
            let photos: [Photo]
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
}
