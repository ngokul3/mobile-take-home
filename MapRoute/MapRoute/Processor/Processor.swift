//
//  ModelManager.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum Resource: String, CaseIterable {
    case route
    case airline
    case airport
    
    func resourceName() ->String { return self.rawValue }
    
}

class Processor{
    private var networkObjOpt: NetworkProtocol?
    private var routeArray =  [Route]()
    private var airportArray = [Airport]()
    private var airlineArray = [Airline]()
}

extension Processor{
    func setUpResources(completed: @escaping ()->Void){
        var resourceCompleteSet = Set<Resource>()
        for resource in Resource.allCases{
            self.processResource(resource: resource, completed: {
                resourceCompleteSet.insert(resource)
                if(Resource.allCases.count == resourceCompleteSet.count){
                    completed()
                }
            })
        }
    }
    
    func processResource(resource: Resource, completed : @escaping ()->Void){
        
        networkObjOpt?.loadResource(resource: resource, finished: ({[weak self] (jsonArray, error) in
            
            if let _ = error{
                preconditionFailure("JSON file not valid")
            }
            
            guard let resourceArray = jsonArray else {
                preconditionFailure("Json file could not be parsed into Array")
            }
            
            OperationQueue.main.addOperation {
                resourceArray.forEach({ (arg) in
                    guard let resourceDict = arg as? NSDictionary else{
                        preconditionFailure("JSON file not valid")
                    }
                    
                    switch resource{
                        
                    case .route:
                            let routeObjOpt = self?.loadRoute(resourceDict: resourceDict)
                            if let routeObj = routeObjOpt{
                                self?.routeArray.append(routeObj)
                            }
                        
                    case .airport:
                            let airportObjOpt = self?.loadAirport(resourceDict: resourceDict)
                            if let airportObj = airportObjOpt{
                                self?.airportArray.append(airportObj)
                            }
                        
                    case .airline:
                            let airlineObjOpt = self?.loadAirline(resourceDict: resourceDict)
                            if let airlineObj = airlineObjOpt{
                                self?.airlineArray.append(airlineObj)
                            }
                    }
                    
                })
                completed()
            }
            
        }))
    }
    
    func loadRoute(resourceDict: NSDictionary)->Route{
        var routeObj = Route()
        routeObj.airlineId = resourceDict["Airline Id"] as? String
        routeObj.origin = resourceDict["Origin"] as? String
        routeObj.destination = resourceDict["Destination"] as? String
        return routeObj
    }
    
    func loadAirline(resourceDict: NSDictionary)->Airline{
        var airlineObj = Airline()
        airlineObj.name = resourceDict["Name"] as? String
        airlineObj.country = resourceDict["Country"] as? String
        airlineObj.twoDigitCode = resourceDict["2 Digit Code"] as? String
        airlineObj.threeDigitCode = resourceDict["3 Digit Code"] as? String
        return airlineObj
    }
    
    func loadAirport(resourceDict: NSDictionary)->Airport{
        var airlineObj = Airport()
        airlineObj.name = resourceDict["Name"] as? String
        airlineObj.country = resourceDict["Country"] as? String
        airlineObj.city = resourceDict["City"] as? String
        airlineObj.codeIATA = resourceDict["IATA 3"] as? String
        airlineObj.latitude = resourceDict["Latitute"] as? Double
        airlineObj.longitude = resourceDict["Longitude"] as? Double
        return airlineObj
    }
}
