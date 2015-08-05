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
    
    var path2D: [GKGraphNode2D] = []
    var node: GKGraphNode2D = GKGraphNode2D(point: vector_float2(0, 0))
    
    var agent: GKAgent2D = GKAgent2D()
    
    var health = 100
    var level: Float = 0
    
    init(x: Int, y: Int, playerLevel: Float) {
        super.init(texture: nil, color: SKColor.redColor(), size: CGSize(width: 30, height: 30))
        
        self.position = CGPoint(x: x * 50, y: y * 50)
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.behavior = GKBehavior()
        agent.delegate = self
        agent.maxAcceleration = 100
        agent.maxSpeed = 100
        agent.mass = 1
        
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        body.categoryBitMask = BodyType.enemy.rawValue
        
        // Same as Player()
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        // Only physically collide with this type
        body.collisionBitMask = BodyType.wall.rawValue
        
        self.physicsBody = body
        
        // The enemy level should be 5 levels either side of the
        // player's level
        level = Float(arc4random()) / Float(UINT32_MAX) * 10 - 5 + playerLevel
        if level < 0 {
            // Limit level to positive values
            level = 1
        }
        
        // Health incrememnts in multiples of 50
        health = Int(50 * (Double(floor(level)) + 0.5) + 75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func act(path: [GKGraphNode], obstacles: [GKPolygonObstacle]) {
        path2D = []
        for item in path {
            path2D.append(item as! GKGraphNode2D)
        }
        
        agent.behavior?.removeAllGoals()
        
        // We need _three_ separate goals here
        // 1. Keep the agent moving forward when it is actually on the path it needs to be on.
        //    It's more responsible for direction than making sure the path is adhered to.
        // 2. Makes sure that the agent sticks as close to the path as possible.
        // 3. Avoid all obstacles, on top of the already found path
        
        agent.behavior?.setWeight(1, forGoal: GKGoal(toFollowPath: GKPath(graphNodes: path2D, radius: 30), maxPredictionTime: 25, forward: true))
        agent.behavior?.setWeight(1, forGoal: GKGoal(toStayOnPath: GKPath(graphNodes: path2D, radius: 30), maxPredictionTime: 25))
        //agent.behavior?.setWeight(1, forGoal: GKGoal(toAvoidObstacles: obstacles, maxPredictionTime: 25))
        
        node.position = agent.position
        self.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
    }
    
    func agentDidUpdate(agent: GKAgent) {
        1
    }
    
    func agentWillUpdate(agent: GKAgent) {
        
        // Actually one of the cleverest and counter-intuitive-est lines in the entire program:
        // The physical position will never be inside of a wall, so to stop the agent from
        // finding itself inside a wall, we have to set its position to the physical position,
        // __before__ the agent updates. Thank you Apple for pointing this one out.
        
        self.agent.position = vector_float2(Float(position.x), Float(position.y))
    }
}