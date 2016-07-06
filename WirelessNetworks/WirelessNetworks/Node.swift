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
    let id:String
    var position:CGPoint
    let range:CGFloat
    let circle:SKShapeNode //SKSpriteNode
    let rangeCircle:SKShapeNode
    let text:SKLabelNode
    
    var dist = [String: Double]()
    var prev = [String: Node]()
    
//    var neighbors = [String: Node]()
    var edges = [Edge]()
    
    init(x: CGFloat, y: CGFloat, label:String, range:CGFloat?) {
        self.id = label
        if let r = range {
            self.range = r
        } else {
            self.range = 150
        }
        
        circle = SKShapeNode(circleOfRadius: 15) //SKSpriteNode(imageNamed: "network_wireless")
        circle.fillColor = SKColor.blueColor()
//        circle.strokeColor = SKColor.blackColor()
        circle.name = "circle:\(label)"
        circle.zPosition = 45
        
        rangeCircle = SKShapeNode(circleOfRadius: self.range)
        rangeCircle.fillColor = SKColor.blueColor()
        rangeCircle.alpha = 0.2
        rangeCircle.zPosition = 30

        text = SKLabelNode(text: label)
        text.fontName = "San Francisco"
        text.fontSize = 20
        text.fontColor = SKColor.whiteColor()
        text.zPosition = 50
            
//             Text(string: label, fontSize: 32.0, fontName: "San Francisco", color: .black)
        
        position = CGPoint(x: x, y: y)
        self.update()
        
        
//            Color(colorLiteralRed: 0, green: 0, blue: 255, alpha: 0.2)
    }
    
    func update() {
        circle.position = position
        rangeCircle.position = position
        text.position = CGPoint(x:position.x, y:position.y-7)
    }
    
    func inRange(node:Node) -> Bool {
        return self.euclidianDistance(node.position) <= self.range
//        if  {
//            let line =  (start: self.point, end: node.point)
//            return true
//        }
//        return false
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
    
    func send(message: Message, to: Node) {
        to.receive(message, from: self)
    }
    
    func receive(message: Message, from: Node) {
        switch message {
        case .flood:
            // continue flooding algorithm
//            self.neighbors[from.id] = from
//            self.edges += [Edge(u: self, v: from)]
            self.send(.reply, to: from)
            break
        case .reply:
//            self.neighbors[from.id] = from
            let e = Edge(u: self, v: from)
            self.edges += [e]
        }
    }
    
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.equals(rhs)
}
