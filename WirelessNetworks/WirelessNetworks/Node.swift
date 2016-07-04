//
//  Node.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/4/16.
//  Copyright © 2016 renangreca. All rights reserved.
//

import Foundation
import SpriteKit

class Node: Equatable {
    let id:String
    var position:CGPoint
    let range:CGFloat
    let circle:SKShapeNode //SKSpriteNode
    let rangeCircle:SKShapeNode
    let text:SKLabelNode
    
    var dist = [String: Double]()
    var prev = [String: Node]()
    
    init(x: CGFloat, y: CGFloat, label:String, range:CGFloat?) {
        self.id = label
        if let r = range {
            self.range = r
        } else {
            self.range = 150
        }
        
        circle = SKShapeNode(circleOfRadius: 10) //SKSpriteNode(imageNamed: "network_wireless")
        circle.fillColor = SKColor.blueColor()
        circle.name = "circle:\(label)"
        rangeCircle = SKShapeNode(circleOfRadius: self.range)
        rangeCircle.fillColor = SKColor.blueColor()
        rangeCircle.alpha = 0.2

        text = SKLabelNode(text: label)
        text.fontName = "San Francisco"
        text.fontColor = SKColor.blackColor()
            
//             Text(string: label, fontSize: 32.0, fontName: "San Francisco", color: .black)
        
        position = CGPoint(x: x, y: y)
        self.update()
        
        
//            Color(colorLiteralRed: 0, green: 0, blue: 255, alpha: 0.2)
    }
    
    func update() {
        circle.position = position
        rangeCircle.position = position
        text.position = position
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
    
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.equals(rhs)
}
