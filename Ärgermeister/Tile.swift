//
//  Tile.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-23.
//  Copyright © 2015 Huw. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKSpriteNode {
    
    var type: String
    var wall: Bool
    var item: String
    
    var width = 50
    var colours = [
        "grass": SKColor.greenColor(),
        "mountain": SKColor.darkGrayColor(),
        "water": SKColor.blueColor(),
        "lava": SKColor.orangeColor(),
        "forest": SKColor(red: 0.2, green: 1, blue: 0.2, alpha: 1),
        "void": SKColor.clearColor()
    ]
    
    init(x: Int, y: Int, type: String, wall: Bool, item: String) {
        self.type = type
        self.wall = wall
        self.item = item
        
        super.init(texture: nil, color: colours[type]!, size: CGSize(width: self.width, height: self.width))
        
        self.position = CGPoint(x: x * width, y: y * width)
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        body.dynamic = false
        
        // Only set up collisions if it's a wall:
        // The categoryBitMask effectively sets its category as an object,
        // so that we know what collides with it. If it's 'wall', then
        // it collides with the player and enemy, but if it's 'tile',
        // then we consider it part of the background.
        
        if wall {
            body.categoryBitMask = BodyType.wall.rawValue
        } else {
            body.categoryBitMask = BodyType.tile.rawValue
        }
        
        self.physicsBody = body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}