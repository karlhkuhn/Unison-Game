//
//  GameViewController.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/26/16.
//  Copyright (c) 2016 Karl Kuhn. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Configure the view.
		let scene = MainMenuScene(size: gameSize)

		let skView = self.view as! SKView
		skView.showsFPS = false
		skView.showsNodeCount = false
		skView.showsPhysics = false
		skView.ignoresSiblingOrder = false
		scene.scaleMode = .aspectFill
		
		let transition = SKTransition.crossFade(withDuration: 2)
		skView.presentScene(scene, transition: transition)
	}

	override var shouldAutorotate : Bool {
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	func didStartGame(_ controller: MainMenuScene) {
	}
}
