
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
    var neighbors: Array<Edge>
    public var visited: Bool
    public var distance: Int?
    
    init() {
        self.neighbors = Array<Edge>()
        self.key = ""
        self.visited = false
    }
    
    init(key: String){
        self.neighbors = Array<Edge>()
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
}
