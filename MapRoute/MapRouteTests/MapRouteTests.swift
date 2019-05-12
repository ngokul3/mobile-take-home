//
//  MapRouteTests.swift
//  MapRouteTests
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import XCTest
@testable import MapRoute

class MapRouteTests: XCTestCase {
    var routeArray = [Route]()
    var airlineArray = [Airline]()
    var airportArray = [Airport]()
    
    override func setUp() {
        
    }
    
    func testGraph(){
        //Distance is 2
        let routeObj1 = Route()
        routeObj1.origin = "A"
        routeObj1.destination = "B"
        
        //Distance is 8
        let routeObj2 = Route()
        routeObj2.origin = "A"
        routeObj2.destination = "C"
        
        
        //Distance is 1
        let routeObj3 = Route()
        routeObj3.origin = "B"
        routeObj3.destination = "D"
        
        //Distance is 2
        let routeObj4 = Route()
        routeObj4.origin = "D"
        routeObj4.destination = "C"
        
        let routeObj5 = Route()
        routeObj5.origin = "E"
        routeObj5.destination = "F"
        
        routeArray.append(routeObj1)
        routeArray.append(routeObj2)
        routeArray.append(routeObj3)
        routeArray.append(routeObj4)
        routeArray.append(routeObj5)
        
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v4 = graph.addNode(airport: Airport(name: "D", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v5 = graph.addNode(airport: Airport(name: "E", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v6 = graph.addNode(airport: Airport(name: "F", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        
        //Forced unwrap ignore - Just testing with known values
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v1!, neighbor: v3!, distance: 8)
        graph.addEdge(source: v2!, neighbor: v4!, distance: 1)
        graph.addEdge(source: v4!, neighbor: v3!, distance: 2)
        graph.addEdge(source: v5!, neighbor: v6!, distance: 12)
        
        let nodesOpt = graph.depthFirstSearch(source: v5!)
        
        if let nodes = nodesOpt{
            for node in nodes{
                print(node)
            }
        }
        
        let algo = PathFinder()
        let path = algo.shortestPath(source: v1!, destination: v3!)
        if let succession: [String] = path?.nodeArray.reversed().compactMap({ $0}).map({$0.key}) {
            print("shortest path: \(succession)")
        }
        
    }
    func testDirectConnection(){

        let routeObj1 = Route()
        routeObj1.origin = "YAM"
        routeObj1.destination = "YYZ"

        let routeObj2 = Route()
        routeObj2.origin = "YBC"
        routeObj2.destination = "YUL"

        routeArray.append(routeObj1)
        routeArray.append(routeObj2)
        
        var airportObj1 = Airport()
        airportObj1.codeIATA = "YAM"
        airportArray.append(airportObj1)
        
        var airportObj2 = Airport()
        airportObj2.codeIATA = "YYZ"
        airportArray.append(airportObj2)
        
        var airportObj3 = Airport()
        airportObj3.codeIATA = "YUL"
        airportArray.append(airportObj3)
        
       // let routeMaker = RouteMaker()
//        let results = routeMaker.findConnection(routeArray: routeArray, airlineArray: airlineArray, airportArray: airportArray)
//        XCTAssert(results == nil)

    }

 
}
