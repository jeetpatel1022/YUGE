//
//  WallBlock.swift
//  Trumptris
//
//  Created by TNJ on 4/2/16.
//  Copyright © 2016 NTJ. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


typealias BlockPosition = (Int,Int)
enum WallBlockColor:Int {
    case Red=0,Blue,Green, Purple, Orange, Yellow, NA
}
var colors = ["red","blue","green","purple","orange","yellow"]
class WallBlock:SKSpriteNode {
    var blockPosition:BlockPosition = (-1,-1)
    var isPlaced = false
    var colorType:WallBlockColor = .NA
    var colorstr  = ""
    init() {
        colorstr = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        let text = SKTexture(imageNamed: "\(colorstr)Block.png")
        super.init(texture: text, color: UIColor.clearColor(), size: CGSizeZero)

    }
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class Wall:NSObject {
    var gridArr:[[WallBlock?]]=[]
    var unPlacedBlock:WallBlock? = nil
    var frame:CGRect
    init(x:Int,y:Int,frame:CGRect) {
        for _ in 1...y {
            gridArr.append(Array<WallBlock?>(count: x, repeatedValue: nil))
        }
        self.frame=frame
        super.init()
    }
    func moveBlockToCoordinate(block:WallBlock, x:Int, y:Int){
        block.runAction(SKAction.moveTo(CGPointMake(CGFloat(x)*frame.width/9, CGFloat(y+1)*frame.height/15), duration: 0.5))
        block.blockPosition = (x,y)
    }
    func findMatches() -> (Bool, [BlockPosition]?) {
        var matches:[BlockPosition] = []
        for(var i=0; i<gridArr.count; i++){
            var count=1
            for(var j=0; j<gridArr[i].count-1; j++) {
                if gridArr[i][j] == nil || gridArr[i][j+1] == nil {
                    if count >= 3 {
                        for(var k=0; k<count;k++) {
                            matches.append((j-k,i))
                        }
                    }
                    count = 1
                    continue
                }
                if gridArr[i][j]!.colorstr == gridArr[i][j+1]!.colorstr {
                    count++
                    continue
                } else {
                    if count >= 3 {
                        for(var k=0; k<count;k++) {
                            matches.append((j-k,i))
                        }
                    }
                    count = 1
                    continue
                }
            }
        }
        
        for(var j=0; j<gridArr[0].count-1; j++) {
            var count=1
            for(var i=0; i<gridArr.count; i++){
                if gridArr[i][j] == nil || gridArr[i+1][j] == nil {
                    if count >= 3 {
                        for(var k=0; k<count;k++) {
                            matches.append((j,i-k))
                        }
                    }
                    count = 1
                    continue
                }
                if gridArr[i][j]!.colorstr == gridArr[i+1][j]!.colorstr {
                    count++
                    continue
                } else {
                    if count >= 3 {
                        for(var k=0; k<count;k++) {
                            matches.append((j,i-k))
                        }
                    }
                    count = 1
                    continue
                }

            }
        }
        if matches.isEmpty {
            return (false, matches)
        }
        
        return (true,matches)
    }
}
//    func findMatches()->(Bool,[BlockPosition]?) {
//        var matches:[BlockPosition]=[]
//        for row in 0...gridArr.count-1 {
//            var count=1
//            for num in 0...gridArr[row].count-2 {
//                if let block:WallBlock = gridArr[row][num] {
//                    if let block2:WallBlock = gridArr[row][num+1] {
//                        if block.colorstr==block2.colorstr {
//                            count += 1
//                        } else {
//                            if count>=3 {
//                                for counter in count-1...0 {
//                                    matches.append((counter,row))
//                                }
//                                count=1
//                            } else {
//                                count=1
//                            }
//                        }
//                    }else {
//                        if count>=3 {
//                            for counter in 0...count-1 {
//                                matches.append((row,counter))
//                            }
//                            count=1
//                        } else {
//                            count=1
//                        }
//                    }
//                }
//            }
//        }
//        
//        for column in 0...gridArr[0].count-2{
//            for row in 0...gridArr.count-1 {
//                var count=1
//                if let block:WallBlock = gridArr[row][column] {
//                    if let block2:WallBlock = gridArr[row+1][column] {
//                        if block.colorstr==block2.colorstr {
//                            count += 1
//                        } else {
//                            if count>=3 {
//                                for counter in count-1...0 {
//                                    matches.append((counter,row))
//                                }
//                                count=1
//                            } else {
//                                count=1
//                            }
//                        }
//                    }else {
//                        if count>=3 {
//                            for counter in 0...count-1 {
//                                matches.append((row,counter))
//                            }
//                            count=1
//                        } else {
//                            count=1
//                        }
//                    }
//                }
//            }
//        }
//        
//        if matches.isEmpty {
//            return (false,nil)
//        } else {
//            return (true,matches)
//        }
//    }
//}