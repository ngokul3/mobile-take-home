
//
//  Places.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
import MapKit

class PointOfInterest{
    var origin: String?
    var destination: String?
}

class RouteResult: NSObject{
    var airportCode: String?
    var airline: String?
    let coordinate: CLLocationCoordinate2D?
    
    init(airline:String, airportCode: String,  coordinate: CLLocationCoordinate2D) {
        self.airportCode = airportCode
        self.coordinate = coordinate
        self.airline = airline
        super.init()
    }
}


class RouteMaker{
    var pointOfInterest: PointOfInterest?
    var graph: Graph?
    var routeArray: [Route]?
    var airportArray: [Airport]?
    private var resultArray: RouteResult?
    
    func findConnection ()->[RouteResult]?{
        let _ = routeArray?.filter({ (route) -> Bool in
            if(route.origin == pointOfInterest?.origin && route.destination == pointOfInterest?.destination){
                
                //let routeResult = RouteResult(airline: route.airlineId, airportCode: <#T##String#>, coordinate: <#T##CLLocationCoordinate2D#>)
               // routeResult.
                return true
            }else{
                return false
            }
        })
        return nil
    }
}
