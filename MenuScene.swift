//
//  MenuScene.swift
//  Assignment_PTL
//
//  Created by p on 30/11/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

var playButton = SKSpriteNode()



//let playButtonTex = SKTexture(imageNamed: "play")
class MenuScene: SKScene {
       var playLabel :SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.yellowColor()
        NSLog("We have loaded the start screen")
        playButton = SKSpriteNode(imageNamed: "Circle")
        playButton.size = CGSize(width: 300, height: 300)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(playButton)
        
        
        playLabel = SKLabelNode(fontNamed:"Arial")
        playLabel!.text = "Play"
        playLabel!.fontColor = SKColor.darkGrayColor()
        playLabel!.fontSize = 60
        playLabel!.horizontalAlignmentMode = .Center;
        playLabel!.verticalAlignmentMode = .Center
        playLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(playLabel!)

    }

 override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.menuHelper(touches)
}
    
    func menuHelper(touches: NSSet){
        for touch in touches{
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch == playLabel{
                if let view = view {
                    let scene = GameScene(fileNamed:"GameScene")! as GameScene
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    view.presentScene(scene)
                }
            }
        }
    }
}
        /*
    if let touch = touches.first as? UITouch {
        let pos = touch.locationInNode(self)
        let node = self.nodeAtPoint(pos)
        
        if node == playButton {
            if let view = view {
                let scene = GameScene(fileNamed:"GameScene") as GameScene
                scene.scaleMode = SKSceneScaleMode.AspectFill
                view.presentScene(scene)
            }
        }
    }
}
*/