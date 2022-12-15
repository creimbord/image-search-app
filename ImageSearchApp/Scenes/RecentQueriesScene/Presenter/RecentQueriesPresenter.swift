//
//  RecentQueriesPresenter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import Foundation

protocol RecentQueriesPresentationLogic: AnyObject {
    func presentAddedQuery(_ response: RecentQueriesModel.AddQuery.Response)
    func presentSelectedQuery(_ response: RecentQueriesModel.SelectQuery.Response)
}

final class RecentQueriesPresenter: RecentQueriesPresentationLogic {
    
    // MARK: - Properties
    weak var viewController: RecentQueriesDisplayLogic?
    
    // MARK: - RecentQueriesPresentationLogic
    func presentAddedQuery(_ response: RecentQueriesModel.AddQuery.Response) {
        viewController?.displayAddedQuery(.init())
    }
    
    func presentSelectedQuery(_ response: RecentQueriesModel.SelectQuery.Response) {
        viewController?.displaySelectedQuery(.init(query: response.query))
    }
}
