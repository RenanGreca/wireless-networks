//
//  GameScene.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/1/16.
//  Copyright (c) 2016 renangreca. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var graph:Graph?
    
    var selectedNode:Node?
    var lines:[SKShapeNode] = []
    var pathLines:[SKShapeNode] = []
    
    var calculatingDijkstra = false
    var modeDijkstra:DijkstraMode = .latency
    var flooding = false
    var source:Node?
    
    var from: Node?
    var to: Node?
    
    override func didMove(to view: SKView) {
        graph = Graph()
        self.createNodes(n: 10)
    }
    
    // Gets click event
    // If a node is clicked, drag it
    // Else, create a new one
    override func mouseDown(with theEvent: NSEvent) {
        let location = theEvent.location(in: self)
        
        for touchedNode in self.nodes(at: location) {
            if let node = touchedNode as? SKShapeNode {
                if let n = node.name {
                    
                    let name = n.characters.split {$0 == ":"}.map { String($0) }
                    if name[0] == "circle" {
                        self.selectedNode = graph!.nodes[Int(name[1])!]
                    }
                }
            }
        }
        
        if let _ = self.selectedNode {
        } else {
            
            let node = Node(x: location.x, y: location.y, label: graph!.nodes.count, range: nil)
            
            graph!.add(node: node)
            node.addToScene(scene: self)
            
            self.selectedNode = node
        }

    }
    
    // Gets drag event
    override func mouseDragged(with theEvent: NSEvent) {
        let location = theEvent.location(in: self)
//        self.flooding = false
        
        if let node = self.selectedNode {
            node.position = location
            node.update()
        }

    }
    
    // Gets click release event
    override func mouseUp(with theEvent: NSEvent) {
        self.selectedNode = nil
    }
    
    // 60 frames per second
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        self.removeChildren(in: self.lines)
        self.lines = []
        self.drawEdges(edges: self.graph!.edges)
        
        self.graph?.findEdges()
        if flooding {
            source!.flood()
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.tableView.reloadData()
        }
        
        if self.calculatingDijkstra {
            if self.modeDijkstra == .latency {
                self.graph!.dijkstra(source: from!)
            } else {
                self.graph!.bandwidthDijkstra(source: from!)
            }
            self.removeChildren(in: self.pathLines)
            drawPath(from: from!, to: to!)
        }
    }
    
    // Creates n nodes with random positions
    func createNodes(n: Int) -> [Int: Node] {
        var nodes = [Int: Node]()
        let xRange = 0..<Int(self.frame.width)
        let yRange = 0..<Int(self.frame.height)
        
        for i in 0..<n {
            let x = CGFloat(Int.random(range: xRange))
            let y = CGFloat(Int.random(range: yRange))
            
            let node = Node(x:x, y:y, label: i, range:nil)
            nodes[i] = node
            
            self.graph?.add(node: node)
            node.addToScene(scene: self)
        }
        
        return nodes
    }
    
    func drawEdges(edges: [Edge]) {
        for e in edges {
            self.addChild(e.line)
            self.lines += [e.line]
        }
    }
    
    func eraseEdges() {
        for l in self.lines {
            l.removeFromParent()
        }
        self.lines = [SKShapeNode]()
    }
    
    // Draws a path between two nodes; usually used to show dijkstra results
    func drawPath(from: Node, to: Node) {
        self.pathLines = []
        
        if let val = from.prev[to.id] {
            var u = to
            var v = val
            while (v != from) {
                let line = SKShapeNode()
                line.lineWidth = CGFloat(min(u.bandwidth, v.bandwidth)*2)
                line.strokeColor = SKColor.yellow
                
                let path = CGMutablePath()
                path.move(to: u.position)
//                CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
                path.addLine(to: v.position)
//                CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
                line.path = path
                line.zPosition = 36
                
                self.addChild(line)
                self.pathLines += [line]
                
                u = v
                v = from.prev[v.id]!
            }
            
            let line = SKShapeNode()
            line.lineWidth = CGFloat(min(u.bandwidth, v.bandwidth)*2)
            line.strokeColor = SKColor.yellow
            
            let path = CGMutablePath()
            path.move(to: u.position)
//            CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
            path.addLine(to: v.position)
//            CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
            line.path = path
            line.zPosition = 36
            
            self.addChild(line)
            self.pathLines += [line]
            
        } else {
            print ("Couldn't draw path")
        }
    }
    
    func calculateDijkstra(from: Node, to: Node, mode:DijkstraMode) {
        self.from = from
        self.to = to
        self.calculatingDijkstra = true
        self.modeDijkstra = mode
    }

}
