//
//  MainMenu.swift
//  WWR Extension
//
//  Created by Tony Nguyen on 2017-10-11.
//  Copyright © 2017 Feihong Zhao. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    override func sceneDidLoad() {
        let menuLabel:SKLabelNode = SKLabelNode(text: "Wrist Racer")
        self.addChild(menuLabel)
        
        self.backgroundColor = UIColor.black
    }
    
}
