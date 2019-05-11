
//
//  Helper.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/10/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

public class Node {
    
    var key: String?
    var neighbors: Array<Edge>
    public var visited: Bool
    public var distance: Int?
    
    init() {
        self.neighbors = Array<Edge>()
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
    var weight: Int
    
    init() {
        weight = 0
        self.neighbor = Node()
    }
    
}

public class Graph {
    
    //declare graph canvas
    private var canvas: Array<Node>
    public var isDirected: Bool
    
    init() {
        canvas = Array<Node>()
        isDirected = true
    }
    
    //create a new vertex
    func addNode(key: String) -> Node {
        
        //set the key
        let childNode: Node = Node()
        childNode.key = key
        
        
        //add the childNode to the graph canvas
        canvas.append(childNode)
        
        return childNode
    }
    
    //add edge to source vertex
    func addEdge(source: Node, neighbor: Node, weight: Int) {
        
        //new edge
        let newEdge = Edge()
        
        
        //establish default properties
        newEdge.neighbor = neighbor
        newEdge.weight = weight
        source.neighbors.append(newEdge)
        //check condition for an undirected graph
        if isDirected == false {
            //create a new reversed edge
            let reverseEdge = Edge()
            
            //establish the reversed properties
            reverseEdge.neighbor = source
            reverseEdge.weight = weight
            neighbor.neighbors.append(reverseEdge)
        }
    }
    
    func depthFirstSearch(_ graph: Graph, source: Node) -> [String]? {
        var nodesExplored = [source.key]
        source.visited = true
        
        for edge in source.neighbors {
            if !edge.neighbor.visited {
                nodesExplored += depthFirstSearch(graph, source: edge.neighbor) ?? [""] 
            }
        }
        return nodesExplored as? [String]
    }
}
