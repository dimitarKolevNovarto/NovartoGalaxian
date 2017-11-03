//
//  GameScene.swift
//  NovartoGalaxian
//
//  Created by Dimitar Kolev on 10/16/17.
//  Copyright © 2017 Dimitar Kolev. All rights reserved.
//

import SpriteKit
import GameplayKit
enum InvaderMovementDirection {
    case right
    case left
    case none
}
enum BulletType {
    case shipFired
    case invaderFired
}
struct PhysicsCategory {
    static let invaderCategory: UInt32 = 0x1 << 0
    static let shipFiredBulletCategory: UInt32 = 0x1 << 1
    static let shipCategory: UInt32 = 0x1 << 2
    static let sceneEdgeCategory: UInt32 = 0x1 << 3
    static let invaderFiredBulletCategory: UInt32 = 0x1 << 4
}
class GameScene: SKScene , SKPhysicsContactDelegate{
    var gameStarted: Bool = false
    var gameOver: Bool = false
    var settingLevel: Bool = false
    var gameEndState: String = ""
    let shipFiredBulletName: String = "shipFiredBullet"
    let invaderFiredBulletName: String = "invaderFiredBullet"
    let bulletSize: CGSize = CGSize(width:4, height: 8)
    var ship: SKSpriteNode = SKSpriteNode()
    var invaderMovementDirection: InvaderMovementDirection = .right
    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0
    var timer: Timer = Timer()
    var fireTimer: Timer = Timer()
    var location: CGPoint = CGPoint.zero
    var sideButtonWidth: CGFloat = 0
    var buttonLeft: SKSpriteNode = SKSpriteNode()
    var buttonRight: SKSpriteNode = SKSpriteNode()
    var buttonFire: SKSpriteNode = SKSpriteNode()
    var contactQueue = [SKPhysicsContact]()
    var score: Int = 0
    var shipHealth: Int = 5
    var scoreLabel: SKLabelNode = SKLabelNode()
    var livesLabel: SKLabelNode = SKLabelNode()
    var currentLevel: Int = 1
    var lastScoreLife: Int = 1
    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isShooting: Bool = false
    var shouldFire: Bool = true
    var fireCooling: Bool = false

    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    override func didMove(to view: SKView) {
        let backgroundMusic = SKAudioNode.init(fileNamed: "NinjaGaiden-UnbreakableDetermination.mp3")
        addChild(backgroundMusic)
        sideButtonWidth = self.size.width/6
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = PhysicsCategory.sceneEdgeCategory
        setupButtons()
        setupInvaders()
        ship = SKSpriteNode(imageNamed: "Ship")
        ship.size = CGSize(width: 30, height: 16)
        ship.name = "ship"
        ship.position = CGPoint(x: size.width / 2.0, y: ship.size.height / 2.0)
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.physicsBody!.isDynamic = true
        ship.physicsBody!.affectedByGravity = false
        ship.physicsBody!.mass = 0.02
        ship.physicsBody!.categoryBitMask = PhysicsCategory.shipCategory
        ship.physicsBody!.contactTestBitMask = 0x0
        ship.physicsBody!.collisionBitMask = PhysicsCategory.sceneEdgeCategory
        addChild(ship)
        createScoreLabel()
        createLivesLabel()
        gameStarted = true
        physicsWorld.contactDelegate = self
    }
    
    func setupButtons() {
        let buttBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        buttonLeft = SKSpriteNode(color: buttBgColor, size: CGSize(width: self.sideButtonWidth/2, height: self.size.height))
        buttonLeft.zPosition = 5
        let leftButtLabel = SKLabelNode(text: "<")
        leftButtLabel.fontSize = 30
        leftButtLabel.fontColor = SKColor.white
        buttonLeft.addChild(leftButtLabel)
        buttonLeft.position = CGPoint(x: buttonLeft.size.width/2, y: buttonLeft.size.height/2)
        addChild(buttonLeft)
        buttonRight = SKSpriteNode(color: buttBgColor, size: CGSize(width: self.sideButtonWidth/2, height: self.size.height))
        buttonRight.position = CGPoint(x: buttonRight.size.width*3/2, y: buttonRight.size.height/2)
        buttonRight.zPosition = 5
        let rightButtLabel = SKLabelNode(text: ">")
        rightButtLabel.fontSize = 30
        rightButtLabel.fontColor = SKColor.white
        buttonRight.addChild(rightButtLabel)
        addChild(buttonRight)
        buttonFire = SKSpriteNode(color: buttBgColor, size: CGSize(width: self.sideButtonWidth, height: self.size.height))
        buttonFire.position = CGPoint(x: self.size.width - buttonFire.size.width/2, y: buttonFire.size.height/2)
        buttonFire.zPosition = 5
        let fireButtLabel = SKLabelNode(text: "+")
        fireButtLabel.fontSize = 40
        fireButtLabel.fontColor = SKColor.white
        buttonFire.addChild(fireButtLabel)
        addChild(buttonFire)
    }
    
