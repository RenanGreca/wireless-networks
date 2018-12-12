//
//  Graph.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/4/16.
//  Copyright © 2016 renangreca. All rights reserved.
//

import Foundation
import Cocoa

class Graph {
    var nodes:[Int: Node]
    var edges:[Edge]
    
    init() {
        self.nodes = [:]
        self.edges = []
    }
    
    // God-mode find edges
    func findEdges() {
        let oldEdges = self.edges
        self.edges = []
        
        // Check for already existing edges
        for e in oldEdges {
            if e.u.inRange(node: e.v) {
                if !edges.contains { $0 == e } {
                    self.edges += [e]
                    e.update()
                }
            }
        }
        
        // Check for new edges
        for (_, u) in nodes {
            for (_, v) in nodes where v != u {
                if u.inRange(node: v) {
                    let e = Edge(u: u, v: v)
                    if !edges.contains { $0 == e } {
                        self.edges += [e]
                    }
                }
            }
        }
    }
    
    func dijkstra(source:Node) {
        var q = [Node]()
        var dist = [Int: Double]()
        var prev = [Int: Node]()
        
        for (i, v) in self.nodes {
            dist[i] = Double.infinity
            prev[i] = nil
            q += [v]
        }
        
        dist[source.id] = 0
        
        while q.count > 0 {
            let i = minDist(q: q, dist: dist)
            let u = q[i]
            q.remove(at: i)
            
            for (_, v) in nodes where u.inRange(node: v) {
                let alt = dist[u.id]! + Double(Edge(u: u, v: v).length)
                if alt < dist[v.id]! {
                    dist[v.id] = alt
                    prev[v.id] = u
                }
            }
        }
        
        source.dist = dist
        source.prev = prev
        
    }
    
    private func minDist(q:[Node], dist:[Int: Double]) -> Int {
        var m = Double.infinity
        var index:Int = 0
        for (i, n) in q.enumerated() {
            if dist[n.id]! < m {
                m = dist[n.id]!
                index = i
            }
        }
        return index
    }
    
    func bandwidthDijkstra(source:Node) {
        var q = [Node]()
        var width = [Int: Double]()
        var prev = [Int: Node]()
        
        for (i, v) in self.nodes {
            width[i] = 0 //Double.infinity
            prev[i] = nil
            q += [v]
        }
        
        width[source.id] = Double.infinity
        
        while q.count > 0 {
            let i = maxWidth(q: q, width: width) // minDist(q, dist: dist)
            let u = q[i]
            q.remove(at: i)
            
            for (_, v) in nodes where u.inRange(node: v) {
                let alt = min(width[u.id]!, Double(Edge(u: u, v: v).w))
                if alt > width[v.id]! {
                    width[v.id] = alt
                    prev[v.id] = u
                }
            }
        }
        
        source.dist = width
        source.prev = prev
        
    }

    private func maxWidth(q:[Node], width:[Int: Double]) -> Int {
        var m:Double = 0
        var index:Int = 0
        for (i, n) in q.enumerated() {
            if width[n.id]! > m {
                m = width[n.id]!
                index = i
            }
        }
        return index
    }
    
    func add(node: Node) {
        self.nodes[node.id] = node
        node.graph = self
    }
}
