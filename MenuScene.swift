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
    
    func save() {
        
        // Saving the characters is done through very few, very simple
        // lines of code. These ones save the 'characters' variable in
        // the `NSUserDefaults` archive. Were you to scroll below, you
        // would notice that we do the reverse when loading. Elsewhere
        // (in Player()), we save the things we want to preserve using
        // NSCoder, which encodes them into a saveable format that can
        // be safely stored without pesky users altering the values to
        // cheat. When saving using NSKeyedArchiver, the program looks
        // at the options in init(NSCoder), and uses that.
        
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(characters)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "characters")
    }
    
    override func didMoveToView(view: SKView) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Code to wipe the NSUserDefaults in case something messes up
        /*let ident = NSBundle.mainBundle().bundleIdentifier!
        defaults.removePersistentDomainForName(ident)*/
        
        // Load the characters from the NSUserDefaults storage
        if let savedCharacters = defaults.objectForKey("characters") as? NSData {
            characters = NSKeyedUnarchiver.unarchiveObjectWithData(savedCharacters) as! [Player]
        }
        
        setLabels()
        
        character1.runAction(spin)
    }
    
    override func keyDown(e: NSEvent) {
        let code = e.keyCode
        
        // As we're trying to detect a carriage return, we need to 
        // change the way we detect keypresses. Normally, we'd try
        // to find the char using `e.charactersIgnoringModifiers!`
        // but that doesn't detect a return. Instead we can change
        // the key into an integer, which gives us the right value
        // ('a' == 0, 'd' == 2, enter == 36)
        
        if code == 0 {
            // Check the currently selected character to make sure
            // we don't move over the edge of the screen
            
            if !(characters.count <= selectedCharacter - 2) && selectedCharacter - 1 >= 0 {
                selectedCharacter--
                changeSpin(selectedCharacter)
            }
            
        } else if code == 2 {
            
            if !(characters.count <= selectedCharacter) && selectedCharacter + 1 <= 2 {
                selectedCharacter++
                changeSpin(selectedCharacter)
            }
            
        } else if code == 36 {
            if characters.count - 1 >= selectedCharacter {
                save()
                
                // If this is the case, then we are over a playable character
                let scene = LevelScene(size: CGSize(width: 1024, height: 768))
                scene.scaleMode = .AspectFill
                scene.player = characters[selectedCharacter]
                scene.save = self
                
                // Build a camera, and add it to the scene
                let newCamera = SKCameraNode()
                scene.camera = newCamera
                scene.addChild(newCamera)
                
                let transition = SKTransition.crossFadeWithDuration(1)
                
                self.scene!.view?.presentScene(scene, transition: transition)
            } else {
                let newCharacter = Player()
                
                let colors = [SKColor.yellowColor(), SKColor.brownColor(), SKColor.cyanColor(), SKColor.magentaColor(), SKColor.purpleColor(), SKColor.whiteColor()]
                let names = ["Sir Yellow", "Dr Brown", "Mrs Cyan", "Prof. Magenta", "Lady Purple", "Walter White"]
                
                let index = Int(random(colors.count))
                
                newCharacter.color = colors[index]
                newCharacter.name = names[index]
                
                characters.append(newCharacter)
                setLabels()
                
                save()
            }
        } else if code == 51 {
            // Delete the current character
            if characters.count - 1 >= selectedCharacter {
                characters.removeAtIndex(selectedCharacter)
                setLabels()
                
                save()
            }
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
            level1.text = "Level \(Int(floor(current.level)))"
            health1.text = "Health: \(current.maxHealth)"
            speed1.text = "Speed: \(Int(floor(current.attackSpeed)))"
            defence1.text = "Defence: \(current.defence)"
            
            if characters.count >= 2 {
                let current = characters[1]
                character2.color = current.color
                name2.text = current.name
                level2.text = "Level \(Int(floor(current.level)))"
                health2.text = "Health: \(current.maxHealth)"
                speed2.text = "Speed: \(Int(floor(current.attackSpeed)))"
                defence2.text = "Defence: \(current.defence)"
                
                if characters.count >= 3 {
                    let current = characters[2]
                    character3.color = current.color
                    name3.text = current.name
                    level3.text = "Level \(Int(floor(current.level)))"
                    health3.text = "Health: \(current.maxHealth)"
                    speed3.text = "Speed: \(Int(floor(current.attackSpeed)))"
                    defence3.text = "Defence: \(current.defence)"
                } else {
                    character3.color = SKColor.redColor()
                    name3.text = "Add New"
                    level3.text = "Level ???"
                    health3.text = "Health: ???"
                    speed3.text = "Speed: ???"
                    defence3.text = "Defence: ???"
                }
            } else {
                character2.color = SKColor.redColor()
                name2.text = "Add New"
                level2.text = "Level ???"
                health2.text = "Health: ???"
                speed2.text = "Speed: ???"
                defence2.text = "Defence: ???"
                
                character3.color = SKColor.redColor()
                name3.text = "Add New"
                level3.text = "Level ???"
                health3.text = "Health: ???"
                speed3.text = "Speed: ???"
                defence3.text = "Defence: ???"
            }
        } else {
            character1.color = SKColor.redColor()
            name1.text = "Add New"
            level1.text = "Level ???"
            health1.text = "Health: ???"
            speed1.text = "Speed: ???"
            defence1.text = "Defence: ???"
            
            character2.color = SKColor.redColor()
            name2.text = "Add New"
            level2.text = "Level ???"
            health2.text = "Health: ???"
            speed2.text = "Speed: ???"
            defence2.text = "Defence: ???"
            
            character3.color = SKColor.redColor()
            name3.text = "Add New"
            level3.text = "Level ???"
            health3.text = "Health: ???"
            speed3.text = "Speed: ???"
            defence3.text = "Defence: ???"
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
