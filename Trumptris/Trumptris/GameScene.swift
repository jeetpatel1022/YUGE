//
//  GameScene.swift
//  Trumptris
//
//  Created by Jeet Patel on 4/2/16.
//  Copyright (c) 2016 NTJ. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var startTime:CFTimeInterval = 0
    var wall:Wall?
    var heightNum:Int = 15
    var angryTrump = SKSpriteNode(texture: SKTexture(imageNamed: "angry.png"))
    let playButton = SKSpriteNode(imageNamed: "play.png")
    override func didMoveToView(view: SKView) {
        //angryTrump.size = CGSize(width: UIScreen.mainScreen().bounds.width*0.1, height: UIScreen.mainScreen().bounds.height*0.1)
        addChild(playButton)
        playButton.anchorPoint=CGPointMake(0.5, 0.5)
        playButton.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        playButton.setScale(0.25)
        playButton.name = "Play"
        addChild(angryTrump)
    
        angryTrump.setScale(0.25)
        angryTrump.anchorPoint = CGPoint(x: angryTrump.frame.midX, y: angryTrump.frame.midY)
        angryTrump.position = CGPoint(x: view.bounds.midX, y: angryTrump.frame.midY)
        
        angryTrump.anchorPoint = CGPointMake(0.5, 0.5)
        let jumpUp = SKAction.moveBy(CGVectorMake(0, 45), duration: 0.35)
        let jumpDown = SKAction.moveBy(CGVectorMake(0, -45), duration: 0.15)
        let seq = SKAction.sequence([jumpUp,jumpDown])
        angryTrump.runAction((SKAction.repeatActionForever(seq)), withKey: "jumpupdown")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let node = nodeAtPoint(touches.first!.locationInNode(self))
        if node.name == "Play" {
            angryTrump.removeActionForKey("jumpupdown")
            play()
        }
    }
    func play() {
        let fadePlay = SKAction.fadeOutWithDuration(0.2)
        let shrink = SKAction.scaleTo(0.001, duration: 0.4)
        let rotate = SKAction.repeatAction((SKAction.rotateByAngle(CGFloat(-M_PI_4), duration: 0.03)), count: 8)
        let group = SKAction.group([fadePlay,shrink,rotate])
        playButton.runAction(fadePlay, completion: {self.playButton.removeFromParent()})
        angryTrump.runAction(group, completion: {self.startGame()})
        
    }
    func startGame() {
        buildAWall()
        addABlock()
    }
    func buildAWall() {
        wall = Wall(x: 9, y: 13,frame: self.frame)
        for x in 0...8 {
            for y in 0...2 {
                var block = WallBlock()
                block.blockPosition = (y,x)
                block.anchorPoint = CGPointMake(0, 0)
                block.size = CGSizeMake(self.frame.width/9, self.frame.height/15)
                block.position = CGPointMake(CGFloat(x)*self.frame.width/9, CGFloat(y)*self.frame.height/15)
                addChild(block)
                wall?.gridArr[y][x] = block
            }
        }
    }
    var newBlock:WallBlock?
    var swipeOffset:Int = 0
    func left() {
        let col = newBlock!.blockPosition.0
        if(newBlock?.blockPosition.0 <= 0) {
            return
        }
        if(nodesAtPoint(CGPointMake(newBlock!.position.x-5, newBlock!.position.y)).count==2) {
            return
        }
        newBlock!.runAction(SKAction.moveByX(-self.frame.width/9, y: 0, duration: 0.05))
        newBlock!.blockPosition = (newBlock!.blockPosition.0 - 1,13)
    }
    func right() {
        let col = newBlock!.blockPosition.0
        if(newBlock?.blockPosition.0 >= 8) {
            return
        }
        if(nodesAtPoint(CGPointMake(newBlock!.position.x-5, newBlock!.position.y)).count==2) {
            return
        }
        newBlock!.runAction(SKAction.moveByX(self.frame.width/9, y: 0, duration: 0.05))
        newBlock!.blockPosition = (newBlock!.blockPosition.0 + 1,13)
    }
    var leftSwipe:UISwipeGestureRecognizer?
    var rightSwipe:UISwipeGestureRecognizer?
    func addABlock() {
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.left))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.right))

        newBlock = WallBlock()
        newBlock!.anchorPoint = CGPointMake(0, 1)
        newBlock!.size = CGSizeMake(self.frame.width/9, self.frame.height/15)
        let randomIndex:CGFloat = CGFloat(arc4random_uniform(9))
        newBlock!.position=CGPointMake(newBlock!.size.width*randomIndex,self.frame.maxY)
        addChild(newBlock!)
        self.angryTrump.texture = SKTexture(imageNamed: "holding.png")
        angryTrump.size = CGSize(width: self.frame.width/9, height: self.frame.height/15)
        angryTrump.anchorPoint = CGPointMake(0, 1)
        angryTrump.position = CGPointMake(angryTrump.size.width*randomIndex, self.frame.maxY-self.frame.height/15)
        angryTrump.alpha=1
        let run = SKAction.moveByX(0, y: -self.frame.height/15, duration: 0.05)
        let wait = SKAction.waitForDuration(1)
        _ = SKAction.sequence(([wait,run]))
        let prerun = SKAction.moveByX(0, y: -2*self.frame.height/15, duration: 0.05)
        let pregroup = SKAction.sequence([wait,prerun])
        newBlock!.runAction(pregroup, completion: {
            self.newBlock!.blockPosition = (Int(randomIndex),13)
            self.angryTrump.texture = SKTexture(imageNamed: "ease.png")
            self.leftSwipe!.direction = .Left
            self.rightSwipe!.direction = .Right
            self.view!.addGestureRecognizer(self.leftSwipe!)
            self.view!.addGestureRecognizer(self.rightSwipe!)
            self.moveDownBlock(self.newBlock!,count:1)
        })
    }
    func gameOver() {
        self.view?.superview?.viewWithTag(20)?.hidden=false
        self.view?.superview?.viewWithTag(20)?.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            self.view?.superview?.viewWithTag(20)?.alpha=1
            self.angryTrump.runAction( SKAction.playSoundFileNamed("fired.mp3", waitForCompletion: true))
        })
    }
    func moveDownBlock(block:WallBlock,count:Int) {
        var column = block.blockPosition.0
        let run = SKAction.moveByX(0, y: -self.frame.height/15, duration: 0.01)
        let wait = SKAction.waitForDuration(0.2)
        let group = SKAction.sequence(([wait,run]))
        if(self.wall?.gridArr[11][column] != nil) {
            print("GAME OVER")
            gameOver()
            self.view?.removeGestureRecognizer(leftSwipe!)
            self.view?.removeGestureRecognizer(rightSwipe!)
            return
        }
        block.runAction(group, completion: {
            if 13-(count+1) < 10 {
                self.view!.removeGestureRecognizer(self.leftSwipe!)
                self.view!.removeGestureRecognizer(self.rightSwipe!)
            }
            if 13-(count+2) < 0 {
                self.wall?.gridArr[0][column]  = block
                self.view?.removeGestureRecognizer(self.leftSwipe!)
                self.view?.removeGestureRecognizer(self.rightSwipe!)
                self.fixMatches()
                
                return
            }
            if self.wall?.gridArr[13-(count+2)][column] != nil {
                self.wall?.gridArr[13-(count+1)][column] = block
                self.view?.removeGestureRecognizer(self.leftSwipe!)
                self.view?.removeGestureRecognizer(self.rightSwipe!)
                self.fixMatches()
                return
            }
            self.moveDownBlock(block,count: count+1)
        })
    }
    func fixMatches() {
            var pts = self.getPoints()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ScoreChange", object: nil, userInfo: ["points":pts]))
//        var matches = self.wall!.findMatches()
//        while(matches.0) {
//            var actions:[SKAction] = []
//            for coordinate in matches.1! {
//                var i = coordinate.1
//                while let block:WallBlock = wall!.gridArr[coordinate.0][i] {
//                    var column = block.blockPosition.0
//                    block.blockPosition = (block.blockPosition.0+1,block.blockPosition.1)
//                    wall!.gridArr[block.blockPosition.0][block.blockPosition.1] = block
//                    let run = SKAction.moveByX(0, y: -self.frame.height/15, duration: 0.01)
//                    let wait = SKAction.waitForDuration(0.2)
//                    let group = SKAction.sequence(([wait,run]))
//                    actions.append(group)
//                    i++
//                    break;
//                }
//                
//            }
//            matches = self.wall!.findMatches()
//        }
//        print(matches.0)
//        print(matches.1,terminator:"\n\n")
        self.addABlock()
    }
    
    func getPoints() -> Int {
        var sum = 0
        //var points:[[Int]] = Array<Array<Int>(count: 9, repeatedValue: 0)
        for(var i=0; i<wall!.gridArr.count; i += 1){
            for(var j=0; j<wall!.gridArr[i].count-1; j += 1) {
                if let block = wall!.gridArr[i][j] {
                    if j != 0 {
                        if let block2 = wall!.gridArr[i][j-1]  {
                            if block.colorstr == block2.colorstr {
                                sum++
                            }
                        }
                    }
                    
                    if(i != 0){
                        if let block2 = wall!.gridArr[i-1][j]  {
                            if block.colorstr == block2.colorstr {
                                sum++
                            }
                        }
                    }
                    
                    
                    if(i != wall!.gridArr.count-1){
                        if let block2 = wall!.gridArr[i+1][j]  {
                            if block.colorstr == block2.colorstr {
                                sum++
                            }
                        }
                    }
                    
                    if(j != wall!.gridArr[i].count-1){
                        if let block2 = wall!.gridArr[i][j+1]  {
                            if block.colorstr == block2.colorstr {
                                sum++
                            }
                        }
                    }
                    
                }
            }
        }
        return sum
    }
    override func update(currentTime: CFTimeInterval) {
        if startTime==0 {
            startTime = currentTime
        }
        //print(currentTime)
        /* Called before each frame is rendered */
        
    }
}
extension UIColor {
    static func randomColor() ->UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(11))/10, green: CGFloat(arc4random_uniform(11))/10, blue: CGFloat(arc4random_uniform(11))/10, alpha: 1)
    }
}