    func setupInvaders() {
        let baseOrigin = CGPoint(x: size.width / 3, y: size.height / 2)
        let level = Level(levelNumber: currentLevel, startingPoint: baseOrigin)
        for invader in level.invaders{
            addChild(invader)
        }
    }
    func moveInvaders(forUpdate currentTime: CFTimeInterval) {
        if (currentTime - timeOfLastMove < timePerMove) {
            return
        }
        determineInvaderMovementDirection()
        for object in children{
            if let node = object as? AlienInvader {
                if !node.isMoving{
                    switch self.invaderMovementDirection {
                    case .right:
                        node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
                        node.initialPosition = CGPoint(x: node.initialPosition.x + 10, y: node.initialPosition.y)
                    case .left:
                        node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
                        node.initialPosition = CGPoint(x: node.initialPosition.x - 10, y: node.initialPosition.y)
                    case .none:
                        break
                    }
                    //node.initialPosition = node.position
                    self.timeOfLastMove = currentTime
                }
                else{
                    switch self.invaderMovementDirection {
                    case .right:
                        node.initialPosition = CGPoint(x: node.initialPosition.x + 10, y: node.initialPosition.y)
                    case .left:
                        node.initialPosition = CGPoint(x: node.initialPosition.x - 10, y: node.initialPosition.y)
                    case .none:
                        break
                    }
                }
            }
        }
        let randomNum = randomNumber(MIN: 0, MAX: 100)
        if randomNum < 30 {
            if let invader = pickRandomInvader(){
                if(!invader.isMoving){
                    flyInvaders(invader: invader)
                }
            }
        }
    }
    func determineInvaderMovementDirection() {
        var proposedMovementDirection: InvaderMovementDirection = invaderMovementDirection
        for object in children{
            if let node = object as? AlienInvader {
                switch self.invaderMovementDirection {
                case .right:
                    if (node.initialPosition.x + node.size.width/2 >= node.scene!.size.width - 10.0) {
                        proposedMovementDirection = .left
                    }
                case .left:
                    if (node.initialPosition.x - node.size.width/2 <= 10.0) {
                        proposedMovementDirection = .right
                    }
                default:
                    break
                }
            }
        }
        if (proposedMovementDirection != invaderMovementDirection) {
            invaderMovementDirection = proposedMovementDirection
        }
    }
    func pickRandomInvader() -> AlienInvader? {
        var invaders: [AlienInvader] = []
        for object in children{
            if let node = object as? AlienInvader {
                if !node.isMoving{
                    invaders.append(node)
                }
            }
        }
        if invaders.count < 1{
            return nil
        }
        let randomPos = Int(arc4random_uniform(UInt32(invaders.count)))
        let random = invaders[randomPos]
        return random
    }
    func flyInvaders(invader: AlienInvader){
        invader.isMoving = true
        var action1 = SKAction()
        if invaderMovementDirection == .right{
            
            let path = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: 40, startAngle: 0.00, endAngle: CGFloat(Double.pi), clockwise: true)
            action1 = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, duration: 1)
        }
        else if invaderMovementDirection == .left{
            let path = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: 40, startAngle: CGFloat(Double.pi), endAngle: 0.00, clockwise: false)
            action1 = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, duration: 1)
        }
        
        invader.run(action1, completion: {
            self.invaderFire(invader: invader)
            let action2 = self.determineInvaderFlightPath(invader: invader)
            let action3 = SKAction.move(to: CGPoint(x:invader.position.x,y:self.size.height), duration: 0)
            invader.run(SKAction.sequence([action2, action3]),
            completion: {
                var point = invader.initialPosition
                switch self.invaderMovementDirection {
                case .right:
                    point = CGPoint(x: invader.initialPosition.x + 10, y: invader.initialPosition.y)
                case .left:
                    point = CGPoint(x: invader.initialPosition.x - 10, y: invader.initialPosition.y)
                case .none:
                    break
                }
                if point.x < 10 || point.x > self.frame.width - 10{
                    point.x = self.frame.width/2
                }
                let action4 = SKAction.move(to: point , duration: 1)
                invader.run(action4,completion:{
                    let action5 = SKAction.rotate(toAngle: 0, duration: 0.5)
                    invader.run(action5)
                    invader.isMoving = false
                })
            })
        })
    }
    func determineInvaderFlightPath(invader: AlienInvader) -> SKAction{
        switch invader.type {
        case .a:
            return SKAction.move(to: CGPoint(x: invader.position.x, y: -invader.size.height), duration: 2)
        case .b:
            let cgpath: CGMutablePath = CGMutablePath();
            let xStart: CGFloat = invader.position.x
            let xEnd: CGFloat = self.size.width/2
            let yStart : CGFloat = invader.initialPosition.y
            let yEnd : CGFloat = 0 - 2*invader.size.height
            let numberOfIntermediatePoints = 1
            let intervalY = (yEnd - yStart)/CGFloat(numberOfIntermediatePoints)
            let s: CGPoint = CGPoint(x:xStart,y:yStart);
            cgpath.move(to: s)
            if(invaderMovementDirection == .right){
                for i in stride(from: 0, through: numberOfIntermediatePoints - 1, by: 1) {
                    let yOff = intervalY * CGFloat(i)
                    let controlPointInterval = intervalY/3
                    let cp1X: CGFloat = CGFloat(-size.width);
                    let cp1Y: CGFloat = CGFloat(yStart + yOff + controlPointInterval);
                    let cp2X: CGFloat = CGFloat(2*size.width);
                    let cp2Y: CGFloat = CGFloat(yStart + yOff + controlPointInterval * 2);
                    let e: CGPoint = CGPoint(x: xEnd,y: yStart + yOff + intervalY);
                    let cp1: CGPoint = CGPoint(x: cp1X,y: cp1Y);
                    let cp2: CGPoint = CGPoint(x: cp2X,y: cp2Y);
                    cgpath.addCurve(to: e, control1: cp1, control2: cp2)
                }
            }
            else if(invaderMovementDirection == .left){
                for i in stride(from: 0, through: numberOfIntermediatePoints - 1, by: 1) {
                    let yOff = intervalY * CGFloat(i)
                    let controlPointInterval = intervalY/3
                    let cp1X: CGFloat = CGFloat(2*size.width);
                    let cp1Y: CGFloat = CGFloat(yStart + yOff + controlPointInterval);
                    let cp2X: CGFloat = CGFloat(-size.width);
                    let cp2Y: CGFloat = CGFloat(yStart + yOff + controlPointInterval * 2);
                    let e: CGPoint = CGPoint(x: xEnd,y: yStart + yOff + intervalY);
                    let cp1: CGPoint = CGPoint(x: cp1X,y: cp1Y);
                    let cp2: CGPoint = CGPoint(x: cp2X,y: cp2Y);
                    cgpath.addCurve(to: e, control1: cp1, control2: cp2)
                }
            }
            return SKAction.follow(cgpath, asOffset: false, orientToPath: true, duration: 6)
        case .c:
            return SKAction.move(to: CGPoint(x: ship.position.x, y: -invader.size.height), duration: 3)
        }
    }
    func invaderFire(invader: AlienInvader){
        switch invader.type {
        case .a:
           _ = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
        case .b:
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
            
        case .c:
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
            _ = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
            _ = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(enemyFire(_:)), userInfo: invader, repeats: false)
        }
    }
    @objc func enemyFire(_ timer: Timer){
        let invader = timer.userInfo as! AlienInvader
        let bullet = makeBullet(ofType: .invaderFired)
        bullet.position = CGPoint(
            x: invader.position.x,
            y: invader.position.y - invader.frame.size.height / 2 + bullet.frame.size.height / 2
        )
        let bulletDestination = CGPoint(x: invader.position.x, y: -(bullet.frame.size.height / 2))
        if(invader.isAlive){
            fireBullet(
                bullet: bullet,
                toDestination: bulletDestination,
                withDuration: 2.0,
                andSoundFileName: "InvaderBullet.wav"
            )
        }
    }
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        switch bulletType {
        case .shipFired:
            bullet = SKSpriteNode(color: SKColor.yellow, size: bulletSize)
            bullet.name = shipFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategory.shipFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = PhysicsCategory.invaderCategory | PhysicsCategory.invaderFiredBulletCategory
            bullet.physicsBody!.collisionBitMask = 0x0
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: bulletSize)
            bullet.name = invaderFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategory.invaderFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = PhysicsCategory.shipCategory | PhysicsCategory.shipFiredBulletCategory
            bullet.physicsBody!.collisionBitMask = 0x0
            break
        }
        return bullet
    }
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 2.0 / 60.0),
            SKAction.removeFromParent()
            ])
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        bullet.run(SKAction.group([bulletAction, soundAction]))
        addChild(bullet)
    }
    func fireShipBullets() {
        //let existingBullet = childNode(withName: shipFiredBulletName)
        /*var existingBullets:[SKNode] = []
        for node in children{
            if(node.name == shipFiredBulletName){
                existingBullets.append(node)
            }
        }
        */
        if shouldFire{
            if let ship = childNode(withName: "ship") {
                let bullet = makeBullet(ofType: .shipFired)
                bullet.position = CGPoint(
                    x: ship.position.x,
                    y: ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2
                )
                let bulletDestination = CGPoint(
                    x: ship.position.x,
                    y: frame.size.height + bullet.frame.size.height / 2
                )
                fireBullet(
                    bullet: bullet,
                    toDestination: bulletDestination,
                    withDuration: 1.5,
                    andSoundFileName: "ShipBullet.wav"
                )
                shouldFire = false
            }
        }
    }
    func moveShipLeft(){
        ship.position.x -= 5
    }
    func moveShipRight(){
        ship.position.x += 5
    }
    @objc func fire(){
        fireShipBullets()
    }
    @objc func resumeFire(){
        shouldFire = true
        fireCooling = false
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (buttonLeft.contains(location) && gameStarted){
                isMovingLeft = true
                
            }
            if (buttonRight.contains(location) && gameStarted){
                isMovingRight = true
            }
            if(buttonFire.contains(location) && !fireCooling){
                isShooting = true
                fireTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(resumeFire), userInfo: nil, repeats: true)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let location = touches.first!.location(in: self)
        isMovingRight = false
        isMovingLeft = false
        isShooting = false
        shouldFire = false
        fireTimer.invalidate()
        if(!fireCooling){
            fireCooling = true
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(resumeFire), userInfo: nil, repeats: false)
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    func adjustScore(by points: Int) {
        score += points
        scoreLabel.text = "score: \(score)"
        if score > 5000 * lastScoreLife{
            shipHealth += 1
            lastScoreLife += 1
            livesLabel.text = "◬x\(shipHealth)"
        }
    }
    func giveShipInvulnerability(time: Double){
        ship.physicsBody?.categoryBitMask = PhysicsCategory.sceneEdgeCategory
        let flickerTextures = [SKTexture(imageNamed: "Ship"),
                               SKTexture(imageNamed: "Ship1")]
        
        ship.run(SKAction.repeatForever(SKAction.animate(with:  flickerTextures, timePerFrame: 0.2)), withKey: "invulnerability")
        ship.run(SKAction.wait(forDuration: time),completion: {
            self.ship.physicsBody?.categoryBitMask = PhysicsCategory.shipCategory
            self.ship.removeAction(forKey: "invulnerability")
            self.ship.texture = SKTexture(imageNamed: "Ship")
        })
    }
    func adjustShipHealth(by healthAdjustment: Int) {
        shipHealth = max(shipHealth + healthAdjustment, 0)
        livesLabel.text = "◬x\(shipHealth)"
    }
    func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        if nodeNames.contains("ship") && nodeNames.contains(invaderFiredBulletName) {
            // Invader bullet hit a ship
            run(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            adjustShipHealth(by: -1)
            giveShipInvulnerability(time: 3)
            if shipHealth <= 0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            }
            else {
                if let ship = childNode(withName: "ship") {
                    ship.alpha = CGFloat(shipHealth)
                    if contact.bodyA.node == ship {
                        contact.bodyB.node!.removeFromParent()
                    }
                    else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        }
        else if nodeNames.contains(shipFiredBulletName) && nodeNames.contains(invaderFiredBulletName){
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
        else if nodeNames.contains("invader") && nodeNames.contains(shipFiredBulletName) {
            // Ship bullet hit an invader
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            var invader: AlienInvader
            if let inv = contact.bodyB.node! as? AlienInvader{
                invader = inv
                invader.isAlive = false
                invader.removeFromParent()
                contact.bodyA.node!.removeFromParent()
            }
            else {
                invader = contact.bodyA.node! as! AlienInvader
                invader.isAlive = false
                invader.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            }
            var score = 0
            switch invader.type{
            case .a:
                score = 100
            case .b:
                score = 200
            case .c:
                score = 300
            }
            adjustScore(by: score)
        }
        else if nodeNames.contains("ship") && nodeNames.contains("invader"){
            //Invader collided with ship
            run(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            adjustShipHealth(by: -1)
            giveShipInvulnerability(time: 3)
            if shipHealth <= 0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            }
            else {
                if let ship = childNode(withName: "ship") {
                    ship.alpha = CGFloat(shipHealth)
                    var invader:AlienInvader
                    if contact.bodyA.node == ship {
                        invader = contact.bodyB.node! as! AlienInvader
                        invader.isAlive = false
                        invader.removeFromParent()
                    }
                    else {
                        invader = contact.bodyA.node! as! AlienInvader
                        invader.isAlive = false
                        invader.removeFromParent()
                    }
                    var score = 0
                    switch invader.type{
                    case .a:
                        score = 100
                    case .b:
                        score = 200
                    case .c:
                        score = 300
                    }
                    adjustScore(by: score)
                }
            }
        }
    }
    func isGameOver() -> Bool {
        let invader = childNode(withName: "invader")
        let ship = childNode(withName: "ship")
        if invader == nil{
            if currentLevel > 8{
                gameEndState = "Win!"
                return true
            }
            else{
                if !settingLevel{
                    settingLevel = true
                    currentLevel += 1
                    let nextLevelLabel = SKLabelNode(fontNamed: "Courier")
                    nextLevelLabel.position = CGPoint(x: size.width/2, y: size.height/2)
                    nextLevelLabel.text = "Next: Level \(currentLevel)"
                    nextLevelLabel.fontSize = 70
                    addChild(nextLevelLabel)
                    run(SKAction.wait(forDuration: 2),completion:{
                        nextLevelLabel.removeFromParent()
                        self.setupInvaders()
                        self.settingLevel = false
                    })
                }
            }
        }
        if ship == nil{
            gameEndState = "Lose!"
            return true
        }
        return false
    }
    func endGame() {
        if !gameOver {
            gameOver = true
            let gameOverScene: GameOverScene = GameOverScene(size: size,message: gameEndState, score: score)
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)            
            if let index = contactQueue.index(of: contact) {
                contactQueue.remove(at: index)
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if isGameOver() {
            endGame()
        }
        processContacts(forUpdate: currentTime)
        moveInvaders(forUpdate: currentTime)
        if isMovingLeft{
            self.moveShipLeft()
        }
        if isMovingRight{
            self.moveShipRight()
        }
        if isShooting{
            self.fire()
        }
    }
    func createScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.position = CGPoint(x: 50, y: 10)
        scoreLabel.alpha = 0.7
        scoreLabel.text = "score: \(score)"
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 10
        addChild(scoreLabel)
    }
    func createLivesLabel(){
        livesLabel = SKLabelNode(fontNamed: "Courier")
        livesLabel.position = CGPoint(x: size.width/2 + 200, y: 10)
        livesLabel.alpha = 0.7
        livesLabel.text = "◬x\(shipHealth)"
        livesLabel.zPosition = 5
        livesLabel.fontSize = 10
        addChild(livesLabel)
    }
}
