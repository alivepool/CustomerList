//
//  Customer.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

struct Customer {
    
    let id: Int
    let name: String
    private let coordinates: CoordinateType
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name, latitude, longitude
    }
}

extension Customer: CoordinateType {
    var latitude: Double {
        return coordinates.latitude
    }
    var longitude: Double {
        return coordinates.longitude
    }
}

extension Customer: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        coordinates = try Coordinate(from: decoder)
    }
}
