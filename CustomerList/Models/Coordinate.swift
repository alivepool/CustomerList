//
//  Location.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

protocol CoordinateType {
    var latitude: Double { get }
    var longitude: Double { get }
}

struct Coordinate: CoordinateType {
    var latitude: Double
    var longitude: Double
}

extension Coordinate: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latString = try values.decode(String.self, forKey: .latitude)
        let lonString = try values.decode(String.self, forKey: .longitude)
        guard let lat = Double(latString) else {
            throw DecodingError.dataCorruptedError(forKey: .latitude, in: values, debugDescription: "Could not decode latitude value. Expected Double String.")
        }
        latitude = lat
        guard let lon = Double(lonString) else {
            throw DecodingError.dataCorruptedError(forKey: .longitude, in: values, debugDescription: "Could not decode longitude value. Expected Double String.")
        }
        longitude = lon
    }
}
