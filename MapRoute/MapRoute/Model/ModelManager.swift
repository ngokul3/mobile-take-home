//
//  ModelManager.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol ModelManagerProtocol{
    func loadResources()
}

class ModelManager: ModelManagerProtocol{
    private static var instance: ModelManagerProtocol?
    static func getInstance() -> ModelManagerProtocol {

        if let inst = ModelManager.instance {
            return inst
        }
        let inst = ModelManager()
        ModelManager.instance = inst
        return inst
    }
    
    func loadResources() {
        let processor = Processor()
        processor.networkObjOpt = Network()
        processor.setUpResources(completed: {
            processor.routeArray.forEach(({ (route) in
                processor.airportArray.forEach({ (airport) in
                    if(airport.codeIATA == route.origin ){
                        print(airport.codeIATA)
                    }
                })
            }))
            print("Setting up resources complete")
        })
        
        //let graph = processor.airportGraph
       // let nodesOpt = graph.depthFirstSearch(source: v5!)
        
//        if let nodes = nodesOpt{
//            for node in nodes{
//                print(node)
//            }
//        }
    }
}
