//
//  GameScene.swift
//  WWR Extension
//
//  Created by Feihong Zhao on 2017-10-11.
//  Copyright © 2017 Feihong Zhao. All rights reserved.
//

import SpriteKit
import WatchKit
import GameKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var totalNodes: Int = 0
    
    var player:SKSpriteNode?
    var road:SKSpriteNode?
    var distLabel:SKLabelNode?
    var zAction:SKAction?
    
    var ball: SKSpriteNode?
    var leftWall: SKShapeNode?
    var rightWall: SKShapeNode?
    
    var lives: [SKSpriteNode]?
    
    // speed
    var traficSpeed: CGFloat = 15
    var ballSpeed: CGFloat = 1
    
    // game start over layer
    var gameOverLyer: SKSpriteNode?
    var gameOverLabel: SKLabelNode?
    var startOverLabel: SKLabelNode?
    
    let startTime = Date()
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        setUp()
        createRoad()
        
        setUpLife()
        
//        setUpControls()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(createRoadStrips), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(generateRandomNumber(min: 3, max: 5)), target: self, selector: #selector(createObstacles), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(7), target: self, selector: #selector(increaseSpeed), userInfo: nil, repeats: true)
        
    }
    
    func setUp() {
        let rotationRange = SKRange(lowerLimit: CGFloat(-0.7853981634), upperLimit: CGFloat(0.7853981634))
        let rotationConstraint = SKConstraint.zRotation(rotationRange)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "blackf1")
        player?.name = "player"
        player?.position = CGPoint(x: 0, y: -50)
        player?.zPosition = 10
        player?.setScale(0.8)
        
        player?.constraints = [rotationConstraint]
        zAction = SKAction.rotate(toAngle: 0, duration: 0.1)
        
        // adding plyaer physics body
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (player?.size.width)!, height: (player?.size.height)!))
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.contactTestBitMask = 1
        
        let frame1:SKTexture = SKTexture(imageNamed: "player_frame1")
        let frame2:SKTexture = SKTexture(imageNamed: "player_frame2")
        let frame3:SKTexture = SKTexture(imageNamed: "player_frame3")
        let frame4:SKTexture = SKTexture(imageNamed: "player_frame4")
        let frame5:SKTexture = SKTexture(imageNamed: "player_frame5")
        let frame6:SKTexture = SKTexture(imageNamed: "player_frame6")
        
        let animation:SKAction = SKAction.animate(with: [frame1,frame2,frame3,frame4,frame5,frame6], timePerFrame: 0.1)
        let repeatAction:SKAction = SKAction.repeatForever(animation)
        player?.run(repeatAction)
        
        self.addChild(player!)
        
        distLabel = SKLabelNode()
        distLabel?.text = "0"
        distLabel?.fontName = "HelveticaNeue-Bold"
        distLabel?.fontSize = 11
        distLabel?.fontColor = SKColor.white
        distLabel?.position = CGPoint(x: frame.midX + 2, y: -(frame.height / 2) + 5)
        distLabel?.alpha = 0.8
        distLabel?.zPosition = 10
        
        self.addChild(distLabel!)
    }
    
    func createRoad() {
        road = SKSpriteNode(imageNamed: "background 1")
        road?.size = CGSize(width: frame.width, height: frame.height)
        
        let frame1:SKTexture = SKTexture(imageNamed: "background 1")
        let frame2:SKTexture = SKTexture(imageNamed: "background 2")
        let frame3:SKTexture = SKTexture(imageNamed: "background 3")
        let frame4:SKTexture = SKTexture(imageNamed: "background 4")
        
        let bgAnimation:SKAction = SKAction.animate(with: [frame1,frame2,frame3,frame4], timePerFrame: 0.1)
        let repeatAction:SKAction = SKAction.repeatForever(bgAnimation)
        road?.run(repeatAction)
        road?.name = "road"
        road?.position.x = 0
        road?.position.y = 0
        
        addChild(road!)
        
    }
    
    func createWalls() {
        
        // MARK: - right wall
        leftWall = SKShapeNode(rect: CGRect(x: -(self.size.width/2), y: -self.size.height/2, width: 5, height: self.size.height))
        leftWall?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.size.height), center: CGPoint(x: 0, y: 0))
        leftWall?.zPosition = 10
        leftWall?.name = "leftWall"
        leftWall?.fillColor = .red
        leftWall?.physicsBody?.isDynamic = false
        leftWall?.physicsBody?.affectedByGravity = false
        leftWall?.physicsBody?.allowsRotation = false
        leftWall?.physicsBody?.contactTestBitMask = 1
        
        // MARK: - right wall
        rightWall = SKShapeNode(rect: CGRect(x: self.size.width/2 - 5, y: -self.size.height/2, width: 5, height: self.size.height))
        rightWall?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.size.height), center: CGPoint(x: 0, y: 0))
        rightWall?.name = "rightWall"
        rightWall?.zPosition = 10
        rightWall?.fillColor = .red
        rightWall?.physicsBody?.isDynamic = false
        rightWall?.physicsBody?.affectedByGravity = false
        rightWall?.physicsBody?.allowsRotation = false
        rightWall?.physicsBody?.contactTestBitMask = 1
        
        addChild(leftWall!)
        addChild(rightWall!)
    }
    
    @objc func createObstacles() {
        
        //random number to determine if traffic is in lane 1, 2, or 3
        let randLane = arc4random_uniform(4)
        

        var obstacles = ["Boulder", "broken-tree", "lava1", "oilspill", "poopoo-trash-ariel"]
        let randObstacle = Int(arc4random_uniform(5))
        
        ball = SKSpriteNode(imageNamed: obstacles[randObstacle])
        ball?.name = "ball"
        ball?.size = CGSize(width: 25, height: 25)
        ball?.zPosition = 2
        
        ball?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball?.physicsBody?.affectedByGravity = false
        ball?.physicsBody?.contactTestBitMask = 1
        
        ball?.position.y = CGFloat(self.frame.maxY + 25)
        
        if randLane == 1 {
            ball?.position.x = -50
        } else if randLane == 2 {
            ball?.position.x = 0
        } else if randLane == 3 {
            ball?.position.x = 50
        }
        
        addChild(ball!)
        self.totalNodes += 1
    }
    
    @objc func createRoadStrips() {
        let leftStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftStrip.strokeColor = SKColor.white
        leftStrip.fillColor = SKColor.white
        leftStrip.alpha = 0.4
        leftStrip.name = "leftStrip"
        leftStrip.zPosition = 2
        leftStrip.position.x = -CGFloat(self.frame.maxX / 3)
        leftStrip.position.y = CGFloat(self.frame.maxY)
        addChild(leftStrip)
        self.totalNodes += 1
        
        let rightStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightStrip.strokeColor = SKColor.white
        rightStrip.fillColor = SKColor.white
        rightStrip.alpha = 0.4
        rightStrip.name = "rightStrip"
        rightStrip.zPosition = 2
        rightStrip.position.x = CGFloat(self.frame.maxX / 3)
        rightStrip.position.y = CGFloat(self.frame.maxY)
        addChild(rightStrip)
        self.totalNodes += 1
    }
    
    func showRoadStrips() {
        enumerateChildNodes(withName: "leftStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= self.traficSpeed
        })
        
        enumerateChildNodes(withName: "rightStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= self.traficSpeed
        })
    }
    
    func animateTraffic() {
        enumerateChildNodes(withName: "ball", using: { (traffic, stop) in
            let ball = traffic as! SKSpriteNode
            ball.position.y -= self.ballSpeed
        })
    }
    
    @objc func increaseSpeed() {
        traficSpeed += 3
        ballSpeed += 1.5
    }
    
    func removeItems() {
        for child in self.children {
            if child.position.y < -self.size.height - 20 {
                child.removeFromParent()
                self.totalNodes -= 1
            }
        }
    }
    
    func addTarget(_ target: Any, action: Selector){
        if target as! SKSpriteNode == childNode(withName: "leftControl") {
            print("😈  ============ go left")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            destroyBall(nodeA)
            
        } else if nodeB.name == "ball" {
            destroyBall(nodeB)
        }

    }
    
    func destroyBall(_ node: SKNode) {
        node.removeFromParent()
        
        // lose one life
        if let lives = self.lives {
            if let life = lives.first {
                
                life.removeFromParent()
                self.lives?.removeFirst()
                
                if life.name == "lifeThree" {
                    print("👻 👻 👻  GAME OVER 👻 👻 👻")
                    
                    // move to Game Over Scene
                    // + action >> pause the game ???
                    pauseGame()
                    // >> and present a button says " play again "
                    
                }
            }
        }
    }
    
    func updateDistance() {
        let distText = Int(round(startTime.timeIntervalSinceNow, toNearest: 1) / 5)
        distLabel?.text = "\(-distText)"
    }
    
    func round(_ value: Double, toNearest: Double) -> Double {
        return Darwin.round(value / toNearest) * toNearest
    }
    
    func generateRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    override func update(_ currentTime: TimeInterval) {
        showRoadStrips()
        animateTraffic()
        removeItems()
        updateDistance()
    }
    
    func setUpLife() {
        
        let lifeOne = childNode(withName: "lifeOne") as! SKSpriteNode
        lifeOne.name = "lifeOne"
        
        let lifeTwo = childNode(withName: "lifeTwo") as! SKSpriteNode
        lifeTwo.name = "lifeTwo"
        
        let lifeThree = childNode(withName: "lifeThree") as! SKSpriteNode
        lifeThree.name = "lifeThree"

        let allLives: [SKSpriteNode] = [lifeOne, lifeTwo, lifeThree]
        self.lives = allLives
        
    }
    
    func setUpControls() {
        
        let leftCrl = childNode(withName: "leftControl") as! SKSpriteNode
        leftCrl.name = "leftCrl"
        
        let rightCrl = childNode(withName: "rightControl") as! SKSpriteNode
        rightCrl.name = "rightCrl"
        
    }
        
    func pauseGame() {
        self.ballSpeed = 0
        self.traficSpeed = 0
        self.distLabel?.removeFromParent()
        
        gameOverLyer = SKSpriteNode()
        gameOverLyer?.color = UIColor.lightGray
        gameOverLyer?.size = CGSize(width: frame.width, height: frame.height)
        gameOverLyer?.zPosition = 20
        self.addChild(gameOverLyer!)
        
        gameOverLabel = SKLabelNode()
        gameOverLabel?.text = "GAME OVER"
        gameOverLabel?.fontName = "HelveticaNeue-Bold"
        gameOverLabel?.fontSize = 16
        gameOverLabel?.fontColor = SKColor.white
        gameOverLabel?.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel?.alpha = 0.8
        gameOverLabel?.zPosition = 20
        gameOverLyer?.addChild(gameOverLabel!)
        
        let startOverLayer = SKSpriteNode()
        startOverLayer.color = .red
        startOverLayer.size = CGSize(width: frame.width - 12, height: 30)
        startOverLayer.position = CGPoint(x: frame.midX, y: frame.midY - 45)
        startOverLayer.alpha = 1
        startOverLayer.zPosition = 21
        self.addChild(startOverLayer)
        
        startOverLabel = SKLabelNode()
        startOverLabel?.text = "play again"
        startOverLabel?.fontName = "HelveticaNeue-Bold"
        startOverLabel?.fontSize = 16
        startOverLabel?.fontColor = SKColor.white
        startOverLabel?.position = CGPoint(x: frame.midX, y: frame.midY - 5)
        startOverLabel?.alpha = 1
        startOverLabel?.zPosition = 21
        NotificationCenter.default.post(name: NSNotification.Name.startOver, object: nil)
        startOverLayer.addChild(startOverLabel!)
    }
    
    @objc func startOver() {
        print("start over")
    }
    
}

extension Notification.Name {
    static let startOver = Notification.Name("startOver")
}


