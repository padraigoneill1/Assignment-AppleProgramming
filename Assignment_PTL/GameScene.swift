//
//  GameScene.swift
//  Assignment_PTL
//
//  Created by padraigoneill on 15/11/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    var Dot = SKSpriteNode()
    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    
    var movingClockwise = Bool()
    
    
     var intersected = false
    
    var LevelLabel = UILabel()
    
    var currentLevel = Int()
    
    var currentScore = Int()
    
    var highLevel = Int()
    
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
        backgroundColor = SKColor.whiteColor()
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width: 40, height: 7)
        Person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120)
        Person.zRotation = 3.14/2
        Person.zPosition = 2.0
        self.addChild(Person)
        AddDot()
        
        LevelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        LevelLabel.center = (self.view?.center)!
        LevelLabel.text = "\(currentScore)"
        LevelLabel.textColor = SKColor.darkGrayColor()
        LevelLabel.textAlignment = NSTextAlignment.Center
        LevelLabel.font = UIFont.systemFontOfSize(60)
        self.view?.addSubview(LevelLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
    
    func AddDot(){
        
        Dot = SKSpriteNode(imageNamed: "Dot")
        Dot.size = CGSize(width: 30, height: 30)
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
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow.reversedAction()))
    }
    
    func moveCounterClockWise(){
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let rad = atan2(dy, dx)
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height/2),radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
    
    func DotTouched(){
        if intersected == true{
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
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        LevelLabel.removeFromSuperview()
        currentScore = currentLevel
        self.loadView()
        
    }
    
    func won(){
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)
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
