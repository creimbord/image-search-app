//
//  RouteType.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import Foundation

protocol RouteType {
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParams: [String: String] { get }
    var requestURL: URL? { get }
}
