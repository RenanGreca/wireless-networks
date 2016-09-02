//
//  AppDelegate.swift
//  WirelessNetworks
//
//  Created by Renan Greca on 7/1/16.
//  Copyright (c) 2016 renangreca. All rights reserved.
//


import Cocoa
import SpriteKit

enum DijkstraMode:String {
    case latency = "Latency"
    case bandwidth = "Bandwidth"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var dFrom: NSTextField!
    @IBOutlet weak var dTo: NSTextField!
    @IBOutlet weak var btnGo: NSButton!
    
    @IBOutlet weak var fSource: NSTextField!
    @IBOutlet weak var chkFloodFast: NSButton!
    
    @IBOutlet weak var btnLatency: NSButton!
    @IBOutlet weak var btnBandwidth: NSButton!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var scene:GameScene?
    var sourceNode:Node?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            self.skView!.presentScene(scene)
            self.skView!.ignoresSiblingOrder = true
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
            self.skView!.showsDrawCount = true
            self.scene = scene
            
        }
    }
    
    // Calculates dijkstra path for two nodes
    @IBAction func calculateDijkstra(sender: AnyObject) {
        guard self.scene != nil else { print("No GameScene"); return }
        
        let idFrom = Int(self.dFrom.stringValue)!
        let idTo = Int(self.dTo.stringValue)!
        
        if let from = scene!.graph?.nodes[idFrom], to = scene!.graph?.nodes[idTo] {
            if btnLatency.state == NSOnState {
                scene?.calculateDijkstra(from, to: to, mode: .latency)
            } else if btnBandwidth.state == NSOnState {
                scene?.calculateDijkstra(from, to: to, mode: .bandwidth)
            }
        } else {
            print("Incorrect node IDs")
        }
    }
    
    @IBAction func didPushLatency(sender: AnyObject) {
        if btnLatency.state == NSOnState {
            btnBandwidth.state = NSOffState
        }
    }
    
    @IBAction func didPushBandwidth(sender: AnyObject) {
        if btnBandwidth.state == NSOnState {
            btnLatency.state = NSOffState
        }
    }
    
    // Sends flood signal for certain node
    @IBAction func flood(sender: AnyObject) {
        guard self.scene != nil else { print("No GameScene"); return }
        
        let idSource = Int(self.fSource.stringValue)!
        
        if let source = scene!.graph?.nodes[idSource] {
            self.scene?.flooding = true
            self.scene?.source = source
            source.flood()
            print(source.routes)
            self.sourceNode = source
            self.tableView.reloadData()
        } else {
            print("Incorrect node IDs")
        }
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let node = sourceNode {
            print(node.routes.count)
            return node.routes.count
        } else {
            return 0
        }
    }
    
    // Fills tableView
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        var text:String = ""
        
        guard let _ = sourceNode else {
            return nil
        }
        
        let key = Array(sourceNode!.routes.keys).sort()[row]
        
        if let route = sourceNode!.routes[key] {
        
            // Node ID
            if tableColumn == tableView.tableColumns[0] {
                text = "\(key)"
            // Next Node
            } else if tableColumn == tableView.tableColumns[1] {
                text = "\(route.0)"
            // Distance
            } else if tableColumn == tableView.tableColumns[2] {
                text = "\(route.1)"
            } else if tableColumn == tableView.tableColumns[3] {
                text = "\(route.2)"
            }
            
        }
        
        return text
    }
    

}
