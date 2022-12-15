//
//  RecentQueriesInteractorTests.swift
//  ImageSearchAppTests
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import XCTest
@testable import ImageSearchApp

final class RecentQueriesInteractorTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: RecentQueriesInteractor!
    private var presenter: RecentQueriesPresentationLogicSpy!
    private var dataSource: RecentQueriesDataLogicSpy!
    
    // MARK: - Life cycle
    override func setUp() {
        super.setUp()
        
        let recentQueriesInteractor = RecentQueriesInteractor()
        let recentQueriesPresenter = RecentQueriesPresentationLogicSpy()
        let recentQueriesDataSource = RecentQueriesDataLogicSpy()
        
        recentQueriesInteractor.presenter = recentQueriesPresenter
        recentQueriesInteractor.dataSource = recentQueriesDataSource
        
        sut = recentQueriesInteractor
        presenter = recentQueriesPresenter
        dataSource = recentQueriesDataSource
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        dataSource = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_singleQuery_addQuery() {
        let request = RecentQueriesModel.AddQuery.Request(query: "Deer")
        
        sut.addQuery(request)
        
        XCTAssertTrue(presenter.isCalledPresentAddedQuery)
        XCTAssertTrue(dataSource.queries[0].query == "Deer")
        XCTAssertEqual(dataSource.uniqueQueries, ["Deer": 0])
    }
    
    func test_duplicateQuery_addQuery() {
        let request1 = RecentQueriesModel.AddQuery.Request(query: "Car")
        let request2 = RecentQueriesModel.AddQuery.Request(query: "Car")
        
        sut.addQuery(request1)
        sut.addQuery(request2)
        
        XCTAssertTrue(presenter.isCalledPresentAddedQuery)
        XCTAssertTrue(dataSource.queries.count == 1)
        XCTAssertTrue(dataSource.queries[0].query == "Car")
        XCTAssertEqual(dataSource.uniqueQueries, ["Car": 0])
    }
    
    func testSelectQuery() {
        let request = RecentQueriesModel.SelectQuery.Request(index: 0)
        dataSource.queries = [
            (query: "Tree", timestamp: Date().yesterday),
            (query: "Forest", timestamp: Date())
        ]
        
        sut.selectQuery(request)
        
        XCTAssertTrue(presenter.isCalledPresentSelectedQuery)
        XCTAssertEqual(presenter.query, "Forest")
    }
    
}

private extension Date {
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

