//
//  GameScene.swift
//  Assignment_PTL
//
//  Created by padraigoneill on 15/11/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    var Dot = SKSpriteNode()
    var MenuButton = SKSpriteNode()
    var appName:SKLabelNode?

    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    var movingClockwise = Bool()
    var intersected = false
    
    var LevelLabel = UILabel()
    
    var currentLevel = Int()
    var currentScore = Int()
    var highLevel = Int()
    
    
    
    //Menu Icon from https://www.iconfinder.com/icons/134216/hamburger_lines_menu_icon
    
    
    //  Sound From https://www.freesound.org/people/ZvinbergsA/sounds/273143/
  //  var ButtonAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType:"wav")!))
    
    //  Sound From https://www.freesound.org/people/mrmacross/sounds/186896/
    var FailAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fail", ofType:"mp3")!))
    
    
    //  Sound From https://www.freesound.org/people/joshuaempyre/sounds/251461/
    var BackgroundAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType:"wav")!))
    
    //  Sound From https://www.freesound.org/people/fins/sounds/171671/
    var WinAudioPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("win", ofType:"wav")!))
    
    
    override func didMoveToView(view: SKView) {
        loadView()
        
        let Defaults = NSUserDefaults.standardUserDefaults()
        if Defaults.integerForKey("HighLevel") != 0{
            highLevel = Defaults.integerForKey("HighLevel") as Int!
            currentLevel = highLevel
            currentScore = currentLevel
            LevelLabel.text = "\(currentScore)"
        }
        else{
                Defaults.setInteger(1, forKey: "HighLevel")
        }

    }
    
    func loadView() {
   
        movingClockwise = true
        backgroundColor = SKColor.yellowColor()
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width: 45, height: 9)
        Person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120)
        Person.zRotation = 3.14/2
        Person.zPosition = 2.0
        self.addChild(Person)
        AddDot()
        
        LevelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        LevelLabel.center = (self.view?.center)!
        LevelLabel.text = "\(currentScore)"
        LevelLabel.textColor = SKColor.blackColor()
        LevelLabel.textAlignment = NSTextAlignment.Center
        LevelLabel.font = UIFont.systemFontOfSize(60)
        self.view?.addSubview(LevelLabel)
        
        MenuButton = SKSpriteNode(imageNamed: "MenuButton")
        MenuButton.position = CGPoint(x:CGRectGetMidX(self.frame)-175, y:CGRectGetMidY(self.frame)*2-40)
        MenuButton.size = CGSize(width: 85, height:85)
        self.addChild(MenuButton)
        
        appName = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        appName!.text = "Tappit!"
        appName!.fontColor = SKColor.purpleColor()
        appName!.fontSize = 120
        appName!.horizontalAlignmentMode = .Center;
        appName!.verticalAlignmentMode = .Center
        appName!.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-260)
        self.addChild(appName!)

        
}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.menuHelper(touches)
    }
    
    func menuHelper(touches: NSSet){
        for touch in touches{
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch == MenuButton && gameStarted == false {
                if let view = view {
                    LevelLabel.removeFromSuperview()
                    ButtonAudioPlayer.play()
                    let scene = MenuScene(fileNamed:"MenuScene")! as MenuScene
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    view.presentScene(scene)
                }
            }
            else {
                if gameStarted == false {
                    moveClockWise()
                    movingClockwise = true
                    gameStarted = true
                }
                else if gameStarted == true {
                    
                    if movingClockwise == true{
                        moveCounterClockWise()
                        movingClockwise = false
                        
                    }else if movingClockwise == false{
                        moveClockWise()
                        movingClockwise = true
                        
                    }
                    DotTouched()
                }
               
            }
        }
    }



    
    func AddDot(){
        
        Dot = SKSpriteNode(imageNamed: "Dot")
        Dot.size = CGSize(width: 45, height: 45)
        Dot.zPosition = 1.0
        
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
        if movingClockwise == true{
            let tempAngle = CGFloat.random( min: rad - 1.0, max: rad - 2.5)
            
            let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height/2),radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path.currentPoint
            
        }else if movingClockwise == false{
            let tempAngle = CGFloat.random( min: rad + 1.0, max: rad + 2.5)
            
            let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height/2),radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path.currentPoint
            
        }
        
        self.addChild(Dot)

        
        
    }
    
    
    func moveClockWise(){
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height/2),radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 300)
        Person.runAction(SKAction.repeatActionForever(follow.reversedAction()))
    }
    
    func moveCounterClockWise(){
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height/2),radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 300)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
    
    func DotTouched(){
        if intersected == true{
             ButtonAudioPlayer.stop()
            if NSUserDefaults.standardUserDefaults().boolForKey("Muted") != true {
                ButtonAudioPlayer.play()
            }
            Dot.removeFromParent()
            AddDot()
            intersected = false
            currentScore--
            LevelLabel.text = "\(currentScore)"
            
            
            if currentScore <= 0{
                nextLevel()
            }
        
        }
        else if intersected == false{
            died()
        }
    }
    
    func died(){
        if NSUserDefaults.standardUserDefaults().boolForKey("Muted") != true {
            FailAudioPlayer.play()
        }
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.yellowColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        LevelLabel.removeFromSuperview()
        currentScore = currentLevel
        self.loadView()
        
    }
    
    func won(){
        if NSUserDefaults.standardUserDefaults().boolForKey("Muted") != true {
            WinAudioPlayer.play()
        }
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.yellowColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        LevelLabel.removeFromSuperview()
        self.loadView()
        
    }
        
    func nextLevel(){
        currentLevel++
        currentScore = currentLevel
        LevelLabel.text = "\(currentScore)"
        won()
        if currentScore > highLevel{
            highLevel = currentLevel
            let Defaults = NSUserDefaults.standardUserDefaults()
            Defaults.setInteger(highLevel, forKey: "HighLevel")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Person.intersectsNode(Dot){
            intersected = true
        }
        
        else{
            if intersected == true{
                if Person.intersectsNode(Dot) == false{
                    died()
                }
            }
        }
    }
}
