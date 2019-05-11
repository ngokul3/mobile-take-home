//
//  Route.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
// {

import Foundation

class Route {
    var airlineId: String?
    var origin: String?
    var destination: String?
    
    lazy var distance:(Double, Double, Double, Double)->Double = {(originLat, originLong, destLat, destLong) in
        let distanceBetweenOriginAndDest = self.distanceBetweenTwoCoordinates(lat1: originLat, lon1: originLong, lat2: destLat, lon2: destLong)
        return distanceBetweenOriginAndDest
    }
}

extension Route{
    
    func distanceBetweenTwoCoordinates(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double{
        
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        return dist
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
}
