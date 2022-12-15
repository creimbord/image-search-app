//
//  RecentQueriesModel.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import Foundation

enum RecentQueriesModel {
    
    // Add query to recent queries
    enum AddQuery {
        struct Request {
            let query: String
        }
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    // Select the concrete query
    enum SelectQuery {
        struct Request {
            let index: Int
        }
        
        struct Response {
            let query: String
        }
        
        struct ViewModel {
            let query: String
        }
    }
}
