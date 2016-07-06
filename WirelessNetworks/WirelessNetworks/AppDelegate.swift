//
//  AppDelegate.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/1/16.
//  Copyright (c) 2016 renangreca. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var dFrom: NSTextField!
    @IBOutlet weak var dTo: NSTextField!
    @IBOutlet weak var btnGo: NSButton!
    
//    @IBOutlet weak var sFrom: NSPopUpButton!
//    @IBOutlet weak var sTo: NSPopUpButton!
    
    var scene:GameScene?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
            
            self.scene = scene
            
//            sFrom.addItemsWithTitles([String](scene.graph!.nodes.keys))
//            sTo.addItemsWithTitles([String](scene.graph!.nodes.keys))
        }
    }
    
    @IBAction func calculateDijkstra(sender: AnyObject) {
        guard self.scene != nil else { print("No GameScene"); return }
        
        let idFrom = self.dFrom.stringValue
        let idTo = self.dTo.stringValue
        
        if let from = scene!.graph?.nodes[idFrom], to = scene!.graph?.nodes[idTo] {
            scene?.calculateDijkstra(from, to: to)
        } else {
            print("Incorrect node IDs")
        }
    }
    
    @IBAction func flood(sender: AnyObject) {
        guard self.scene != nil else { print("No GameScene"); return }
        
        self.scene?.graph?.edges = [Edge]()
        self.scene?.graph?.flood(scene!.graph!.nodes["0"]!, explored:[])
    }
    
    func updateSelectors(node: Node) {
//        sFrom.addItemWithTitle(node.id)
//        sTo.addItemWithTitle(node.id)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
