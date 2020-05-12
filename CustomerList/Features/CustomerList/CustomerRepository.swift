//
//  CustomerRepository.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

protocol CustomerRepositoryInjectable { var customerRepository: CustomerRepositoryType { get } }

protocol CustomerRepositoryType {
    func fetchCustomerData(_ completion: @escaping (([Customer]) -> ()))
}

class CustomerRepository: CustomerRepositoryType {
    typealias Dependency = CustomerDataServiceinjectable
    
    private let dataService: CustomerDataServiceable
    
    init(_ dependency: Dependency) {
        dataService = dependency.customerDataService
    }
    
    func fetchCustomerData(_ completion: @escaping (([Customer]) -> ())) {
        dataService.fetchData(completion)
    }
    
}
