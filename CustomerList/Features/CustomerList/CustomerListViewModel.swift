//
//  CustomerListViewModel.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

protocol CustomerListViewModelType {
    var onStateChange: ((CustomerListViewState) -> Void)? { get set }
    var state: CustomerListViewState { get }
    func loadCustomerList()

    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> CustomerCellViewModel?
}

enum CustomerListViewState: Equatable {
    case clear
    case loading
    case empty(message: String)
    case error(message: String)
    case dataLoaded
}


class CustomerListViewModel: CustomerListViewModelType {
    typealias Dependency = CustomerRepositoryInjectable & CustomerSortInjectable & CustomerFilterInjectable
    
    private let customerRepository: CustomerRepositoryType
    private let customerSorter: CustomerSortProvider
    private let customerFilterer: CustomerFilterProvider
    private var customerList: [Customer]?
    private var sortedCustomerList: [Customer]?
    var onStateChange: ((CustomerListViewState) -> Void)?
    var state = CustomerListViewState.clear {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(_ dependency: Dependency) {
        customerRepository = dependency.customerRepository
        customerSorter = dependency.customerSorter
        customerFilterer = dependency.customerFilterer
    }
    
    func loadCustomerList() {
        state = .loading
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.customerRepository.fetchCustomerData { [weak self] customers in
                self?.updateWithData(customers: customers)
            }
        }
    }
    
    private func updateWithData(customers: [Customer]) {
        if customers.isEmpty {
            state = .empty(message: "No data found")
        }
        else {
            customerList = customers
            sortedCustomerList = filterAnsSortCustomersForInvite(customers: customers)
            state = .dataLoaded
        }
    }
    
    private func filterAnsSortCustomersForInvite(customers: [Customer]) -> [Customer] {
        let filteredCustomers = customerFilterer.filterByDistance(customers: customers, fromLocation: IntercomDublin(), lessThan: Constants.filterDistance)
        return customerSorter.sortByUserId(customers: filteredCustomers)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return sortedCustomerList?.count ?? 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CustomerCellViewModel? {
        guard let customer = sortedCustomerList?[indexPath.row] else { return nil }
        return CustomerCellViewModel(customer: customer)
    }
}
