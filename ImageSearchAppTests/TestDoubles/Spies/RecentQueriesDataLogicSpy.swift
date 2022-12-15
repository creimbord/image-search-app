//
//  RecentQueriesDataLogicSpy.swift
//  ImageSearchAppTests
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import UIKit
@testable import ImageSearchApp

final class RecentQueriesDataLogicSpy: NSObject, RecentQueriesDataLogic {
    
    // MARK: - Properties
    private(set) var isCalledNumberOfRowsInSection = false
    private(set) var isCalledCellForRowAt = false
  
    // MARK: - RecentQueriesDataLogic
    var uniqueQueries: [String : Int] = [:]
    var queries: [Query] = []
    var sortedQueries: [Query] {
        queries.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isCalledNumberOfRowsInSection = true
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        isCalledCellForRowAt = true
        return UITableViewCell()
    }
    
}
