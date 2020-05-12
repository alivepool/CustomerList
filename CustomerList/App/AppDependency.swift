//
//  AppDependency.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

class AppDependency: AllInjectable {
    
    lazy var customerDataService: CustomerDataServiceable = {
        return CustomerDataService(withFileURL: Constants.customerFileURL)
    }()
    
    lazy var customerRepository: CustomerRepositoryType = {
        return CustomerRepository(self)
    }()
    
    lazy var customerSorter: CustomerSortProvider = {
       return CustomerSort()
    }()
    
    lazy var customerFilterer: CustomerFilterProvider = {
        return CustomerFilter()
    }()
}
