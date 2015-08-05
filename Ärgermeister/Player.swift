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
    
    var health = 100
    var maxHealth = 100
    var level: Float = 0
    
    var weapons: [String: Int] = ["Fist": 5, "Spear": 10]
    
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
    
    func awardBonuses() {
        if level + 1.23 >= ceil(level) {
            // Level up, because the XP we gain puts us past the next level
            showLabel(self, text: "LEVEL UP")
            
            // Recalculate health
            maxHealth = Int(50 * (Double(floor(level)) + 0.5) + 75)
            health += 50
        }
        level += 1.23
        
        if Float(arc4random()) / Float(UINT32_MAX) >= 0.7 {
            // 30% chance for items
            let index = Int(arc4random_uniform(UInt32(availableWeapons.count)))
            let item = availableWeapons.keys.array[index]
            let damage = availableWeapons[item]
            
            // This clause keeps our weapons dictionary limited to 4
            // We find the weapons with the lowest value, and then
            // remove it, because we don't want something so useless
            
            var lowestVal = damage
            var lowestKey: String = item
            for (key, value) in self.weapons {
                if value <= lowestVal {
                    lowestKey = key
                    lowestVal = value
                }
            }
            
            if self.weapons.count >= 4 {
                // Removes the least effective item if we're full
                self.weapons.removeValueForKey(lowestKey)
                
                if lowestKey != item {
                    // Only runs if the incoming item is replacing something
                    showLabel(self, text: "ADDED: \(item.uppercaseString)")
                    self.weapons[item] = damage
                }
            } else {
                showLabel(self, text: "ADDED: \(item.uppercaseString)")
                self.weapons[item] = damage
            }
        }
    }
}