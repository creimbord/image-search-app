//
//  RecentQueriesPresentationLogicSpy.swift
//  ImageSearchAppTests
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import Foundation
@testable import ImageSearchApp

final class RecentQueriesPresentationLogicSpy: RecentQueriesPresentationLogic {
    
    // MARK: - Properties
    private(set) var isCalledPresentAddedQuery = false
    private(set) var isCalledPresentSelectedQuery = false
    private(set) var query = ""
    
    // MARK: - RecentQueriesPresentationLogic
    func presentAddedQuery(_ response: RecentQueriesModel.AddQuery.Response) {
        isCalledPresentAddedQuery = true
    }
    
    func presentSelectedQuery(_ response: RecentQueriesModel.SelectQuery.Response) {
        isCalledPresentSelectedQuery = true
        query = response.query
    }
}
