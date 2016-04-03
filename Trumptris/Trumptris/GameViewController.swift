//
//  GameViewController.swift
//  Trumptris
//
//  Created by Jeet Patel on 4/2/16.
//  Copyright (c) 2016 NTJ. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var skView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePoints:", name: "ScoreChange", object: nil)
        let scene = GameScene()
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            scene.size=skView.bounds.size
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.Fill
            scene.backgroundColor = UIColor.clearColor()
            skView.backgroundColor = .clearColor()
            skView.presentScene(scene)
    }
    func updatePoints(n:NSNotification) {
        var pts = n.userInfo!["points"] as! Int
        scoreLabel.text = "\(pts*50)"
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
