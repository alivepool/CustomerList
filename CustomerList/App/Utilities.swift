//
//  Utilities.swift
//  CustomerList
//
//  Created by Ameya on 12/05/20.
//  Copyright © 2020 ameya. All rights reserved.
//

import Foundation

// Implementation of Haversine formula to find Great-circle distance

func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
    let lat1rad = lat1 * Double.pi/180
    let lon1rad = lon1 * Double.pi/180
    let lat2rad = lat2 * Double.pi/180
    let lon2rad = lon2 * Double.pi/180
 
    let dLat = lat2rad - lat1rad
    let dLon = lon2rad - lon1rad
    let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
    let c = 2 * asin(sqrt(a))
    let R = 6372.8
 
    return R * c
}

func validateCoordinate(coordinate: CoordinateType) -> Bool {
    (coordinate.latitude > -90 && coordinate.latitude < 90) && (coordinate.longitude > -180 && coordinate.longitude < 180)
}
