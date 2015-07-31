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

class Enemy: SKSpriteNode {
    
    var path: [GKGraphNode] = []
    var node: GKGraphNode2D = GKGraphNode2D(point: vector_float2(0, 0))
    
    init(x: Int, y: Int) {
        super.init(texture: nil, color: SKColor.redColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: x * 50, y: y * 50)
        node.position = vector_float2(Float(position.x), Float(position.y))
        
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        body.categoryBitMask = BodyType.player.rawValue
        
        // Same as Player()
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        // Only physically collide with this type
        body.collisionBitMask = BodyType.wall.rawValue
        
        self.physicsBody = body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func act() {
        if physicsBody?.velocity != CGVectorMake(0, 0) {
            let x = Float(self.position.x + 25)
            let y = Float(self.position.y + 25)
            node.position = vector_float2(x, y)
        }
        
        if path.count > 0 {
            let dest = path[1] as! GKGraphNode2D
            var dx = round(CGFloat(dest.position.x) - position.x)
            var dy = round(CGFloat(dest.position.y) - position.y)
            
            //print((dest.gridPosition.x, dest.gridPosition.y))
            //print((dx, dy))
            
            if dx < 0 {
                dx = -100
            } else if dx > 0 {
                dx = 100
            }
            
            if dy < 0 {
                dy = -100
            } else if dy > 0 {
                dy = 100
            }
            
            physicsBody?.velocity = CGVectorMake(dx, dy)
        }
    }
}