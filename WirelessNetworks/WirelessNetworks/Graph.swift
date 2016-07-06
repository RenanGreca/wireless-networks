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
    var nodes:[String: Node]
    var edges:[Edge]
    
    init(nodes:[String: Node]) {
        self.nodes = nodes
        self.edges = []
    }
    
    // God-mode find edges
    func findEdges() {
        self.edges = []
        for (_, u) in nodes {
            for (_, v) in nodes where v != u {
                if u.inRange(v) {
                    let e = Edge(u: u, v: v)
                    if !edges.contains({ $0 == e }) {
                        self.edges += [e]
                    }
                }
            }
        }
    }
    
    func flood(source: Node, explored: [Node]) {
        let e = explored+[source]
        source.edges = []
        for (_, v) in nodes where source.inRange(v) && !e.contains({$0 == v}) {
            source.send(.flood, to: v)
            let delay = 1.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.flood(v, explored: e)
            }
            
        }
        self.edges += source.edges
    }
    
    func dijkstra(source:Node) {
        var q = [Node]()
        var dist = [String: Double]()
        var prev = [String: Node]()
        var path = [Node]()
        
        for (i, v) in self.nodes {
            dist[i] = Double.infinity
            prev[i] = nil
            q += [v]
        }
        
        dist[source.id] = 0
        
        while q.count > 0 {
            let i = minDist(q, dist: dist)
            let u = q[i]
            q.removeAtIndex(i)
            
            for (_, v) in nodes where u.inRange(v) {
                let alt = dist[u.id]! + Double(Edge(u: u, v: v).length)
                if alt < dist[v.id] {
                    dist[v.id] = alt
                    prev[v.id] = u
                }
            }
        }
        
        source.dist = dist
        source.prev = prev
        
    }
    
    private func minDist(q:[Node], dist:[String: Double]) -> Int {
        var m = Double.infinity
        var index:Int = 0
        for (i, n) in q.enumerate() {
            if dist[n.id] < m {
                m = dist[n.id]!
                index = i
            }
        }
        return index
    }
    
    func add(node: Node) {
        self.nodes[node.id] = node
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.updateSelectors(node)
    }

}
