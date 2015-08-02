//
//  FightScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-07-17.
//  Copyright (c) 2015 Huw. All rights reserved.
//

import SpriteKit

class FightScene: SKScene {
    
    var level: LevelScene = LevelScene()
    
    override func didMoveToView(view: SKView) {
        self.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.runBlock({
            let transition = SKTransition.fadeWithDuration(1)
            self.level.justGotBack = true
            self.scene!.view?.presentScene(self.level, transition: transition)
        })]))
    }
    
    override func update(currentTime: CFTimeInterval) {
        1
    }
}
