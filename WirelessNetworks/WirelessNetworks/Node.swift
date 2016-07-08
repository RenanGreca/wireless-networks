//
//  Node.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/4/16.
//  Copyright © 2016 renangreca. All rights reserved.
//

import Foundation
import SpriteKit

enum Message {
    case flood;
    case reply;
}

class Node: Equatable {
    let id:Int
    var position:CGPoint
    let range:CGFloat
    let circle:SKShapeNode
    let rangeCircle:SKShapeNode
    let text:SKLabelNode
    var graph:Graph?
    
    var dist = [Int: Double]()
    var prev = [Int: Node]()
    
    
    init(x: CGFloat, y: CGFloat, label:Int, range:CGFloat?) {
        self.id = label
        if let r = range {
            self.range = r
        } else {
            self.range = 150
        }
        
        // prepares visual representation
        circle = SKShapeNode(circleOfRadius: 15)
        circle.fillColor = SKColor.blueColor()
        circle.name = "circle:\(label)"
        circle.zPosition = 45
        
        rangeCircle = SKShapeNode(circleOfRadius: self.range)
        rangeCircle.fillColor = SKColor.blueColor()
        rangeCircle.alpha = 0.2
        rangeCircle.zPosition = 30

        text = SKLabelNode(text: "\(label)")
        text.fontName = "San Francisco"
        text.fontSize = 20
        text.fontColor = SKColor.whiteColor()
        text.zPosition = 50
        
        position = CGPoint(x: x, y: y)
        self.update()
    
    }
    
    // Updates node position when dragged
    func update() {
        circle.position = position
        rangeCircle.position = position
        text.position = CGPoint(x:position.x, y:position.y-7)
    }
    
    func inRange(node:Node) -> Bool {
        return self.euclidianDistance(node.position) <= self.range
    }
    
    private func euclidianDistance(p:CGPoint) -> CGFloat {
        let x = p.x - self.position.x
        let y = p.y - self.position.y
        let z = x*x + y*y
        return sqrt(z)
    }
    
    func addToScene(scene: SKScene) {
        scene.addChild(self.circle)
        scene.addChild(self.rangeCircle)
        scene.addChild(self.text)
    }
        
    func equals(another: Node) -> Bool {
        return self.id == another.id
    }
    
    
    // Routing simulation functions
    var flooding = false
    var routes = [Int: (Int, CGFloat)]()

    func flood() {
        if self.flooding {
            return
        }
        
        self.flooding = true
        self.routes = [self.id:(self.id, 0)]
        
        for (_, v) in self.graph!.nodes where self.inRange(v) && v != self {
            
            let vWeight = self.euclidianDistance(v.position) //CGFloat(1.0)
            v.flood()
            
            self.routes[v.id] = (v.id, vWeight)
            
            for (node, (_, weight)) in v.routes {
                let w = weight+vWeight
                
                if let n = self.routes[node] {
                    if n.1 > w {
                        self.routes[node] = (v.id, w)
                    }
                } else {
                    self.routes[node] = (v.id, w)
                }
            }
            
            
        }
        self.flooding = false
    }

    
//    func send(message: Message, to: Node) {
//        to.receive(message, from: self)
//    }
//    
//    func receive(message: Message, from: Node) {
//        switch message {
//        case .flood:
//            // continue flooding algorithm
//            if !self.flooding {
//                self.flood()
//            }
//            self.send(.reply, to: from)
//            break
//        case .reply:
//            let e = Edge(u: self, v: from)
//            self.edges += [e]
//        }
//    }
    
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.equals(rhs)
}
