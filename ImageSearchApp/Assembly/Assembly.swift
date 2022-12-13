//
//  Assembly.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

enum Assembly {
    static func createSearchScene() -> UINavigationController {
        let viewController = SearchViewController()
        return UINavigationController(rootViewController: viewController)
    }
}
