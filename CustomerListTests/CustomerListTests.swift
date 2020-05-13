//
//  CustomerListTests.swift
//  CustomerListTests
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import XCTest
@testable import CustomerList

class CustomerListTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test for valid json data
    func testValidParsing() throws {
        
        let expectation = self.expectation(description: "Customer count")
        
        let bundle = Bundle(for: type(of: self))
        let customerFileURL = bundle.url(forResource: "customers", withExtension: "txt")!
        let dataService = CustomerDataService(withFileURL: customerFileURL)
        var customers: [Customer] = []
        
        
        dataService.fetchData { cs in
            customers = cs
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(customers.count, 32)
    }
    
    // Test for invalid json data, only 27 customers records are with valid json values
    func testInValidParsing() throws {
        
        let expectation = self.expectation(description: "Customer count")
        
        let bundle = Bundle(for: type(of: self))
        let customerFileURL = bundle.url(forResource: "invalid_customers", withExtension: "txt")!
        let dataService = CustomerDataService(withFileURL: customerFileURL)
        var customers: [Customer] = []
        
        
        dataService.fetchData { cs in
            customers = cs
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(customers.count, 27)
    }
    
    // Test for filter
    func testFilter() throws {
        
        let expectation = self.expectation(description: "Customer count")
        
        let bundle = Bundle(for: type(of: self))
        let customerFileURL = bundle.url(forResource: "filter_customers", withExtension: "txt")!
        let dataService = CustomerDataService(withFileURL: customerFileURL)
        var customers: [Customer] = []
        
        
        dataService.fetchData { cs in
            customers = cs
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        let filter = CustomerFilter()
        
        
        let filteredCustomers10000 = filter.filterByDistance(customers: customers, fromLocation: Coordinate(latitude: 53.350140, longitude: -6.266155), lessThan: 10000)
        
        // Test if all are within 10000 km range
        XCTAssertEqual(filteredCustomers10000.count, 32)
        
        let filteredCustomers5000 = filter.filterByDistance(customers: customers, fromLocation: Coordinate(latitude: 53.350140, longitude: -6.266155), lessThan: 5000)
        
        // Test if all are within 5000 km range
        XCTAssertEqual(filteredCustomers5000.count, 22)
        
        let filteredCustomers100 = filter.filterByDistance(customers: customers, fromLocation: Coordinate(latitude: 53.350140, longitude: -6.266155), lessThan: 100)
        
        // Test if all are within 5000 km range
        XCTAssertEqual(filteredCustomers100.count, 12)
    }
    
    // Test for invalid coordinate filter
    func testInvalidCoordinateFilter() throws {
        
        let expectation = self.expectation(description: "Customer count")
        
        let bundle = Bundle(for: type(of: self))
        let customerFileURL = bundle.url(forResource: "filter_invalid_coordinate_customers", withExtension: "txt")!
        let dataService = CustomerDataService(withFileURL: customerFileURL)
        var customers: [Customer] = []
        
        
        dataService.fetchData { cs in
            customers = cs
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        let filter = CustomerFilter()
        
        
        let filteredCustomers100 = filter.filterByDistance(customers: customers, fromLocation: Coordinate(latitude: 53.350140, longitude: -6.266155), lessThan: 100)
        
        // Test if all are within 5000 km range
        XCTAssertEqual(filteredCustomers100.count, 10)
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
