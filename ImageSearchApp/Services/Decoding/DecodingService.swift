//
//  DecodingService.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

protocol DecodingServiceProtocol {
    func decodeJSON<Model: Decodable>(_ type: Model.Type, data: Data) -> Result<Model, Error>
}

final class DecodingService: DecodingServiceProtocol {
    
    // MARK: - Properties
    private let decoder = JSONDecoder()
    
    // MARK: - DecodingServiceProtocol
    func decodeJSON<Model: Decodable>(_ type: Model.Type, data: Data) -> Result<Model, Error> {
        do {
            let model = try decoder.decode(type, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}
