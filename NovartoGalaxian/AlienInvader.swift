//
//  Alien.swift
//  NovartoGalaxian
//
//  Created by Dimitar Kolev on 10/16/17.
//  Copyright © 2017 Dimitar Kolev. All rights reserved.
//

import Foundation
import SpriteKit
enum InvaderType {
    case a
    case b
    case c
}
class AlienInvader: SKSpriteNode{
    var type: InvaderType
    var timePerMove: CFTimeInterval = 1.0
    var isMoving: Bool = false
    var isAlive: Bool = true
    var initialPosition: CGPoint = CGPoint()
    init(type: InvaderType){
        self.type = type
        let color: SKColor
        let defaultSize = CGSize(width: 24, height: 16)
        var prefix: String
        switch type {
        case .a:
            color = SKColor.red
            prefix = "InvaderA"
        case .b:
            color = SKColor.green
            prefix = "InvaderB"
        case .c:
            color = SKColor.blue
            prefix = "InvaderC"
        }
        let invaderTextures = [SKTexture(imageNamed: String(format: "%@_00", prefix)),
                               SKTexture(imageNamed: String(format: "%@_01", prefix))]
        super.init(texture: invaderTextures[0], color: color, size: defaultSize)
        self.name = "invader"
        self.run(SKAction.repeatForever(SKAction.animate(with: invaderTextures, timePerFrame: timePerMove)))
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.invaderCategory
        self.physicsBody!.contactTestBitMask = PhysicsCategory.shipCategory
        self.physicsBody!.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
