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
    var zAction:SKAction?
    
    override func sceneDidLoad() {
        setUp()
        createRoad()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(createRoadStrips), userInfo: nil, repeats: true)
    }
    
    func setUp() {
        let rotationRange = SKRange(lowerLimit: CGFloat(-0.7853981634), upperLimit: CGFloat(0.7853981634))
        let rotationConstraint = SKConstraint.zRotation(rotationRange)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player = SKSpriteNode(imageNamed: "go-kart")
        player?.position = CGPoint(x: 0, y: -100)
        player?.zPosition = 10
        player?.setScale(2)
        
        player?.constraints = [rotationConstraint]
        zAction = SKAction.rotate(toAngle: 0, duration: 0.1)
        
        self.addChild(player!)
    }
    
    func createRoad() {
        
        road = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        road?.strokeColor = SKColor.orange
        road?.lineWidth = 5
        road?.fillColor = SKColor.gray
        road?.name = "road"
        road?.position.x = 0
        road?.position.y = 0
        addChild(road!)
        
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
        
        let rightStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightStrip.strokeColor = SKColor.white
        rightStrip.fillColor = SKColor.white
        rightStrip.alpha = 0.4
        rightStrip.name = "rightStrip"
        rightStrip.zPosition = 2
        rightStrip.position.x = CGFloat(self.frame.maxX / 3)
        rightStrip.position.y = CGFloat(self.frame.maxY)
        addChild(rightStrip)
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
    
    func removeItems() {
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        showRoadStrips()
    }
}










