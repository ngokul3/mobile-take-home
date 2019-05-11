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
    var networkObjOpt: NetworkProtocol?
    var routeArray =  [Route]()
    var airportArray = [Airport]()
    var airlineArray = [Airline]()
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
    
    private func processResource(resource: Resource, completed : @escaping ()->Void){
        let RESOURCE_ERROR = "Error loading Resource"
        
        networkObjOpt?.loadResource(resource: resource, finished: ({[weak self] (jsonArray, error) in
            
            if let _ = error{
                preconditionFailure(RESOURCE_ERROR)
            }
            
            guard let resourceArray = jsonArray else {
                preconditionFailure(RESOURCE_ERROR)
            }
            
            OperationQueue.main.addOperation {
                resourceArray.forEach({ (arg) in
                    guard let resourceDict = arg as? NSDictionary else{
                        preconditionFailure(RESOURCE_ERROR)
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
                
                let nsNotification = NSNotification(name: NSNotification.Name(rawValue: Notifications.ResourcesArrived), object: nil)
                NotificationCenter.default.post(name: nsNotification.name, object: nil,
                                                    userInfo:[Notifications.Route: self?.routeArray ?? [Route](),
                                                            Notifications.Airport: self?.airportArray ?? [Airport](),
                                                            Notifications.Airline: self?.airlineArray ?? [Airline]()])

                completed()
            }
            
        }))
    }
    
    private func loadRoute(resourceDict: NSDictionary)->Route{
        var routeObj = Route()
        routeObj.airlineId = resourceDict["Airline Id"] as? String
        routeObj.origin = resourceDict["Origin"] as? String
        routeObj.destination = resourceDict["Destination"] as? String
        return routeObj
    }
    
    private func loadAirline(resourceDict: NSDictionary)->Airline{
        var airlineObj = Airline()
        airlineObj.name = resourceDict["Name"] as? String
        airlineObj.country = resourceDict["Country"] as? String
        airlineObj.twoDigitCode = resourceDict["2 Digit Code"] as? String
        airlineObj.threeDigitCode = resourceDict["3 Digit Code"] as? String
        return airlineObj
    }
    
    private func loadAirport(resourceDict: NSDictionary)->Airport{
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
