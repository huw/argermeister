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
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    var node: GKGraphNode2D = GKGraphNode2D(point: vector_float2(0, 0))
    
    init() {
        super.init(texture: nil, color: SKColor.yellowColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: 0, y: 0)
        
        /**
            Physics setup. We build this object a _body_, which is basically
            a representation of it in physical computational space. The game
            simulates physical reactions on that body depending on what we
            tell it to do, and then that body's rotation and position are
            applied to its representation in the visual space.
        **/
        
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func act(keys: [String: Bool]) {
        
        // Neat thing: Only change the grid position if we're moving
        if physicsBody?.velocity != CGVectorMake(0, 0) {
            let x = Float(self.position.x)
            let y = Float(self.position.y)
            node.position = vector_float2(x, y)
        }
            
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