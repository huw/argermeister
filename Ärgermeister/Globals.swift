//
//  Globals.swift
//  Ärgermeister
//
//  Created by Huw on 2015-08-03.
//  Copyright © 2015 Huw. All rights reserved.
//

import Foundation
import SpriteKit

struct weapons {
    var weapons = [
        "Weak Gun": 1,
        "Club": 5,
        "Fishing Line": 7,
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