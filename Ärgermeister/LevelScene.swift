//
//  GameScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//

import SpriteKit
import GameplayKit
import Darwin // Mathematical functions

enum BodyType: UInt32 {
    case player = 1
    case wall = 2
    case tile = 4
    case enemy = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var map: [[Tile]] = [[Tile]]()
    var graph: GKObstacleGraph = GKObstacleGraph()
    var obstacles: [GKPolygonObstacle] = []
    
    var player = Player()
    var enemy = Enemy(x: 5, y: 3)
    
    // This number squared is the number of tiles
    var map_size = 10
    var lastUpdateTime = NSTimeInterval()
    
    var keys = [
        "w": false,
        "a": false,
        "s": false,
        "d": false
    ]
    
    // Runs when the GameScene starts to display, rather than on init
    override func didMoveToView(view: SKView) {
        build()
    }
    
    func build() {
        // Reinitialise variables
        map = [[Tile]]()
        player = Player()
        enemy = Enemy(x: 5, y: 3)
        map_size = 10
        lastUpdateTime = NSTimeInterval()
        keys = ["w": false, "a": false, "s": false, "d": false]
        
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
        
        self.addChild(enemy)
    }
    
    override func keyDown(e: NSEvent) {
        
        // When a key is held down in OS X, there is a short delay,
        // and then the operating system will send a lot of repeated key events
        // (depending on the appropriate settings in System Preferences).
        // All we want is the current _state_ of the key,
        // so we hold that as a Bool in a dictionary.
        // When it gets pressed, we set it to true, and when it's unpressed,
        // we set it to false. Easy.
        
        let key = e.charactersIgnoringModifiers!
        if keys[key] != nil {
            keys[key] = true
        }
    }
    
    override func keyUp(e: NSEvent) {
        let key = e.charactersIgnoringModifiers!
        
        // The key release event only happens once, though.
        // This means we can actually fire events with it,
        // so let's _both_ update our key dictionary, and
        // also reset the movement of the player.
        switch key {
            case "w", "s":
                player.dy = 0
            case "a", "d":
                player.dx = 0
            default: 1
        }
        
        if keys[key] != nil {
            keys[key] = false
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // Make the player act on the appropriate keypress
        player.act(keys)
        
        // Update the enemy agent
        let dt = currentTime - lastUpdateTime
        enemy.agent.updateWithDeltaTime(dt)
        lastUpdateTime = currentTime
        
        // Temporarily add and remove nodes to find the path
        graph.connectNodeUsingObstacles(player.node)
        graph.connectNodeUsingObstacles(enemy.node)
        enemy.act(graph.findPathFromNode(enemy.node, toNode: player.node), obstacles: obstacles)
        graph.removeNodes([player.node, enemy.node])
        
        // Center the camera on the player
        self.camera!.position = player.position
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
        var obstacleTiles: [Tile] = []
        
        for y in 0...map_size - 1 {
            
            // Add a new row
            map.append([])
            
            for x in 0...map_size - 1 {
                
                // Split the line into an array
                let data = text[y * map_size + x].componentsSeparatedByString("|")
                
                // Read in the text file's Boolean format properly
                // Note: We invert the bit because the original label is 'passable'
                var wall = false
                if data[3] == "False" {
                    wall = true
                }
                
                let tile = Tile(x: x, y: y, type: data[2], wall: wall, item: data[4])
                
                // Add the tile to the map, and scene
                map[y].append(tile)
                
                if wall {
                    // See the explainer below for GKGrids
                    obstacleTiles.append(tile)
                }
                
                self.addChild(map[y][x])
            }
        }
        
        // Surround the world in void objects
        for y in 0...map_size + 1 {
            for x in [-1, map_size] {
                let tile = Tile(x: x, y: y - 1, type: "void", wall: true, item: "none")
                obstacleTiles.append(tile)
                self.addChild(tile)
            }
            
            if y == 0 || y == map_size + 1 {
                for x in 0...map_size - 1 {
                    let tile = Tile(x: x, y: y - 1, type: "void", wall: true, item: "none")
                    obstacleTiles.append(tile)
                    self.addChild(tile)
                }
            }
        }
        
        // The GKGridGraph is a matrix of data points which represent our map
        // in computational space. It's pretty much binary: Each node is either
        // empty or filled, and the grid contains all of them.
        // Apple let us use this grid for pathfinding. An entity can be given a
        // list of nodes it has to visit on its journey to get to a node,
        // automatically avoiding any collisions on the way. This is great.
        
        obstacles = SKNode.obstaclesFromNodePhysicsBodies(obstacleTiles)
        self.graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 10)
        
        return map
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        var currentPlayer: Player
        
        if nodeA is Player {
            currentPlayer = nodeA as! Player
        } else {
            currentPlayer = nodeB as! Player
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        self.build()
    }
}
