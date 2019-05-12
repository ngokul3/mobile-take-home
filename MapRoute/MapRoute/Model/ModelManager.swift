//
//  ModelManager.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol ModelManagerProtocol{
    var filteredAirports : [Airport]{get set}
    var currentFilter : String {get set}
    func getGraph()->Graph?
}

class ModelManager: ModelManagerProtocol{
    private static var instance: ModelManagerProtocol?
    private var processor: Processor?
    static func getInstance() -> ModelManagerProtocol {

        if let inst = ModelManager.instance {
            return inst
        }
        let inst = ModelManager()
        ModelManager.instance = inst
        return inst
    }
    
    var filteredAirports : [Airport]
    
    var currentFilter : String = ""{
        didSet{
            
            if(!currentFilter.isEmpty){
                filterAirportNames(enteredName: currentFilter)
            }
            else{
                filteredAirports = processor?.airportArray ?? [Airport]()
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Notifications.AirportFiltered), object: self))
        }
    }
    
    private init(){
        filteredAirports = [Airport]()
        processor = Processor()
        processor?.networkObjOpt = Network()
        loadResources()
    }
    
    private func loadResources() {
        processor?.setUpResources(completed: {
            print("Setting up resources complete")
        })
    }
}

extension ModelManager{
    
    func filterAirportNames(enteredName: String) {
        
        guard let airportArray = processor?.airportArray,
                    airportArray.count > 0 else{
            preconditionFailure("Not able to fetch airport information") //Todo - Error handling - Wait until airport information get loaded
        }
        
        filteredAirports =  airportArray.filter({(arg1) in
            return arg1.codeIATA?.lowercased().contains(enteredName.lowercased()) ?? false
        })
    }
    
 
    
    func getGraph() -> Graph? {
        let graph = processor?.airportGraph()
        return graph
    }
}
