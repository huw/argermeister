//
//  MenuScene.swift
//  Ärgermeister
//
//  Created by Huw on 2015-08-09.
//  Copyright © 2015 Huw. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var characters: [Player] = []
    
    var character1 = SKSpriteNode()
    var character2 = SKSpriteNode()
    var character3 = SKSpriteNode()
    
    var selectedCharacter = 0
    
    let spin = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-2 * M_PI), duration: 4))
    
    override func didMoveToView(view: SKView) {
        
        setLabels()
        
        character1.runAction(spin)
    }
    
    override func keyDown(e: NSEvent) {
        let key: NSString = e.charactersIgnoringModifiers!
        
        if key == "a" {
            // Check the currently selected character to make sure
            // we don't move over the edge of the screen
            
            if selectedCharacter - 1 >= 0 {
                selectedCharacter--
            } else {
                selectedCharacter = 2
            }
            
            changeSpin(selectedCharacter)
            
        } else if key == "d" {
            
            if selectedCharacter + 1 <= 2 {
                selectedCharacter++
            } else {
                selectedCharacter = 0
            }
            
            changeSpin(selectedCharacter)
        }
    }
    
    func setLabels() {
        character1 = self.childNodeWithName("Character 1") as! SKSpriteNode
        let name1 = self.childNodeWithName("Name Label 1") as! SKLabelNode
        let level1 = self.childNodeWithName("Level Label 1") as! SKLabelNode
        let health1 = self.childNodeWithName("Health Label 1") as! SKLabelNode
        let speed1 = self.childNodeWithName("Speed Label 1") as! SKLabelNode
        let defence1 = self.childNodeWithName("Defence Label 1") as! SKLabelNode
        
        character2 = self.childNodeWithName("Character 2") as! SKSpriteNode
        let name2 = self.childNodeWithName("Name Label 2") as! SKLabelNode
        let level2 = self.childNodeWithName("Level Label 2") as! SKLabelNode
        let health2 = self.childNodeWithName("Health Label 2") as! SKLabelNode
        let speed2 = self.childNodeWithName("Speed Label 2") as! SKLabelNode
        let defence2 = self.childNodeWithName("Defence Label 2") as! SKLabelNode
        
        character3 = self.childNodeWithName("Character 3") as! SKSpriteNode
        let name3 = self.childNodeWithName("Name Label 3") as! SKLabelNode
        let level3 = self.childNodeWithName("Level Label 3") as! SKLabelNode
        let health3 = self.childNodeWithName("Health Label 3") as! SKLabelNode
        let speed3 = self.childNodeWithName("Speed Label 3") as! SKLabelNode
        let defence3 = self.childNodeWithName("Defence Label 3") as! SKLabelNode
        
        if characters.count >= 1 {
            let current = characters[0]
            character1.color = current.color
            name1.text = current.name
            level1.text = "\(floor(current.level))"
            health1.text = "\(current.maxHealth)"
            speed1.text = "\(current.attackSpeed)"
            defence1.text = "\(current.defence)"
            
            if characters.count >= 2 {
                let current = characters[1]
                character2.color = current.color
                name2.text = current.name
                level2.text = "\(floor(current.level))"
                health2.text = "\(current.maxHealth)"
                speed2.text = "\(current.attackSpeed)"
                defence2.text = "\(current.defence)"
                
                if characters.count >= 3 {
                    let current = characters[2]
                    character3.color = current.color
                    name3.text = current.name
                    level3.text = "\(floor(current.level))"
                    health3.text = "\(current.maxHealth)"
                    speed3.text = "\(current.attackSpeed)"
                    defence3.text = "\(current.defence)"
                }
            }
        }
    }
    
    func changeSpin(selected: Int) {
        if selected == 0 {
            character2.removeAllActions()
            character3.removeAllActions()
            character2.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            character3.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            
            character1.runAction(spin)
        } else if selected == 1 {
            character3.removeAllActions()
            character1.removeAllActions()
            character3.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            character1.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            
            character2.runAction(spin)
        } else if selected == 2 {
            character1.removeAllActions()
            character2.removeAllActions()
            character1.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            character2.runAction(SKAction.rotateToAngle(0, duration: 0.3))
            
            character3.runAction(spin)
        }
    }
}
