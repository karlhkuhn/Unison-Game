//
//  successScreenLayover.swift
//  Unison
//
//  Created by Karl H Kuhn on 5/6/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SuccessScreenLayover: SKNode {
	
	var numberOfStars = 0
	
	let spacingIndent: CGFloat = 100
	
	let theSuccessScreen = SKSpriteNode(imageNamed: "successScreen")
	let starHolder1 = SKSpriteNode(imageNamed: "successScreenStarHolder")
	let starHolder2 = SKSpriteNode(imageNamed: "successScreenStarHolder")
	let starHolder3 = SKSpriteNode(imageNamed: "successScreenStarHolder")

	let star1 = SKSpriteNode(imageNamed: "successScreenStar")
	let star2 = SKSpriteNode(imageNamed: "successScreenStar")
	let star3 = SKSpriteNode(imageNamed: "successScreenStar")
	
	override init() {
		super.init()
	}
	
	init(successStarCount: Int) {
		super.init()
		
		self.numberOfStars = successStarCount
		addChild(theSuccessScreen)
		theSuccessScreen.size = CGSize(width: theSuccessScreen.size.width * 0.80, height: theSuccessScreen.size.height * 0.80)
		
		starHolder1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		starHolder2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		starHolder3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		
		star1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		star2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		star3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		
		starHolder1.position = CGPoint(x: -theSuccessScreen.size.width / 2 + spacingIndent, y: -theSuccessScreen.size.height / 2)
		starHolder2.position = CGPoint(x: theSuccessScreen.size.width / 2 - spacingIndent, y: -theSuccessScreen.size.height / 2)
		starHolder3.position = CGPoint(x: 0, y: -theSuccessScreen.size.height / 2 + spacingIndent + 150)
		
		addChild(starHolder1)
		addChild(starHolder2)
		addChild(starHolder3)
		
		switch successStarCount {
		case 0: return
		case 1: add1Star()
			
		case 2: add2Stars()
			
		case 3: add3Stars()
		default: return
		}
		

	}
	
	func add1Star() {

		
		let setStartSize = SKAction.scale(to: 0, duration: 0)
		let growAction = SKAction.scale(to: 1.5, duration: 0.2)
		let shrinkAction = SKAction.scale(to: 1, duration: 0.05)
		let waitTime = SKAction.wait(forDuration: 0.7)
		let starPopSequence = SKAction.sequence([waitTime, SKAction.group([popSound,growAction]), shrinkAction])
		
		growAction.timingMode = .easeInEaseOut
		shrinkAction.timingMode = .easeInEaseOut

		addChild(star1)
		
		star1.position = starHolder1.position
		run(SKAction.group([waitTime, successSong]))
		star1.run(setStartSize)
		
		star1.run(starPopSequence)
	}
	
	func add2Stars() {

		
		let setStartSize = SKAction.scale(to: 0, duration: 0)
		let growAction = SKAction.scale(to: 1.5, duration: 0.2)
		let shrinkAction = SKAction.scale(to: 1, duration: 0.05)
		let waitTime = SKAction.wait(forDuration: 0.7)
		let starPopSequence = SKAction.sequence([waitTime, SKAction.group([popSound,growAction]), shrinkAction])
		
		growAction.timingMode = .easeInEaseOut
		shrinkAction.timingMode = .easeInEaseOut
		
		addChild(star1)
		addChild(star2)
		
		star1.position = starHolder1.position
		star2.position = starHolder2.position
		
		run(SKAction.group([waitTime, successSong]))
		star1.run(setStartSize)
		star2.run(setStartSize)
		
		star1.run(starPopSequence)
		star2.run(SKAction.sequence([
			waitTime, starPopSequence]))
	}
	
	func add3Stars() {

		let setStartSize = SKAction.scale(to: 0, duration: 0)
		let growAction = SKAction.scale(to: 1.5, duration: 0.2)
		let shrinkAction = SKAction.scale(to: 1, duration: 0.05)
		let waitTime = SKAction.wait(forDuration: 0.7)
		let starPopSequence = SKAction.sequence([waitTime, SKAction.group([popSound,growAction]), shrinkAction])
		
		growAction.timingMode = .easeInEaseOut
		shrinkAction.timingMode = .easeInEaseOut
		
		addChild(star1)
		addChild(star2)
		addChild(star3)
		
		star1.position = starHolder1.position
		star2.position = starHolder2.position
		star3.position = starHolder3.position
		
		run(SKAction.group([waitTime, successSong]))
		star1.run(setStartSize)
		star2.run(setStartSize)
		star3.run(setStartSize)
		
		star1.run(starPopSequence)
		star2.run(SKAction.sequence([
			waitTime, starPopSequence]))
		star3.run(SKAction.sequence([
			waitTime, waitTime, starPopSequence]))

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
