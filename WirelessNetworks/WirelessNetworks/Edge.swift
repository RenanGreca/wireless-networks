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
    
    let line = SKShapeNode()
    
    init(u:Node, v:Node) {
        self.u = u
        self.v = v
        // The connection width is the lesser of the two bandwidths
        self.w = min(u.bandwidth, v.bandwidth)
        
        line.lineWidth = CGFloat(w*2)
        self.update()

    }
    
    func update() {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, u.position.x, u.position.y)
        CGPathAddLineToPoint(path, nil, v.position.x, v.position.y)
        line.path = path
        line.zPosition = 35
    }
    
    var length: CGFloat {
        let x = self.u.position.x - self.v.position.x
        let y = self.u.position.y - self.v.position.y
        let z = x*x + y*y
        return sqrt(z)
    }
    
    func equals(another: Edge) -> Bool {
        return (self.u == another.u && self.v == another.v) || (self.u == another.v && self.v == another.u)
    }
    
    func exists(inArray: [Edge]) -> Bool {
        for e in inArray {
            if (self.v == e.v && self.u == e.u) ||
                (self.v == e.u && self.u == e.v) {
                return true
            }
        }
        return false
    }
    
}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.equals(rhs)
}
