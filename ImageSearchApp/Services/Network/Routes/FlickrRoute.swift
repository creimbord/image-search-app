//
//  FlickrRoute.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

enum FlickrRoute {
    case search(query: String, page: Int, perpage: Int)
    case photo(id: String, server: String, secret: String, size: PhotoSize)   
}

// MARK: - RouteType
extension FlickrRoute: RouteType {
    static let apiKey = "1508443e49213ff84d566777dc211f2a"
    
    var baseURL: String {
        switch self {
        case .search:
            return "https://api.flickr.com/services/rest"
        case .photo:
            return "https://live.staticflickr.com"
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "flickr.photos.search"
        case let .photo(id, server, secret, size):
            return "/\(server)/\(id)_\(secret)_\(size.rawValue).jpg"
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var queryParams: [String: String] {
        switch self {
        case let .search(query, page, perpage):
            return [
                "text": query,
                "page": String(page),
                "per_page": String(perpage),
                "format": "json",
                "nojsoncallback": "1"
            ]
        case .photo:
            return [:]
        }
    }
    
    var requestURL: URL? {
        switch self {
        case .search:
            let apiKey = "?api_key=\(FlickrRoute.apiKey)"
            let path = "&method=\(self.path)"
            let params = queryParams.map({ param, value in "&\(param)=\(value)" }).joined()
            let encodedParams = params.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed
            ) ?? ""
            let urlString = baseURL + apiKey + path + encodedParams
            return URL(string: urlString)
        case .photo:
            let urlString = baseURL + path
            return URL(string: urlString)
        }
    }
}
