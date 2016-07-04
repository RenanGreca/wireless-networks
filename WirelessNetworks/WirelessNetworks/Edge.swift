//
//  Edge.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/4/16.
//  Copyright © 2016 renangreca. All rights reserved.
//

import Foundation
import SpriteKit

class Edge {
    let u:Node
    let v:Node
    let w:Int
    
    let line:SKShapeNode
    
    init(u:Node, v:Node) {
        self.u = u
        self.v = v
        self.w = 1
        
        self.line = SKShapeNode()
        line.lineWidth = 10
//        line.fillColor = SKColor.greenColor()
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
        CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
        self.line.path = path

    }
    
    func equals(another: Edge) -> Bool {
        return (self.u == another.u && self.v == another.v) || (self.u == another.v && self.v == another.u)
    }
    
}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.equals(rhs)
}
