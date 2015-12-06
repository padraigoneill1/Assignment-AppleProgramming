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
import AVFoundation

var playButton = SKSpriteNode()
var musicSettings = SKSpriteNode()
var resetHighScore = SKSpriteNode()
var muteTexture = SKTexture(imageNamed: "MuteMusic")
var playTexture = SKTexture(imageNamed: "PlayMusic")


// Mute/Play icons from wikimedia
//  Sound From https://www.freesound.org/people/joshuaempyre/sounds/251461/
var BackgroundAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType:"wav")!))

//  Sound From https://www.freesound.org/people/ZvinbergsA/sounds/273143/
var ButtonAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType:"wav")!))

class MenuScene: SKScene {
        var playLabel :SKLabelNode?
        var resetScore :SKLabelNode?
        var appName:SKLabelNode?
        weak var gameViewController : GameViewController?
    
    override func didMoveToView(view: SKView) {
       
        BackgroundAudioPlayer.numberOfLoops = -1
        BackgroundAudioPlayer.play()
        if NSUserDefaults.standardUserDefaults().boolForKey("Muted") == true {
            BackgroundAudioPlayer.stop()
        }

        backgroundColor = SKColor.yellowColor()
        NSLog("We have loaded the start screen")
        playButton = SKSpriteNode(imageNamed: "Circle")
        playButton.size = CGSize(width: 300, height: 300)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(playButton)
        
        
        playLabel = SKLabelNode(fontNamed:"Arial")
        playLabel!.text = "Play"
        playLabel!.fontColor = SKColor.blackColor()
        playLabel!.fontSize = 60
        playLabel!.horizontalAlignmentMode = .Center;
        playLabel!.verticalAlignmentMode = .Center
        playLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(playLabel!)
        
        musicSettings.texture = playTexture
        musicSettings.position = CGPoint(x:CGRectGetMidX(self.frame)*2-350, y:CGRectGetMidY(self.frame)*2-50)
        musicSettings.size = CGSize(width: 100, height:100)
        self.addChild(musicSettings)
        
        resetHighScore = SKSpriteNode(imageNamed: "resetHighScore")
        resetHighScore.size = CGSize(width: 100, height: 100)
        resetHighScore.position = CGPoint(x:CGRectGetMidX(self.frame)-150, y:CGRectGetMidY(self.frame)*2-50)
        self.addChild(resetHighScore)
        
        
        resetScore = SKLabelNode(fontNamed:"Arial")
        resetScore!.text = "Reset Score"
        resetScore!.fontColor = SKColor.blackColor()
        resetScore!.fontSize = 30
        resetScore!.horizontalAlignmentMode = .Center;
        resetScore!.verticalAlignmentMode = .Center
        resetScore!.position = CGPoint(x: CGRectGetMidX(self.frame)-125, y:CGRectGetMidY(self.frame)*2-130)
        self.addChild(resetScore!)
        
        appName = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        appName!.text = "Tappit!"
        appName!.fontColor = SKColor.purpleColor()
        appName!.fontSize = 120
        appName!.horizontalAlignmentMode = .Center;
        appName!.verticalAlignmentMode = .Center
        appName!.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-260)
        self.addChild(appName!)



        NSUserDefaults.standardUserDefaults().setBool(false, forKey:"Muted" )
        
    }

 override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.menuHelper(touches)
}
    
    func menuHelper(touches: NSSet){
        for touch in touches{
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch == playLabel{
                if let view = view {
                    ButtonAudioPlayer.play()
                    let scene = GameScene(fileNamed:"GameScene")! as GameScene
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    view.presentScene(scene)
                    }
                }
            else if nodeAtTouch == musicSettings{
                if musicSettings.texture == playTexture{
                    musicSettings.texture = muteTexture
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey:"Muted" )
                    BackgroundAudioPlayer.stop()
                }
                else{
                    musicSettings.texture = playTexture
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey:"Muted" )
                    BackgroundAudioPlayer.play()
                    }
            }
            else if nodeAtTouch == resetHighScore{
                NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "HighLevel")
                ButtonAudioPlayer.play()
                resetScore!.text = "Score Reset!"
                
            }
            
        }
    }
}
