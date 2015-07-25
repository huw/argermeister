//
//  GameScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var map: [[Tile]] = [[Tile]]()
    var player = Player()
    
    var map_size = 10
    
    override func didMoveToView(view: SKView) {
        map = buildMap("map")
        
        // Build a camera, and add it to the scene
        let newCamera = SKCameraNode()
        self.camera = newCamera
        self.addChild(newCamera)
        
        // Add the current player to the scene
        self.addChild(player)
        
        // Set the background colour
        self.backgroundColor = SKColor.blackColor()
    }
    
    override func mouseDown(theEvent: NSEvent) {
    }
    
    override func keyDown(e: NSEvent) {
        switch e.characters! {
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
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding).componentsSeparatedByString("\n")
        
        var map: [[Tile]] = []
        
        for y in 0...map_size - 1 {
            
            // Add a new row
            map.append([])
            
            for x in 0...map_size - 1 {
                
                let data = text[y * map_size + x].componentsSeparatedByString("|")
                
                var wall = false
                if data[3] == "True" {
                    wall = true
                }
                
                // Add the tile to the map, and scene
                map[y].append(Tile(x: x, y: y, type: data[2], wall: wall, item: data[4]))
                self.addChild(map[y][x])
            }
        }
        
        return map
    }
}
