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

    func filterButtonClicked()
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
    typealias Dependency = CustomerRepositoryInjectable
    
    private let customerRepository: CustomerRepositoryType
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
            state = .dataLoaded
        }
    }
    
    func filterButtonClicked() {
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return customerList?.count ?? 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CustomerCellViewModel? {
        guard let customer = customerList?[indexPath.row] else { return nil }
        return CustomerCellViewModel(customer: customer)
    }
}
