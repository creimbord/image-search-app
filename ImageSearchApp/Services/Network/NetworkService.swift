//
//  NetworkService.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch(route: RouteType, completion: @escaping (Result<Data?, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    private let session = URLSession.shared
    
    // MARK: - NetworkServiceProtocol
    func fetch(route: RouteType, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let request = getRequest(for: route) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}

// MARK: - Methods
private extension NetworkService {
    func getRequest(for route: RouteType) -> URLRequest? {
        guard let requestURL = route.requestURL else { return nil }
        var request = URLRequest(url: requestURL)
        request.allHTTPHeaderFields = route.headers
        return request
    }
}
