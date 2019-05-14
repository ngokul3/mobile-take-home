//
//  MapRouteTests.swift
//  MapRouteTests
//
//  Created by Gokul K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import XCTest
@testable import MapRoute

class MapRouteTests: XCTestCase {
      override func setUp() {
        
    }
    
    func testDisplayGraphAndBaseCase(){
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        let v4 = graph.addNode(airport: Airport(name: "D", city: nil, country: nil, codeIATA: "D", latitude: nil, longitude: nil))
        let v5 = graph.addNode(airport: Airport(name: "E", city: nil, country: nil, codeIATA: "E", latitude: nil, longitude: nil))
        let v6 = graph.addNode(airport: Airport(name: "F", city: nil, country: nil, codeIATA: "F", latitude: nil, longitude: nil))
        
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
        if let shortPath: [String] = path?.nodeArray.reversed().compactMap({ $0}).map({$0.key}) {
            print("shortest path: \(shortPath)")
        }
        
    }
    func testDirectConnectionBetween2Nodes(){

        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        
        //Forced unwrap ignore - Just testing with known values
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v1!, neighbor: v3!, distance: 8)
        
        let algo = PathFinder()
        var path = algo.shortestPath(source: v1!, destination: v2!)
        
        XCTAssert(path?.nodeArray.count == 2)
        XCTAssert(path?.totalDistance ?? 0.0 == 2.0)
        
        path = algo.shortestPath(source: v2!, destination: v3!)
        XCTAssert(path == nil)
        
         path = algo.shortestPath(source: v1!, destination: v1!)
        XCTAssert(path == nil)
    }

    func testSameDistance2Route(){
        //A->C is 8
        //A->B->D->C is also 8
        
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        let v4 = graph.addNode(airport: Airport(name: "D", city: nil, country: nil, codeIATA: "D", latitude: nil, longitude: nil))
        
        //Forced unwrap ignore - Just testing with known values
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v1!, neighbor: v3!, distance: 8)
        graph.addEdge(source: v2!, neighbor: v4!, distance: 1)
        graph.addEdge(source: v4!, neighbor: v3!, distance: 5)
        
        let algo = PathFinder()
        let path = algo.shortestPath(source: v1!, destination: v3!)
        
        XCTAssert(path?.nodeArray.count == 2)
        XCTAssert(path?.totalDistance ?? 0.0 == 8.0)
        
    }
    
    func testCycleRoute(){
        //A->B is 2
        //B->A is 2
        //B->C is 3
        
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v1!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v3!, distance: 3)
        
        let algo = PathFinder()
        var path = algo.shortestPath(source: v1!, destination: v3!)
        
        XCTAssert(path?.nodeArray.count == 3)
        XCTAssert(path?.totalDistance ?? 0.0 == 5.0)
        
        path = algo.shortestPath(source: v1!, destination: v1!)
        
        XCTAssert(path == nil)
    }
    
    func test2CyleRoutes(){
        //A->B is 2
        //B->A is 2
        //B->C is 3
        //C->B is 3
        //C->D is 4
        
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        let v4 = graph.addNode(airport: Airport(name: "D", city: nil, country: nil, codeIATA: "D", latitude: nil, longitude: nil))
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v1!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v3!, distance: 3)
        graph.addEdge(source: v3!, neighbor: v2!, distance: 3)
        graph.addEdge(source: v3!, neighbor: v4!, distance: 4)
        
        let algo = PathFinder()
        let path = algo.shortestPath(source: v1!, destination: v4!)
        
        XCTAssert(path?.nodeArray.count == 4)
        XCTAssert(path?.totalDistance ?? 0.0 == 9.0)
    }
    
    func test1WayRoute(){
        //A->B is 2
        //Route from B to A does not exist
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        let algo = PathFinder()
        let path = algo.shortestPath(source: v2!, destination: v1!)
        XCTAssert(path == nil)
    }
    
    func testMultipleCycleThroughMultipleNode(){
        //A->B is 2
        //B->A is 2
        //B->C is 3
        //C->B is 3
        //C->D is 11
        //D->E is 5
        //E->F is 8
        //F->A is 8
        //D->A is 20
        //D->B is 5
        
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        let v3 = graph.addNode(airport: Airport(name: "C", city: nil, country: nil, codeIATA: "C", latitude: nil, longitude: nil))
        let v4 = graph.addNode(airport: Airport(name: "D", city: nil, country: nil, codeIATA: "D", latitude: nil, longitude: nil))
        let v5 = graph.addNode(airport: Airport(name: "E", city: nil, country: nil, codeIATA: "E", latitude: nil, longitude: nil))
        let v6 = graph.addNode(airport: Airport(name: "F", city: nil, country: nil, codeIATA: "F", latitude: nil, longitude: nil))
        
        graph.addEdge(source: v1!, neighbor: v2!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v1!, distance: 2)
        graph.addEdge(source: v2!, neighbor: v3!, distance: 3)
        graph.addEdge(source: v3!, neighbor: v2!, distance: 3)
        graph.addEdge(source: v3!, neighbor: v4!, distance: 11)
        graph.addEdge(source: v4!, neighbor: v5!, distance: 5)
        graph.addEdge(source: v5!, neighbor: v6!, distance: 8)
        graph.addEdge(source: v6!, neighbor: v1!, distance: 18)
        graph.addEdge(source: v4!, neighbor: v2!, distance: 5)
        graph.addEdge(source: v4!, neighbor: v1!, distance: 25)
        
        let algo = PathFinder()
        let path = algo.shortestPath(source: v4!, destination: v1!)
        XCTAssert(path?.nodeArray.count == 3)
        XCTAssert(path?.totalDistance ?? 0.0 == 7.0)
    }
 
    func testSameIATACode(){
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
       
        XCTAssert(v1 != nil)
        XCTAssert(v2 == nil)
    }
    
    func testNULLIATACode(){
        let graph = Graph()
        let v1 = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: nil, latitude: nil, longitude: nil))
        let v2 = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        
        XCTAssert(v1 == nil)
        XCTAssert(v2 != nil)
    }
    
    func testUpperCaseVsLowerCase(){
        let graph = Graph()
        let _ = graph.addNode(airport: Airport(name: "A", city: nil, country: nil, codeIATA: "A", latitude: nil, longitude: nil))
        let _ = graph.addNode(airport: Airport(name: "B", city: nil, country: nil, codeIATA: "B", latitude: nil, longitude: nil))
        
        let node = graph.retrieveNode(key: "a")
        XCTAssert(node != nil)
    }
}
