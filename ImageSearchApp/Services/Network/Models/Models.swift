//
//  Models.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

struct PhotoSearchResult: Codable {
    let photos: PagedPhotoSearchResult?
    let stat: String
}

struct PagedPhotoSearchResult: Codable {
    let photo: [Photo]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
}

struct Photo: Codable {
    let id: String
    let title: String
    let secret: String
    let server: String
}
