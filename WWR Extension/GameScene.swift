//
//  GameScene.swift
//  WWR Extension
//
//  Created by Feihong Zhao on 2017-10-11.
//  Copyright © 2017 Feihong Zhao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var player:SKSpriteNode?
    var road:SKShapeNode?
    var strip:SKShapeNode?
    var zAction:SKAction?
    
    override func sceneDidLoad() {
        setUp()
        createRoad()
    }
    
    func setUp() {
        let rotationRange = SKRange(lowerLimit: CGFloat(-0.7853981634), upperLimit: CGFloat(0.7853981634))
        let rotationConstraint = SKConstraint.zRotation(rotationRange)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "go-kart")
        player?.position = CGPoint(x: 0, y: -100)
        player?.zPosition = 2
        player?.setScale(2)
        
        player?.constraints = [rotationConstraint]
        zAction = SKAction.rotate(toAngle: 0, duration: 0.1)
        
        self.addChild(player!)
    }
    
    func createRoad() {
        
        road = SKShapeNode(rectOf: CGSize(width: (size.width - 30), height: size.height))
        road?.strokeColor = SKColor.orange
        road?.lineWidth = 5
        road?.fillColor = SKColor.gray
        road?.name = "road"
        road?.position.x = 0
        road?.position.y = 0
        
        strip = SKShapeNode(rectOf: CGSize(width: 10, height: 30))
        strip?.strokeColor = SKColor.white
        strip?.fillColor = SKColor.white
        strip?.alpha = 0.4
        strip?.name = "Strip"
        strip?.zPosition = 10
        strip?.position.x = 0
        strip?.position.y = CGFloat(self.frame.maxY)
        
        addChild(road!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

