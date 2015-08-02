//
//  AppDelegate.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let scene = LevelScene(size: CGSize(width: 1024, height: 768))
        
        // Aspect fill produces the best results
        scene.scaleMode = .AspectFill
        
        self.skView!.presentScene(scene)
        
        // We don't care about the sibling order, so improve performance
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
