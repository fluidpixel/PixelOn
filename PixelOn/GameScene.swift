//
//  GameScene.swift
//  PixelOn
//
//  Created by Stuart Varrall on 04/08/2015.
//  Copyright (c) 2015 Stuart Varrall. All rights reserved.
//

import SpriteKit

struct Item {
    
    let baseValue:Double = 1
    var itemLevel:Double
    
    lazy var baseCost:Double = {
        return self.itemLevel * 5 + 5
    }()
    
    lazy var itemUpgradeCost:Double = {
        return self.baseCost * pow(1.1, self.itemLevel)
    }()
    
    lazy var itemValue:Double = {
        return self.baseCost * pow(1.1, self.itemLevel)
    }()
    
    init(level: Double) {
        self.itemLevel = level
    }
    
}

class GameScene: SKScene {
    
    var currentLevel:Double = 1
    var stacks = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Tap";
        myLabel.fontSize = 20;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.name = "instructions"
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.childNodeWithName("instructions")?.removeFromParent()
        
        if stacks == Int(self.size.height / (self.size.height / CGFloat(currentLevel))) {
            upgrade()
        }
        
//        var item = Item(level:currentLevel)
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let width = self.size.width
            let height = self.size.height / CGFloat(currentLevel)
            
            let sprite = SKShapeNode(rectOfSize: CGSizeMake(width, height))
            sprite.fillColor = SKColor.whiteColor()
            sprite.position = CGPointMake(self.size.width/2, height/2 + (height*CGFloat(stacks)))
            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
            stacks++
        }
    }
   
    func upgrade() {
        self.removeAllChildren()
        currentLevel+=1
        stacks = 0
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Level \(Int(currentLevel))"
        myLabel.fontSize = 40
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height - 80)
        myLabel.name = "instructions"
        myLabel.fontColor = SKColor.redColor()
        self.addChild(myLabel)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
