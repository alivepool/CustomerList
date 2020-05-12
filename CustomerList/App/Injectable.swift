//
//  Injectable.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

typealias AllInjectable =
    CustomerDataServiceinjectable
    & CustomerRepositoryInjectable
    & CustomerSortInjectable
    & CustomerFilterInjectable

