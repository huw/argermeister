//
//  Globals.swift
//  Ärgermeister
//
//  Created by Huw on 2015-08-03.
//  Copyright © 2015 Huw. All rights reserved.
//

import Foundation
import SpriteKit

var availableWeapons = [
    "Weak Gun": 1,
    "Fist": 1,
    "Club": 5,
    "Sticker": 5,
    "Keyboard": 6,
    "Fishing Line": 7,
    "Wood Bit": 8,
    "Magnets": 9,
    "Spear": 10,
    "Hammer": 12,
    "Archery Kit": 15,
    "Sword": 15,
    "Pen": 16, // heh
    "Battleaxe": 17,
    "Blunt Instrument": 18,
    "Motorcycle Tyre": 22,
    "Decent Gun": 25,
    "Weiner Nunchucks": 28,
    "Bass Cannon": 33,
    "Strong Gun": 42
]

enum BodyType: UInt32 {
    case player = 1
    case wall = 2
    case tile = 4
    case enemy = 8
}

func showLabel(node: SKNode, text: String) {
    // Pretty basic bold, centered text
    let label = SKLabelNode(text: text)
    label.fontName = "Helvetica Neue Bold"
    label.fontSize = 36
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    label.position = CGPoint(x: 0, y: 40)
    label.alpha = 0.0
    
    // waitForPrevious counts how many of these are stacked up,
    // and waits until all of them are done
    let waitForPrevious = SKAction.waitForDuration(1.05 * Double(node.children.count))
    let fadeIn = SKAction.fadeInWithDuration(0.05)
    let moveUpAndFade = SKAction.group([SKAction.moveByX(0, y: 50, duration: 1), SKAction.fadeOutWithDuration(1)])
    
    node.addChild(label)
    label.runAction(SKAction.sequence([waitForPrevious, fadeIn, moveUpAndFade, SKAction.removeFromParent()]))
}

func random(num: Float = 1) -> Float {
    
    // How does this work?
    // Swift doesn't include any kind of useful random number generator
    // Luckily, it has a bunch of them ported over from the objective-C
    // days, like arc4random and arc4random_uniform, which produce good
    // random numbers. arc4random() produces a UINT32 though, so we can
    // divide it by its maximum value to make a number between 0 and 1.
    // We can multiply this by a given number to find a random floating
    // -point number between 0 and the number we wish. Later arithmetic
    // can be performed outside of this function.
    
    return Float(arc4random()) / Float(UINT32_MAX) * num
}

func random(num: Int) -> Float {
    // Convenience for when we're using integers
    return random(Float(num))
}