//
//  FightScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//

import SpriteKit

class FightScene: SKScene {
    
    var level = LevelScene()
    var playerNode = SKNode()
    var enemyNode = SKNode()
    
    var player = Player()
    var enemy = Enemy(x: 0, y: 0, playerLevel: 0)
    
    var close = SKAction()
    
    override func didMoveToView(view: SKView) {
        close = SKAction.runBlock({
            // Fade it out, and run the appropriate post-battle stuff
            let transition = SKTransition.fadeWithDuration(1)
            self.level.justGotBack = true
            self.level.player.awardBonuses()
            self.scene!.view?.presentScene(self.level, transition: transition)
        })
        
        playerNode = self.childNodeWithName("Player")!
        enemyNode = self.childNodeWithName("Enemy")!
        
        let spin = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-2 * M_PI), duration: 4))
        playerNode.runAction(spin)
        enemyNode.runAction(spin)
        
        let playerHealth = self.childNodeWithName("Player Health") as! SKLabelNode
        let enemyHealth = self.childNodeWithName("Enemy Health") as! SKLabelNode
        let playerLevel = self.childNodeWithName("Player Level") as! SKLabelNode
        let enemyLevel = self.childNodeWithName("Enemy Level") as! SKLabelNode
        
        playerHealth.text = "Health: \(player.health)"
        enemyHealth.text = "Health: \(enemy.health)"
        playerLevel.text = "Level: \(Int(floor(player.level)))"
        enemyLevel.text = "Level: \(Int(floor(enemy.level)))"
        //self.runAction(SKAction.sequence([SKAction.waitForDuration(3), close]))
    }
    
    override func update(currentTime: CFTimeInterval) {
        1
    }
}
