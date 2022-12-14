//
//  NetworkError.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Provided url request is invalid."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidRequest:
            return "Invalid URL Request"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidRequest:
            return "Try to check the correctness of the url address passed to the URLRequest initializer."
        }
    }
}
