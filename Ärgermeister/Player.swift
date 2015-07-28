//
//  Player.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-23.
//  Copyright © 2015 Huw. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Player: SKSpriteNode {
    
    var moving = false
    let agent: GKAgent2D = GKAgent2D()
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    
    init() {
        super.init(texture: nil, color: SKColor.yellowColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: 0, y: 0)
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        body.categoryBitMask = BodyType.player.rawValue
        
        // Must be true for collisions, gravity must be false so it doesn't fall
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        // Only physically collide with this type
        body.collisionBitMask = BodyType.wall.rawValue
        
        // Send a notification that it's touched this type
        body.contactTestBitMask = BodyType.enemy.rawValue
        
        self.physicsBody = body
        
        // The 'agent' is a computational node which I've set to
        // directly follow the player.
        // The player's agent isn't as exciting, but enemy agents
        // can be set to head to/avoid it.
        agent.radius = 30
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        // Bind the agent's position to our position
        agent.position = vector_float2(x: Float(position.x), y: Float(position.y))
    }
    
    func act(keys: [String: Bool]) {
        
        // Runs every frame. When a key is detected as pressed,
        // then we set its velocity to the appropriate direction.
        for (key, pressed) in keys {
            if pressed {
                switch key {
                    case "w":
                        self.dy = 100
                    case "a":
                        self.dx = -100
                    case "s":
                        self.dy = -100
                    case "d":
                        self.dx = 100
                    default:
                        1
                }
            }
        }
        
        // If we're moving diagonally, then _both_ values
        // will be non-zero
        if dy != 0 && dx != 0 {
            
            // The value in each direction should be 100^2 / 2,
            // according to Pythagoras' theorum
            let val = CGFloat(70.71067812)
            
            // Then set the values to the appropriate value,
            // depending on positive or negative direction.
            if dy > 0 {
                dy = val
            } else {
                dy = -val
            }
            
            if dx > 0 {
                dx = val
            } else {
                dx = -val
            }
        }
        
        // Set our velocity to the appropriate vector
        self.physicsBody?.velocity = CGVectorMake(dx, dy)
    }
}