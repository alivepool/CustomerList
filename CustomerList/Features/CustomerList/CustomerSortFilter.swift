//
//  CustomerSortFilter.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

protocol CustomerSortInjectable { var customerSortProvider: CustomerSortProvider { get } }
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
