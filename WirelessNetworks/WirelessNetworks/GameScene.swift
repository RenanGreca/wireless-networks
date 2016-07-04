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
    var from: Node?
    var to: Node?
    
    override func didMoveToView(view: SKView) {
        graph = Graph(nodes: createNodes(10))
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        
        for touchedNode in self.nodesAtPoint(location) {
            if let node = touchedNode as? SKShapeNode {
                if let n = node.name {
                    
                    let name = n.characters.split {$0 == ":"}.map { String($0) }
                    if name[0] == "circle" {
                        self.selectedNode = graph!.nodes[name[1]]
                    }
                }
            }
        }
        
        if let _ = self.selectedNode {
        } else {
            
            let node = Node(x: location.x, y: location.y, label: "\(graph!.nodes.count)", range: nil)

            graph!.add(node)
            node.addToScene(self)
            
            //self.circle = circle
            self.selectedNode = node
        }

    }
    
    override func mouseDragged(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        print(location)
        
        if let node = self.selectedNode {
            print(node.id)
            node.position = location
            node.update()
        }

    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.selectedNode = nil
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.graph?.findEdges()
        
        self.removeChildrenInArray(self.lines)
        self.lines = []
        
        self.drawEdges(self.graph!.edges)
        
        if self.calculatingDijkstra {
            self.graph!.dijkstra(from!)
            self.removeChildrenInArray(self.pathLines)
            drawPath(from!, to: to!)
        }
    }
    
    func createNodes(n: Int) -> [String: Node] {
        var nodes = [String: Node]()
        let xRange = 0..<Int(self.frame.width)
        let yRange = 0..<Int(self.frame.height)
        
        for i in 0..<n {
            let x = CGFloat(Int.random(xRange))
            let y = CGFloat(Int.random(yRange))
            
            let node = Node(x:x, y:y, label: "\(i)", range:nil)
            nodes["\(i)"] = node
            
            node.addToScene(self)
        }
        
        return nodes
    }
    
    func drawEdges(edges: [Edge]) {
        for e in edges {
            self.addChild(e.line)
            self.lines += [e.line]
        }
    }
    
    
    func drawPath(from: Node, to: Node) {
        self.pathLines = []
        
        if let val = from.prev[to.id] {
            var u = to
            var v = val
            while (v != from) {
                let line = SKShapeNode()
                line.lineWidth = 10
                line.strokeColor = SKColor.yellowColor()
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
                CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
                line.path = path
                
                self.addChild(line)
                self.pathLines += [line]
                
                u = v
                v = from.prev[v.id]!
            }
            
            let line = SKShapeNode()
            line.lineWidth = 10
            line.strokeColor = SKColor.yellowColor()
            
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
            CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
            line.path = path
            
            self.addChild(line)
            self.pathLines += [line]
            
        } else {
            print ("Couldn't draw path")
        }
    }
    
    func calculateDijkstra(from: Node, to: Node) {
        self.from = from
        self.to = to
        self.calculatingDijkstra = true
    }

}