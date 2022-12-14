//
//  PhotoDetailModel.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

enum PhotoDetailModel {
    
    // Display the passed photo
    enum PopulatePhoto {
        struct Request {}
        
        struct Response {
            let id: String
            let title: String
            let server: String
            let secret: String
        }
        
        struct ViewModel {
            let id: String
            let title: String
            let server: String
            let secret: String
        }
    }
    
    // Fetch and display photo
    enum FetchPhoto {
        struct Request {
            let id: String
            let server: String
            let secret: String
        }
        
        struct Response {
            let photoData: Data?
        }
        
        struct ViewModel {
            let photo: UIImage
        }
    }
}
