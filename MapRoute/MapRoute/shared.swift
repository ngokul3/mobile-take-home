//
//  shared.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
struct Notifications {
    static let Route = "Route Model"
    static let Airline = "Airline Model"
    static let Airport = "Airport Model"
    static let ResourcesArrived = "All resources arrived"
    static let AirportFiltered = "Airport filter complete"
   
}

public class Node {
    var key: String
    var neighbors: [Edge]
    public var visited: Bool
    public var latitude: Double?
    public var longitude: Double?
    
    init() {
        self.neighbors = [Edge]()
        self.key = ""
        self.visited = false
    }
    
    init(key: String){
        self.neighbors = [Edge]()
        self.key = key
        self.visited = false
    }
}


public class Edge {
    var neighbor: Node
    var distance: Double
    
    init() {
        distance = 0.0
        self.neighbor = Node()
    }
    
}

public class Graph {
    private var nodeDict: [String: Node]
    
    init() {
        nodeDict = [String: Node]()
    }
    
    func addNode(airport: Airport) -> Node? {
        if let key = airport.codeIATA?.lowercased(){
            if(nodeDict[key] != nil){
                return nil
            }
            let childNode: Node = Node()
            childNode.key = key
            childNode.latitude = airport.latitude
            childNode.longitude = airport.longitude
            
            nodeDict[key] = childNode
            return childNode
        }
        return nil
    }
    
    func addEdge(source: Node, neighbor: Node, distance: Double) {
        let newEdge = Edge()
        newEdge.neighbor = neighbor
        newEdge.distance = distance
        source.neighbors.append(newEdge)
    }
    
    func retrieveNode(key:String)->Node?{
        return nodeDict[key.lowercased()]
    }
    
    func depthFirstSearch(source: Node) -> [String]? {
        var nodesExplored = [source.key]
        source.visited = true
        
        for edge in source.neighbors {
            if !edge.neighbor.visited {
                nodesExplored += depthFirstSearch(source: edge.neighbor) ?? [""]
            }
        }
        return nodesExplored
    }
}

class Path {
    public let totalDistance: Double
    public let node: Node
    public let knownPath: Path?
    
    init(to node: Node, edgeOpt: Edge? , knownPath: Path?) {
        if let knownPath = knownPath,
            let viaConnection = edgeOpt {
            self.totalDistance = viaConnection.distance + knownPath.totalDistance
        } else {
            self.totalDistance = 0
        }
        
        self.node = node
        self.knownPath = knownPath
    }
}

extension Path {
    var nodeArray: [Node] {
        var array: [Node] = [self.node]
        var iterativePath = self
        
        while let path = iterativePath.knownPath {
            array.append(path.node)
            iterativePath = path
        }
        
        return array
    }
}

class PathFinder{
    
    func shortestPath(source: Node, destination: Node) -> Path? {
        var allPossiblePaths: [Path] = [] {
            didSet { allPossiblePaths.sort { return $0.totalDistance < $1.totalDistance } }
        }
        
        allPossiblePaths.append(Path(to: source, edgeOpt: nil, knownPath: nil))
        
        while !allPossiblePaths.isEmpty {
            let easyPath = allPossiblePaths.removeFirst()
            guard !easyPath.node.visited else { continue }
            
            if easyPath.node === destination {
                return easyPath
            }
            
            easyPath.node.visited = true
            
            for connection in easyPath.node.neighbors where !connection.neighbor.visited {
                allPossiblePaths.append(Path(to: connection.neighbor, edgeOpt: connection, knownPath: easyPath))
            }
        }
        return nil
    }
}


extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
