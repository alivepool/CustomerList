//
//  Environment.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

struct IntercomDublin: CoordinateType {
    
    var latitude: Double {
        return Constants.intercomDublinLatitude
    }
    
    var longitude: Double {
        return Constants.intercomDublinLongitude
    }
}

struct Constants {
    fileprivate static let intercomDublinLatitude = 53.339428
    fileprivate static let intercomDublinLongitude = -6.257664
    
    static let customerFileURL = Bundle.main.url(forResource: "customers", withExtension: "txt")!
}
