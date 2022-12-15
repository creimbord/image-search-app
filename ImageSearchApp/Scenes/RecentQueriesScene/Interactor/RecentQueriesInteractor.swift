//
//  RecentQueriesInteractor.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import Foundation

protocol RecentQueriesBusinessLogic: AnyObject {
    func addQuery(_ request: RecentQueriesModel.AddQuery.Request)
    func selectQuery(_ request: RecentQueriesModel.SelectQuery.Request)
}

protocol RecentQueriesDataStore {
    var dataSource: RecentQueriesDataLogic? { get }
}

final class RecentQueriesInteractor: RecentQueriesDataStore {
    
    // MARK: - Properties
    var presenter: RecentQueriesPresentationLogic?
    
    // MARK: - RecentQueriesDataStore
    var dataSource: RecentQueriesDataLogic?
}

// MARK: - RecentQueriesBusinessLogic
extension RecentQueriesInteractor: RecentQueriesBusinessLogic {
    func addQuery(_ request: RecentQueriesModel.AddQuery.Request) {
        guard let dataSource = dataSource else { return }
        let searchQuery = request.query
        
        if let index = dataSource.uniqueQueries[searchQuery] {
            dataSource.queries[index].timestamp = Date()
        } else {
            guard !searchQuery.isEmpty else { return }
            dataSource.queries.append((query: searchQuery, timestamp: Date()))
            dataSource.uniqueQueries[searchQuery] = dataSource.queries.count - 1
        }
        
        presenter?.presentAddedQuery(.init())
    }
    
    func selectQuery(_ request: RecentQueriesModel.SelectQuery.Request) {
        if let query = dataSource?.sortedQueries[request.index].query {
            presenter?.presentSelectedQuery(.init(query: query))
        }
    }
}
