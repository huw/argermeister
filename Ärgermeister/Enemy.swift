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

class Enemy: SKSpriteNode, GKAgentDelegate {
    
    let agent: GKAgent2D = GKAgent2D()
    
    init(x: Int, y: Int) {
        super.init(texture: nil, color: SKColor.redColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: CGFloat(x * 50), y: CGFloat(y * 50))
        
        // Init Physics Body
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 49.3, height: 49.3))
        body.categoryBitMask = BodyType.player.rawValue
        
        // Same as Player()
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        // Only physically collide with this type
        body.collisionBitMask = BodyType.wall.rawValue
        
        self.physicsBody = body
        
        // Init Gameplay Agent
        agent.position = vector_float2(x: Float(position.x), y: Float(position.y))
        agent.radius = 49.3
        agent.delegate = self
        agent.maxSpeed = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetMove() {
        self.removeAllActions()
        self.position = CGPoint(x: round(self.position.x / 10) * 10, y: round(self.position.y / 10) * 10)
        self.physicsBody?.velocity = CGVectorMake(0, 0)
    }
    
    func agentWillUpdate(agent: GKAgent) {
        1
    }
    
    func agentDidUpdate(agent: GKAgent) {
        let agent2D = agent as! GKAgent2D
        self.position = CGPointMake(CGFloat(agent2D.position.x), CGFloat(agent2D.position.y))
    }
}