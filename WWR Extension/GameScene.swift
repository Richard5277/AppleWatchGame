//
//  GameScene.swift
//  WWR Extension
//
//  Created by Feihong Zhao on 2017-10-11.
//  Copyright © 2017 Feihong Zhao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var totalNodes: Int = 0
    
    var player:SKSpriteNode?
    var road:SKShapeNode?
    var zAction:SKAction?
    
    var ball: SKShapeNode?
    var leftWall: SKShapeNode?
    var rightWall: SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        setUp()
        createRoad()
        
        createWalls()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(createRoadStrips), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(createTraffic), userInfo: nil, repeats: true)
        }
    
    func setUp() {
        let rotationRange = SKRange(lowerLimit: CGFloat(-0.7853981634), upperLimit: CGFloat(0.7853981634))
        let rotationConstraint = SKConstraint.zRotation(rotationRange)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "go-kart")
        player?.name = "player"
        player?.position = CGPoint(x: 0, y: -50)
        player?.zPosition = 10
        player?.setScale(1)
        
        player?.constraints = [rotationConstraint]
        zAction = SKAction.rotate(toAngle: 0, duration: 0.1)
        
        // adding plyaer physics body
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (player?.size.width)!, height: (player?.size.height)!))
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.contactTestBitMask = 1
        
        self.addChild(player!)
    }
    
    func createRoad() {
        road = SKShapeNode(rectOf: CGSize(width: self.size.width, height: self.size.height))
//        road?.strokeColor = SKColor.green
        road?.lineWidth = 1
        road?.fillColor = SKColor.gray
        road?.name = "road"
        road?.position.x = 0
        road?.position.y = 0
        
//        road?.physicsBody?.density
        
        addChild(road!)
        
    }
    
    func createWalls() {
        
        // MARK: - right wall
        leftWall = SKShapeNode(rect: CGRect(x: -(self.size.width/2), y: -self.size.height/2, width: 5, height: self.size.height))
//        leftWall?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.size.height))
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
    
    @objc func createTraffic() {
        
        //random number to determine if traffic is in lane 1, 2, or 3
        let randLane = arc4random_uniform(4)
        print("Lane Number ======== \(randLane)")
        
        ball = SKShapeNode(circleOfRadius: 10)
        ball?.fillColor = SKColor.blue
        ball?.name = "ball"
        ball?.zPosition = 2
        
        ball?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball?.physicsBody?.affectedByGravity = false
        ball?.physicsBody?.contactTestBitMask = 1

        ball?.position.y = CGFloat(self.frame.maxY)
        
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
            strip.position.y -= 60
        })
        
        enumerateChildNodes(withName: "rightStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 60
        })
    }
    
    func animateTraffic() {
        enumerateChildNodes(withName: "ball", using: { (traffic, stop) in
            let ball = traffic as! SKShapeNode
            ball.position.y -= 10
        })
    }
    
    func removeItems() {
        for child in self.children {
            if child.position.y < -self.size.height - 20 {
                child.removeFromParent()
                self.totalNodes -= 1
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        print("👀 Contact NodeA : \(String(describing: nodeA.name))")
        print("👀 Contact NodeB : \(String(describing: nodeB.name))")
        
        if nodeA.name == "ball" {
            destroyBall(nodeA)
        } else if nodeB.name == "ball" {
            destroyBall(nodeB)
        }
    }
    
    func destroyBall(_ node: SKNode) {
        node.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        showRoadStrips()
        animateTraffic()
        removeItems()
//        print("Total Nodes ::: \(self.totalNodes)")
    }
}


