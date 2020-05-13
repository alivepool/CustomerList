//
//  CustomerDataService.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

//protocol CustomerNetworkServiceable {}
protocol CustomerDataServiceinjectable { var customerDataService: CustomerDataServiceable { get } }
protocol CustomerDataServiceable {
    func fetchData(_ completion:  @escaping (([Customer]) -> ()))
}

class CustomerDataService: CustomerDataServiceable {
    
    private let fileURL: URL
    
    init(withFileURL fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func fetchData(_ completion: @escaping (([Customer]) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let fileURL = self?.fileURL {
                self?.fetchAndParse(url: fileURL ,completionHandler:completion)
            }
        }
    }
    
    private func fetchAndParse(url: URL,completionHandler: (([Customer]) -> ())) {
        var customerArr: [Customer] = []
        let text = try? String(contentsOf: url, encoding: .utf8)
        if let arr = text?.components(separatedBy: "\n") {
            customerArr = parse(jsonArr: arr)
        }
        completionHandler(customerArr)
    }
    
    private func parse(jsonArr: [String]) -> [Customer]  {
        let customers = jsonArr.compactMap { str -> Customer? in
            let data = Data(str.utf8)
            if let customer: Customer = try? JSONDecoder().decode(Customer.self, from: data) {
                return customer
            }
            return nil
        }
        
        return customers
    }
}



