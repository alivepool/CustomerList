//
//  CustomerListViewController.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import UIKit

class CustomerListViewController: UIViewController {

    @IBOutlet weak var customerList: UITableView!
    var viewModel: CustomerListViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerList.register(UITableViewCell.self, forCellReuseIdentifier: "CustomerCell")
        customerList.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.onStateChange = onStateChange(to:)
        loadData()
    }
    
    private func onStateChange(to state: CustomerListViewState) {
        switch state {
        case .loading:
            showLoading()
        case .dataLoaded:
            DispatchQueue.main.async { [weak self] in
                self?.customerList.reloadData()
            }
        case let .empty(message):
            showMessage(message: message)
        case let .error(message: message):
            showMessage(message: message)
        case .clear:
            break
        }
    }
    
    private func loadData() {
        viewModel?.loadCustomerList()
    }
    
    private func showLoading() {
        
    }
    
    private func showMessage(message: String) {
        
    }
    
}

extension CustomerListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell")!
        
        if let cellViewModel = viewModel?.cellViewModel(at: indexPath) {
            cell.textLabel?.text = "\(cellViewModel.customer.name) - \(cellViewModel.customer.id)"
        }
        else {
            cell.textLabel?.text = "No Name"
        }
        
        return cell
    }
    
    
}

