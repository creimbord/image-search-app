//
//  RecentQueriesDataSource.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import UIKit

typealias Query = (query: String, timestamp: Date)

protocol RecentQueriesDataLogic: UITableViewDataSource {
    var uniqueQueries: [String: Int] { get set }
    var queries: [Query] { get set }
    var sortedQueries: [Query] { get }
}

final class RecentQueriesDataSource: NSObject, RecentQueriesDataLogic {
    
    // MARK: - RecentQueriesDataLogic
    var uniqueQueries: [String: Int] = [:]
    var queries: [Query] = []
    var sortedQueries: [Query] {
        queries.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
}

// MARK: - UITableViewDataSource
extension RecentQueriesDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let query = sortedQueries[indexPath.row].query
        let reuseID = String(describing: RecentQueryCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! RecentQueryCell
        cell.configure(with: query)
        
        return cell
    }
}
