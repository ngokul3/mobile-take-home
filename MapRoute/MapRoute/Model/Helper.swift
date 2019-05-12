
//
//  Helper.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

public class Node {
    
    var key: String
    var neighbors: [Edge]
    public var visited: Bool
    public var distance: Int?
    
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
    
    //declare graph canvas
    //private var canvas: Array<Node>
    private var nodeSet: Set<String>
    public var isDirected: Bool
    
    init() {
       // canvas = Array<Node>()
         nodeSet = Set<String>()
        isDirected = true
    }
    
    //create a new vertex
    func addNode(key: String) -> Node? {
        
        if(nodeSet.contains(key)){
            return nil
        }
        //set the key
        let childNode: Node = Node()
        childNode.key = key
        
        
        //add the childNode to the graph canvas
        //canvas.append(childNode)
        
        
        nodeSet.insert(childNode.key)
        
        return childNode
    }
    
    //add edge to source vertex
    func addEdge(source: Node, neighbor: Node, distance: Double) {
        
        //new edge
        let newEdge = Edge()
        
        
        //establish default properties
        newEdge.neighbor = neighbor
        newEdge.distance = distance
        source.neighbors.append(newEdge)
        //check condition for an undirected graph
        if isDirected == false {
            //create a new reversed edge
            let reverseEdge = Edge()
            
            //establish the reversed properties
            reverseEdge.neighbor = source
            reverseEdge.distance = distance
            neighbor.neighbors.append(reverseEdge)
        }
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
    
    func shortestPath(source: Node, destination: Node) -> Path? {
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.totalDistance < $1.totalDistance } } // the frontier has to be always ordered
        }
        
        frontier.append(Path(to: source, edgeOpt: nil, knownPath: nil)) // the frontier is made by a path that starts nowhere and ends in the source
        
        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
            
            if cheapestPathInFrontier.node === destination {
                return cheapestPathInFrontier // found the cheapest path 😎
            }
            
            cheapestPathInFrontier.node.visited = true
            
            for connection in cheapestPathInFrontier.node.neighbors where !connection.neighbor.visited { // adding new paths to our frontier
                frontier.append(Path(to: connection.neighbor, edgeOpt: connection, knownPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path 😣
    }
    
}

class Path {
    public let totalDistance: Double
    public let node: Node
    public let knownPath: Path?
    
    init(to node: Node, edgeOpt: Edge? , knownPath: Path?) {
        if
            let knownPath = knownPath,
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
    var array: [Node] {
        var array: [Node] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.knownPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}

class ShortestPathAlgo{
    func findRoute(originNode: Node, destNode: Node){
        
    }
}
