//
//  DataError.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import Foundation

enum DataError: Error {
    case photosDataIsMissing
}

// MARK: - LocalizedError
extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .photosDataIsMissing:
            return "The data for photos is missing."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .photosDataIsMissing:
            return "Missing Photos Data"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .photosDataIsMissing:
            return "Try to check the server response for search route."
        }
    }
}
