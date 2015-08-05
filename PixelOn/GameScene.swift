//
//  GameScene.swift
//  PixelOn
//
//  Created by Stuart Varrall on 04/08/2015.
//  Copyright (c) 2015 Stuart Varrall. All rights reserved.
//

import SpriteKit

struct Item {
    let baseValueArray:[Double] = [1,5,22,74,245,976,3725,10860,47150,186000,782000,3721000,17010000,]
    
    var baseValue:Double
    var itemLevel:Double
    
    lazy var baseCost:Double = {
        let cost = 10 * pow(5,self.itemLevel-1)
        return cost
    }()
    
    lazy var itemUpgradeCost:Double = {
        return self.baseCost * pow(1.1, self.itemLevel)
    }()
    
    lazy var itemValue:Double = {
        return self.baseValue * pow(1.05, self.itemLevel)
    }()
    
    init(level: Int) {
        self.itemLevel = Double(level)
        self.baseValue = baseValueArray[Int(level)-1]
    }
    
}

class GameScene: SKScene {
    
    var currentLevel:Double = 1
    var stacks = 0
    var pixelArray = [SKNode]()
    var items = [Item]()
    var tapPoints:Double = 1
    
    var points:Double = 0 {
        didSet {
            if let pointsLabel = childNodeWithName("pointsLabel") as? SKLabelNode{
                pointsLabel.text = "\(Int(points))"
                
                var pointsIncrease = Int(points - oldValue)
                
                var nextItem = Item(level:items.count+1)
                
                if let requiredPointsLabel = childNodeWithName("requiredPointsLabel") as? SKLabelNode {
                    requiredPointsLabel.text = "\(Int(nextItem.baseCost))"
                }
                
                if let buyButton = childNodeWithName("buyItem") {
                    if nextItem.baseCost <= points {
                        buyButton.alpha = 1.0
                    } else {
                        buyButton.alpha = 0.1
                    }
                }
                
                if pointsIncrease > 0 {
                    var height = self.size.height / CGFloat(pow(2, currentLevel))
                    
                    while stacks + pointsIncrease > Int(self.size.height / height) {
                        pointsIncrease -= (Int(self.size.height / height) - stacks)
                        upgrade()
                        height = self.size.height / CGFloat(pow(2, currentLevel))
                        print("too big")
                    }
                    
                    stacks+=pointsIncrease
                    
                    removeChildrenInArray(pixelArray)
                    pixelArray.removeAll()
                    
                    //                        if let pixel = childNodeWithName("pixel") as? SKShapeNode{
                    //                            pixel.yScale = CGFloat(stacks)
                    //                            pixel.position.y = pixel.frame.size.height / 2
                    //                        } else {
                    let width = self.size.width
                    let sprite = SKShapeNode(rectOfSize: CGSizeMake(width, height*CGFloat(stacks)))
                    sprite.fillColor = SKColor.whiteColor()
                    //                            sprite.position = CGPointMake(self.size.width/2, height/2 + (height*CGFloat(stacks)))
                    sprite.position = CGPointMake(self.size.width/2, sprite.frame.size.height / 2)
                    sprite.antialiased = false
                    sprite.name = "pixel"
                    addChild(sprite)
                    pixelArray.append(sprite)
                    //                        }
                    
                }
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Tap";
        myLabel.fontSize = 40
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height - 80)
        myLabel.name = "instructions"
        myLabel.fontColor = SKColor.redColor()
        myLabel.zPosition = 100
        self.addChild(myLabel)
        
        points = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if node.name == nil {
                node.name = ""
            }
            
            switch node.name! {
            case "buyItem", "requiredPointsLabel":
                buyItem()
            default:
                break
            }
            
            points+=tapPoints
            
        }
    }
   
    func upgrade() {
        removeChildrenInArray(pixelArray)
        currentLevel+=1
        stacks = 0
        
        if let myLabel = self.childNodeWithName("instructions") as? SKLabelNode {
            myLabel.text = "Level \(Int(currentLevel))"
        } else {
             let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "Level \(Int(currentLevel))"
            myLabel.fontSize = 40
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height - 80)
            myLabel.name = "instructions"
            myLabel.fontColor = SKColor.redColor()
            self.addChild(myLabel)
        }
        
    }
    
    func buyItem() {
        var item = Item(level:items.count + 1)
        if points >= item.baseCost {
            points -= item.baseCost
            print("BUY")
            items.append(item)
        } else {
            print("NO BUY")
        }
    }
    
    func applyItemValues() {
        for var item in items {
//            print("adding: \(item.itemValue)")
            points += item.itemValue
        }
    }
    
    var lastUpdateTime:CFTimeInterval = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let timeSinceLastUpdate = currentTime - lastUpdateTime
        
        if timeSinceLastUpdate > 1 {
            applyItemValues()
            lastUpdateTime = currentTime
        }
        
    }
}
