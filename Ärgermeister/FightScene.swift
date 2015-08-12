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
    var playerNode = SKSpriteNode()
    var enemyNode = SKSpriteNode()
    
    var playerDetails: SKLabelNode = SKLabelNode()
    var enemyDetails: SKLabelNode = SKLabelNode()
    var potions: SKLabelNode = SKLabelNode()
    var weapons: [SKLabelNode] = []
    
    var player = Player()
    var enemy = Enemy(x: 0, y: 0, playerLevel: 0)
    
    var closeToLevel = SKAction()
    var closeToMenu = SKAction()
    var buttonsEnabled = true
    
    override func didMoveToView(view: SKView) {
        closeToLevel = SKAction.runBlock({
            // Fade it out, and run the appropriate post-battle stuff
            let transition = SKTransition.fadeWithDuration(1)
            self.level.justGotBack = true
            self.scene!.view?.presentScene(self.level, transition: transition)
        })
        
        closeToMenu = SKAction.runBlock({
            // Fade it out, and run the appropriate post-battle stuff
            let transition = SKTransition.fadeWithDuration(1)
            let scene = MenuScene(fileNamed: "MenuScene")!
            scene.scaleMode = .AspectFill
            self.scene!.view?.presentScene(scene, transition: transition)
        })
        
        playerNode = self.childNodeWithName("Player") as! SKSpriteNode
        enemyNode = self.childNodeWithName("Enemy") as! SKSpriteNode
        
        playerNode.color = player.color
        enemyNode.color = enemy.color
        
        let spin = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-2 * M_PI), duration: 4))
        playerNode.runAction(spin)
        enemyNode.runAction(spin)
        
        playerDetails = self.childNodeWithName("Player Details") as! SKLabelNode
        enemyDetails = self.childNodeWithName("Enemy Details") as! SKLabelNode
        
        potions = self.childNodeWithName("Item 1") as! SKLabelNode
        potions.text = "Health Potion x\(player.potions)"
        
        weapons.append(self.childNodeWithName("Weapon 1") as! SKLabelNode)
        weapons.append(self.childNodeWithName("Weapon 2") as! SKLabelNode)
        weapons.append(self.childNodeWithName("Weapon 3") as! SKLabelNode)
        weapons.append(self.childNodeWithName("Weapon 4") as! SKLabelNode)
        
        let weaponData = player.weapons.keys.array
        for i in 0...weaponData.count - 1 {
            weapons[i].text = weaponData[i]
            weapons[i].name = weapons[i].text
        }
        
        for weapon in weapons {
            
            let name = weapon.name!
            
            // Swift substrining is confused and complex, this is easier
            if name == "Weapon 4" || name == "Weapon 3" || name == "Weapon 2" || name == "Weapon 1" {
                
                // If there's less than 4 weapons with the player,
                // then the SKLabelNode's `name` property won't get
                // changed. So if it starts with "Weapon" (unchanged)
                // then remove it from the parent
                
                weapons.removeAtIndex(weapons.indexOf(weapon)!)
                weapon.removeFromParent()
            }
        }
        
        playerDetails.text = "Level: \(Int(floor(player.level))) Health: \(player.health)"
        enemyDetails.text = "Level: \(Int(floor(enemy.level))) Health: \(enemy.health)"
    }
    
    override func mouseDown(e: NSEvent) {
        let pos = e.locationInNode(self)
        
        if let option = self.nodeAtPoint(pos).name {
            if buttonsEnabled {
                if availableWeapons.keys.array.contains(option) {
                    // Disable the buttons
                    changeButtonState()
                    
                    // The node we clicked on is definitely an available weapon
                    let playerDamage = availableWeapons[option]!
                    let enemyWeapon = enemy.weapons.keys.array[Int(random(enemy.weapons.count))]
                    let enemyDamage = availableWeapons[enemyWeapon]!
                    
                    if enemy.speed >= player.speed {
                        
                        // Enemy attacks first
                        if !attackPlayer(enemyDamage) {
                            attackEnemy(playerDamage)
                        }
                    } else {
                        
                        // If the speeds are equal, let the enemy attack first
                        // This isn't a forgiving game
                        if !attackEnemy(playerDamage) {
                            attackPlayer(enemyDamage)
                        }
                    }
                    
                    // The damage thing takes a second, so wait for the animation
                    // to finish before re-enabling the buttons.
                    changeButtonState()
                    
                } else if option == "Item 1" && player.potions >= 0 && player.health + 35 <= player.maxHealth  {
                    player.health += 35
                    player.potions -= 1
                    potions.text = "Health Potion x\(player.potions)"
                    
                    changeButtonState()
                    
                    if player.potions <= 0 {
                        // Fade out and disable
                        potions.runAction(SKAction.fadeAlphaTo(0.3, duration: 0.2))
                    }
                    
                    changeButtonState()
                    
                    // Enemy still attacks
                    let enemyWeapon = enemy.weapons.keys.array[Int(random(enemy.weapons.count))]
                    let enemyDamage = availableWeapons[enemyWeapon]!
                    attackPlayer(enemyDamage)
                }
            }
        }
    }
    
    func changeButtonState() {
        if self.buttonsEnabled {
            // Fade out each weapon button
            for weapon in weapons {
                weapon.runAction(SKAction.fadeAlphaTo(0.3, duration: 0.1))
            }
            
            // Fade out the potions button
            potions.runAction(SKAction.fadeAlphaTo(0.3, duration: 0.2))
            
            // Set the buttonsEnabled flag to false
            self.buttonsEnabled = false
        } else {
            // Wait a second, then do the reverse
            self.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({
                for weapon in self.weapons {
                    weapon.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                }
                self.potions.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                self.buttonsEnabled = true
            })]))
        }
    }
    
    func showDamage(node: SKNode, damage: Int) {
        // Similar to showLabel(), but customised to show inflicted damage
        let label = SKLabelNode(text: "\(damage)")
        label.fontName = "Helvetica Neue Bold"
        label.fontSize = 16 + CGFloat(floor((Float(-damage)))) // scale font with damage
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.position = CGPoint(x: node.position.x, y: node.position.y + 40)
        label.alpha = 0.0
        label.color = SKColor.redColor()
        label.colorBlendFactor = 1
        
        if damage > 0 {
            label.text = "+\(damage)"
            label.fontSize = 16 + CGFloat(floor((Float(damage))))
        } else if damage == 0 {
            label.text = "MISS"
        }
        
        // waitForPrevious counts how many of these are stacked up,
        // and waits until all of them are done
        let waitForPrevious = SKAction.waitForDuration(1.05 * Double(node.children.count))
        let fadeIn = SKAction.fadeInWithDuration(0.05)
        let moveUpAndFade = SKAction.group([SKAction.moveByX(0, y: 50, duration: 1), SKAction.fadeOutWithDuration(1)])
        
        self.addChild(label)
        label.runAction(SKAction.sequence([waitForPrevious, fadeIn, moveUpAndFade, SKAction.removeFromParent()]))
    }
    
    func attackPlayer(var damage: Int) -> Bool {
        
        if player.defence > enemy.defence * 2 {
            
            // If the enemy is particularly weak, then allow
            // the player to counteract a lot of the damage
            
            damage = Int(random(damage / 2)) + Int(damage / 4)
        } else if player.defence > damage * 2 {
            
            // If the player has a strong defence,
            // make the damage a value between half-strength
            // and full-strength
            
            damage = Int(random(damage / 2)) + Int(damage / 2)
        } else if player.defence < damage && random() > 0.7 {
            
            // If the player is really weak,
            // and our random chance is high,
            // make this a critical hit
            
            damage = Int(Float(damage) * 1.5)
        }
        
        player.health -= damage
        showDamage(playerNode, damage: -damage)
        
        var dead = false
        
        // End the scene is there is a death
        if player.health <= 0 {
            player.health = 0
            
            die(player, node: playerNode)
            dead = true
        }
        
        playerDetails.text = "Level: \(Int(floor(player.level))) Health: \(player.health)"
        
        return dead
    }
    
    func attackEnemy(var damage: Int) -> Bool {
        
        if enemy.defence > player.defence * 2 {
            
            // If the enemy is particularly strong,
            // then it can mitigate some of the damage
            
            damage = Int(random(damage / 2)) + Int(damage / 4)
        } else if enemy.defence > damage * 2 && random() > 0.6 {
            
            // If the enemy has a strong defence,
            // randomise the damage on a critical chance
            
            damage = Int(random(damage)) + Int(damage / 2)
        } else if enemy.defence < damage && random() > 0.7 {
            
            // If the player is really weak,
            // and our random chance is high,
            // make this a critical hit
            
            damage = Int(Float(damage) * 1.5)
        }
        
        enemy.health -= damage
        showDamage(enemyNode, damage: -damage)
        
        var dead = false
        
        // End the scene is there is a death
        if enemy.health <= 0 {
            enemy.health = 0
            
            die(enemy, node: enemyNode)
            dead = true
        }
        
        enemyDetails.text = "Level: \(Int(floor(enemy.level))) Health: \(enemy.health)"
        
        return dead
    }
    
    func die(entity: SKNode, node: SKNode) {
        node.removeAllActions()
        let rotateAndDie = SKAction.sequence([SKAction.group([SKAction.rotateToAngle(0, duration: 1), SKAction.scaleTo(0, duration: 1)]), SKAction.runBlock({
            
            if entity is Enemy {
                
                // If the enemy dies, return us to the battlefields, victorious
                self.level.fightLoser = entity
                self.runAction(self.closeToLevel)
            } else if entity is Player {
                
                // If the player dies, go back to the menu, defeated
                self.runAction(self.closeToMenu)
            }
            
        })])
        node.runAction(rotateAndDie)
    }
}
