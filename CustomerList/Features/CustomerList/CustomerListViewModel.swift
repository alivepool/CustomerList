//
//  CustomerListViewModel.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

typealias FilterActions = (title: String, action: (()->()))

protocol CustomerListViewModelType {
    var onStateChange: ((CustomerListViewState) -> Void)? { get set }
    var state: CustomerListViewState { get }
    func loadCustomerList()

    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> CustomerCellViewModel?
    
    func filterActions() -> [FilterActions]
}

enum CustomerListViewState: Equatable {
    case clear
    case loading
    case empty(message: String)
    case error(message: String)
    case dataLoaded
}

enum CustomerDataState {
    case all
    case validated
}


class CustomerListViewModel: CustomerListViewModelType {
    typealias Dependency = CustomerRepositoryInjectable & CustomerSortInjectable & CustomerFilterInjectable
    
    private let customerRepository: CustomerRepositoryType
    private let customerSorter: CustomerSortProvider
    private let customerFilterer: CustomerFilterProvider
    private var customerList: [Customer]?
    private var validatedCustomerList: [Customer]?
    private var currentList: [Customer]?
    var onStateChange: ((CustomerListViewState) -> Void)?
    var state = CustomerListViewState.clear {
        didSet {
            onStateChange?(state)
        }
    }
    
    private var dataState: CustomerDataState = .validated
    
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
            customerList = customerSorter.sortByUserId(customers: customers)
            validatedCustomerList = filterAnsSortCustomersForInvite(customers: customers)
            updateSelectedList()
            state = .dataLoaded
        }
    }
    
    private func filterAnsSortCustomersForInvite(customers: [Customer]) -> [Customer] {
        let filteredCustomers = customerFilterer.filterByDistance(customers: customers, fromLocation: IntercomDublin(), lessThan: Constants.filterDistance)
        return customerSorter.sortByUserId(customers: filteredCustomers)
    }
    
    private func setDataState(dataState: CustomerDataState) {
        self.dataState = dataState
        updateSelectedList()
        state = .dataLoaded
    }
    
    private func updateSelectedList() {
        switch dataState {
        case .all:
            currentList = customerList
        case .validated:
            currentList = validatedCustomerList
        }
    }
    
}

extension CustomerListViewModel {
        
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        var list: [Customer]? = nil
        switch dataState {
        case .all:
            list = customerList
        case .validated:
            list = validatedCustomerList
        }
        return list?.count ?? 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CustomerCellViewModel? {
        var list: [Customer]? = nil
        switch dataState {
        case .all:
            list = customerList
        case .validated:
            list = validatedCustomerList
        }
        guard let customer = list?[indexPath.row] else { return nil }
        return CustomerCellViewModel(customer: customer)
    }
    
    func filterActions() -> [FilterActions] {
        [(title: "Show all customers", action: { [weak self] in
            self?.setDataState(dataState: .all)
        }), (title: "Show validated customers", action: { [weak self] in
            self?.setDataState(dataState: .validated)
        })]
    }
}
