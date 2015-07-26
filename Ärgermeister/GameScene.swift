//
//  GameScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//

import SpriteKit
import Darwin // Mathematical functions

enum BodyType: UInt32 {
    case player = 1
    case wall = 2
    case tile = 4
    case enemy = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var map: [[Tile]] = [[Tile]]()
    var player = Player()
    
    // This number squared is the number of tiles
    var map_size = 10
    
    // Runs when the GameScene starts to display, rather than on init
    override func didMoveToView(view: SKView) {
        map = buildMap("map")
        
        // Allow this class to recieve physics events
        physicsWorld.contactDelegate = self
        
        // Build a camera, and add it to the scene
        let newCamera = SKCameraNode()
        self.camera = newCamera
        self.addChild(newCamera)
        
        // Add the current player to the scene
        self.addChild(player)
        
        // Set the background colour
        self.backgroundColor = SKColor.blackColor()
    }
    
    override func keyDown(e: NSEvent) {
        switch e.charactersIgnoringModifiers! {
            case "w":
                player.move(0, y: 1, map: map)
            case "a":
                player.move(-1, y: 0, map: map)
            case "s":
                player.move(0, y: -1, map: map)
            case "d":
                player.move(1, y: 0, map: map)
            default:
                1
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // Center the camera on the player
        self.camera!.position = self.player.position
    }
    
    func buildMap(name: String) -> [[Tile]] {
        
        // Convert the file at /Resources/`name`.txt 
        // to an array with each line as a new entry
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding).componentsSeparatedByString("\n")
        
        // If the map given is a square, then read it in
        if sqrt(Double(text.count)) % 1 == 0 {
            map_size = Int(sqrt(Double(text.count)))
        }
        
        var map: [[Tile]] = []
        
        for y in 0...map_size - 1 {
            
            // Add a new row
            map.append([])
            
            for x in 0...map_size - 1 {
                
                // Split the line into an array
                let data = text[y * map_size + x].componentsSeparatedByString("|")
                
                // Read in the text file's Boolean format properly
                // Note: We invert the bit because the original label is 'passable'
                var wall = true
                if data[3] == "True" {
                    wall = false
                }
                
                // Add the tile to the map, and scene
                map[y].append(Tile(x: x, y: y, type: data[2], wall: wall, item: data[4]))
                self.addChild(map[y][x])
            }
        }
        
        return map
    }
}
