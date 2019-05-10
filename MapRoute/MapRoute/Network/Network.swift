//
//  Network.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum Resource {
    case route
    case airline
    case airport
}

protocol NetworkProtocol{
     func loadResource(resource: Resource, finished: @escaping (_ dataDict: NSDictionary?, _ errorMsg: String?)  -> ())
}

class Network{
    private var routeJSONFileNameOpt : String?
    private var airportJSONFileNameOpt : String?
    private var airlineJSONFileNameOpt : String?
    private static var instance: NetworkProtocol?
    
    private let ROUTE_FILE = "RouteFile"
    private let AIRPORT_FILE = "AirportFile"
    private let AIRLINE_FILE = "AirlineFile"
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    init()
    {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRootOpt = NSDictionary(contentsOfFile: path)
            
            guard let dict = dictRootOpt else{
                preconditionFailure("Resource files are not available")
            }
            
            routeJSONFileNameOpt = dict[ROUTE_FILE] as? String
            airportJSONFileNameOpt = dict[AIRPORT_FILE] as? String
            airlineJSONFileNameOpt = dict[AIRLINE_FILE] as? String
        }
    }
}

extension Network{
    static func getInstance() -> NetworkProtocol {
        
        if let inst = Network.instance {
            return inst
        }
        let inst = Network()
        Network.instance = inst
        return inst
    }
}
extension Network: NetworkProtocol{
    func loadResource(resource: Resource, finished: @escaping (NSDictionary?, String?) -> ()) {
        
    }
    
    
}
