//
//  CustomerSortFilter.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

// Sorting
protocol CustomerSortInjectable { var customerSorter: CustomerSortProvider { get } }
protocol CustomerSortProvider {
    func sortByUserId(customers: [Customer]) -> [Customer]
}

class CustomerSort: CustomerSortProvider {
    func sortByUserId(customers: [Customer]) -> [Customer] {
        return customers.sorted { (c1, c2) -> Bool in
            c1.id < c2.id
        }
    }
    
}


// Filtering
protocol CustomerFilterInjectable { var customerFilterer: CustomerFilterProvider { get } }
protocol CustomerFilterProvider {
    func filterByDistance(customers: [Customer], fromLocation: CoordinateType, lessThan maxDistance: Double) -> [Customer]
}

class CustomerFilter: CustomerFilterProvider {
    func filterByDistance(customers: [Customer], fromLocation location: CoordinateType, lessThan maxDistance: Double) -> [Customer] {
        return customers.compactMap { customer -> Customer? in
            guard customer.isValidCoordinate() && location.isValidCoordinate() else { return nil }
            let distance = haversine(lat1: location.latitude, lon1: location.longitude, lat2: customer.latitude, lon2: customer.longitude)
            if  distance < maxDistance {
                return customer
            }
            return nil
        }
    }
}
