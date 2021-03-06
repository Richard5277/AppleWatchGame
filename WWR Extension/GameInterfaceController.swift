//
//  InterfaceController.swift
//  WWR Extension
//
//  Created by Feihong Zhao on 2017-10-11.
//  Copyright © 2017 Feihong Zhao. All rights reserved.
//

import WatchKit
import Foundation
import GameKit

class GameInterfaceController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var skInterface: WKInterfaceSKScene!
    let scene = GameScene(fileNamed: "GameScene")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        NotificationCenter.default.addObserver(forName: .startOver, object: nil, queue: .current) { (notification) in
//            print(" 😈 😈 😈 receiving notification >> starting the game over")
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = GameScene(fileNamed: "GameScene") {
//
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                self.skInterface.presentScene(scene)
//
//                // Use a value that will maintain a consistent frame rate
//                self.skInterface.preferredFramesPerSecond = 30
//            }
//
//            // Set the scale mode to scale to fit the window
//            self.scene?.scaleMode = .aspectFill
//            self.scene?.name = "GameScene"
//
//            // Present the scene
//            self.skInterface.presentScene(self.scene)
//
//            // Use a value that will maintain a consistent frame rate
//            self.skInterface.preferredFramesPerSecond = 30
//
//            self.crownSequencer.delegate = self
//        }
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = GameScene(fileNamed: "GameScene") {
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
        }
        
        // Set the scale mode to scale to fit the window
        scene?.scaleMode = .aspectFit
        scene?.name = "GameScene"
        
        // Present the scene
        self.skInterface.presentScene(scene)
        
        // Use a value that will maintain a consistent frame rate
        self.skInterface.preferredFramesPerSecond = 30
        
        crownSequencer.delegate = self
        
    }

    @IBAction func handleGoLeft(_ sender: Any) {
        scene?.player?.run((scene?.zAction)!)
        scene?.player?.position.x -= CGFloat(((self.scene?.frame.width)!-20) / 3)
        scene?.player?.zRotation += CGFloat(1)
    }
    
    @IBAction func handelGoRight(_ sender: Any) {
        scene?.player?.run((scene?.zAction)!)
        scene?.player?.position.x += CGFloat(((self.scene?.frame.width)!-20) / 3)
        scene?.player?.zRotation -= CGFloat(1)
    }
    
    @IBAction func startOver(_ sender: Any) {
        print("😈 😈 tap tap")
//
//        if let tapGesture = sender as? WKTapGestureRecognizer {
//            print(tapGesture)
//            if tapGesture.numberOfTapsRequired == 1 {
//                // Restart the game on single tap only if presenting congratulation screen.
//                // ctrl -> left
//            }
//        }
        
        self.dismiss()
        self.dismissAddPassesController()
    }
    
    @IBAction func handleTap(_ sender: Any) {
//                // Load the SKScene from 'GameScene.sks'
//                if skInterface.scene?.name == "Main Menu" {
//                    if let scene = GameScene(fileNamed: "GameScene") {
//                        // Set the scale mode to scale to fit the window
//                        scene.scaleMode = .aspectFill
//                        scene.name = "Game Scene"
//                        // Present the scene
//                        self.skInterface.presentScene(scene)
//
//                        // Use a value that will maintain a consistent frame rate
//                        self.skInterface.preferredFramesPerSecond = 30
//                    }
//                    print(skInterface.scene?.name ?? "MAIN")
//                }
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        // Straighten car if crown rotation slowing down
        if rotationalDelta > -0.1 && rotationalDelta < 0.1 {
            scene?.player?.run((scene?.zAction)!)
        }
        scene?.player?.position.x += CGFloat(rotationalDelta * 10)
        scene?.player?.zRotation -= CGFloat(rotationalDelta)
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        scene?.player?.run((scene?.zAction)!)
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
