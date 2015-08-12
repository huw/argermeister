
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

class LevelScene: SKScene, SKPhysicsContactDelegate {
    
    var map: [[Tile]] = [[Tile]]()
    var graph: GKObstacleGraph = GKObstacleGraph()
    var obstacles: [GKPolygonObstacle] = []
    var enemySpawns = [Tile]()
    
    var player = Player()
    var enemies = [Enemy]()
    
    // This number squared is the number of tiles
    var map_size = 20
    var lastUpdateTime = NSTimeInterval()
    var built = false
    var justGotBack = false
    var fightLoser = SKNode()
    
    var save = MenuScene()
    
    var keys = [
        "w": false,
        "a": false,
        "s": false,
        "d": false
    ]
    
    // Runs when the GameScene starts to display, rather than on init
    override func didMoveToView(view: SKView) {
        if built {
            // Halt the player when we return from battle
            player.dx = 0
            player.dy = 0
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            keys = ["w": false, "a": false, "s": false, "d": false]
            
            // A valiant victory! Congratulation!
            let enemy = fightLoser as! Enemy
            player.awardBonuses(enemy.weapons, enemyLevel: Int(floor(enemy.level)), saveScene: self.save)
            
            fightLoser.removeFromParent()
        } else {
            // Otherwise, we haven't built everything yet, so build everything
            build()
        }
    }
    
    func build() {
        // Reinitialise variables
        enemies = [Enemy]()
        lastUpdateTime = NSTimeInterval()
        keys = ["w": false, "a": false, "s": false, "d": false]
        
        map = buildMap("map")
        
        // Allow this class to recieve physics events
        physicsWorld.contactDelegate = self
        
        // Add the current player to the scene
        self.addChild(player)
        
        // Set the background colour
        self.backgroundColor = SKColor.blackColor()
        
        spawnEnemy()
        
        built = true
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
        
        // The clock keeps ticking while we're gone, which
        // means when we return the agent will update with
        // quite a bit of time, and jump a long way away.
        // Instead, we have a switch which will set the
        // last update time to the current time.
        
        if justGotBack {
            lastUpdateTime = currentTime
            justGotBack = false
        }
        
        if floor(currentTime) % 10 == 0 && lastUpdateTime < floor(currentTime) {
            // If the time is a multiple of 10, and it's the first time its been this time
            spawnEnemy()
        }
        
        // Update the enemy agent
        let dt = currentTime - lastUpdateTime
        
        for enemy in enemies {
            enemy.agent.updateWithDeltaTime(dt)
        }
        
        lastUpdateTime = currentTime
        
        // Temporarily add and remove nodes to find the path
        graph.connectNodeUsingObstacles(player.node)
        
        for enemy in enemies {
            graph.connectNodeUsingObstacles(enemy.node)
            enemy.act(graph.findPathFromNode(enemy.node, toNode: player.node), obstacles: obstacles)
            graph.removeNodes([enemy.node])
        }
        
        graph.removeNodes([player.node])
        
        // Center the camera on the player
        self.camera!.position = player.position
    }
    
    func spawnEnemy() {
        
        if enemies.count <= 5 {
            // 5 enemies maximum
            
            let spawnPoint = enemySpawns[Int(random(enemySpawns.count))]
            let enemy = Enemy(x: spawnPoint.position.x, y: spawnPoint.position.y, playerLevel: player.level)
            
            enemies.append(enemy)
            self.addChild(enemy)
        }
    }
    
    func buildMap(name: String) -> [[Tile]] {
        
        // Convert the file at /Resources/`name`.txt 
        // to an array with each line as a new entry
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding).componentsSeparatedByString("\n")
        
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
                
                if data[4] == "monster" {
                    // Make this an enemy spawn point
                    enemySpawns.append(tile)
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
        
        var currentEnemy: Enemy
        
        if nodeA is Enemy {
            currentEnemy = nodeA as! Enemy
        } else {
            currentEnemy = nodeB as! Enemy
        }
        
        // Set up the transition (a simple fade)
        let transition = SKTransition.fadeWithDuration(1)
        
        player.dx = 0
        player.dy = 0
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        keys = ["w": false, "a": false, "s": false, "d": false]
        
        // Set up the fight scene, and give it the callback to this scene
        let scene = FightScene(fileNamed: "FightScene")!
        scene.scaleMode = .AspectFill
        scene.level = self
        scene.player = self.player
        scene.enemy = currentEnemy
        
        self.scene!.view?.presentScene(scene, transition: transition)
    }
}
