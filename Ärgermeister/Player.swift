//
//  Player.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-23.
//  Copyright © 2015 Huw. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var moving = false
    
    init() {
        super.init(texture: nil, color: SKColor.yellowColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: 0, y: 0)
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 49, height: 49))
        body.categoryBitMask = BodyType.player.rawValue
        
        // Must be true for collisions, gravity must be false so it doesn't fall
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        // Only physically collide with this type
        body.collisionBitMask = BodyType.wall.rawValue
        
        // Send a notification that it's touched this type
        //body.contactTestBitMask = BodyType.enemy.rawValue
        
        self.physicsBody = body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(x: Int, y: Int, map: [[Tile]]) {
        if moving == false {
            moving = true
            
            // Only allow a single movement at a time
            // Instead of moving the body, we give it a velocity
            // This velocity stops after a certain amount of time
            
            self.physicsBody?.velocity = CGVectorMake(CGFloat(x * 100), CGFloat(y * 100))
                
            let moveDuration = SKAction.waitForDuration(0.5)
            let stopMoving = SKAction.runBlock({
                
                // Stop moving
                self.physicsBody?.velocity = CGVectorMake(0, 0)
                
                // Round the position to the nearest 10
                self.position = CGPoint(x: round(self.position.x / 10) * 10, y: round(self.position.y / 10) * 10)
                
                // Allow a new movement
                self.moving = false
            })
            self.runAction(SKAction.sequence([moveDuration, stopMoving]))
        }
    }
}