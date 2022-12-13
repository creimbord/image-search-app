//
//  PhotoModel.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

enum PhotoModel {
    
    // Fetch and display thumbnail
    enum FetchThumbnail {
        struct Request {
            let id: String
            let server: String
            let secret: String
        }
        
        struct Response {
            let thumbnailData: Data?
        }
        
        struct ViewModel {
            let thumbnailImage: UIImage
        }
    }
}
