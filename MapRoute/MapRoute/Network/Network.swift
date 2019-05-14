//
//  Network.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation



protocol NetworkProtocol{
     func loadResource(resource: Resource, finished : @escaping (NSArray?, String?)->Void )
}

class Network{
    private var routeJSONFileNameOpt : String?
    private var airportJSONFileNameOpt : String?
    private var airlineJSONFileNameOpt : String?
     private let RESOURCE_LIST = "ResourceList"
    var resourceDictOpt: [String: String]?
    
    init()
    {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRootOpt = NSDictionary(contentsOfFile: path)
            
            guard let dict = dictRootOpt else{
                preconditionFailure("Resource not configured")
            }
            
            resourceDictOpt = dict[RESOURCE_LIST] as? [String: String]

        }
    }
}


extension Network: NetworkProtocol{
    func loadResource(resource: Resource, finished : @escaping (NSArray?, String?)->Void ) {
        
        guard let resourceDict = resourceDictOpt else{
            preconditionFailure("Resource files are not available")
        }
        
        let resourceFileName: String?
        resourceFileName = resourceDict[resource.resourceName()]
        
        DispatchQueue.global(qos: .background).async{
            let jsonResult: Any?
            if let path = Bundle.main.path(forResource: resourceFileName, ofType: "json")
            {
                do{
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                }
                catch{
                    finished(nil, "InvalidJsonFile")
                    return
                }
                
                guard let resultArray = jsonResult as? NSArray else {
                    finished(nil, "InvalidJsonFile")
                    return
                }
         
                finished(resultArray, nil)
            }
        }
        
    }
}
