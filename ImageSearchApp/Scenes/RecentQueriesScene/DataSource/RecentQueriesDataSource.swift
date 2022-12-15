//
//  RecentQueriesDataSource.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import UIKit

final class RecentQueriesDataSource: NSObject {
    
    // MARK: - Properties
    typealias Query = (query: String, timestamp: Date)
    var uniqueQueries: [String: Int] = [:]
    var queries: [Query] = []
    
}

// MARK: - UITableViewDataSource
extension RecentQueriesDataSource: UITableViewDataSource {
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

// MARK: - Computed properties
extension RecentQueriesDataSource {
    var sortedQueries: [Query] {
        queries.sorted(by: { $0.timestamp > $1.timestamp })
    }
}
