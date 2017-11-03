//
//  GameOverScene.swift
//  NovartoGalaxian
//
//  Created by Dimitar Kolev on 10/17/17.
//  Copyright © 2017 Dimitar Kolev. All rights reserved.
//

import Foundation
import SpriteKit
class GameOverScene: SKScene{
    var contentCreated = false
    var score: Int
    var message: String
    override func didMove(to view: SKView) {
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
    }
    init(size: CGSize, message: String, score: Int) {
        self.score = score
        self.message = message
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createContent() {
        let gameOverLabel = SKLabelNode(fontNamed: "Courier")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.text = "Game Over! You \(message) \nYour score is: \(score)"
        gameOverLabel.numberOfLines = 2
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.5 * self.size.height);
        self.addChild(gameOverLabel)
        let tapLabel = SKLabelNode(fontNamed: "Courier")
        tapLabel.fontSize = 25
        tapLabel.fontColor = SKColor.white
        tapLabel.text = "(Tap to Play Again)"
        tapLabel.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
        self.addChild(tapLabel)
        self.backgroundColor = SKColor.black
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
        
    }
}
