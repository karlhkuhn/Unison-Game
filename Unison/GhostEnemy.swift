//
//  Player.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/27/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class GhostEnemy: SKNode {
	
	var emitter: SKEmitterNode
	var ghostBody: SKSpriteNode
	var eyes: SKSpriteNode
	
	var eyePositionStartX:CGFloat = 0
	var eyePositionStartY:CGFloat = 10
	
	let eyeMoveDistance: CGFloat = 5
	
	
	override init() {

		emitter = SKEmitterNode(fileNamed: "ModifierParticles.sks")!
		ghostBody = SKSpriteNode(imageNamed: "ghostBadGuy")
		eyes = SKSpriteNode(imageNamed: "badGuyEyes")
		
		super.init()
		
		addChild(ghostBody)
		addChild(eyes)
		eyes.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		eyes.position = CGPoint(x: 0, y: 10)

		emitter.name = "modifierEmitter"
		emitter.zPosition = GameLayer.modifierParticles.rawValue
		emitter.particleBirthRate = 0
		addChild(emitter)
		

	
	}
	
	func eyesLook(_ direction: String) {
		let lookCenter = SKAction.move(to: CGPoint(x: 0, y: eyePositionStartY), duration: 0.5)
		let lookLeft = SKAction.move(to: CGPoint(x: eyePositionStartX - eyeMoveDistance, y: eyePositionStartY), duration: 0.5)
		let lookRight = SKAction.move(to: CGPoint(x: eyePositionStartX + eyeMoveDistance, y: eyePositionStartY), duration: 0.5)
		let lookUp = SKAction.move(to: CGPoint(x: eyePositionStartX, y: eyePositionStartY + eyeMoveDistance), duration: 0.5)
		let lookDown = SKAction.move(to: CGPoint(x: eyePositionStartX, y: eyePositionStartY - eyeMoveDistance), duration: 0.5)

		
		if direction == "Left" {
			eyes.run(SKAction.sequence([
//				lookCenter,
				lookLeft
				]))
		} else if direction == "Right" {
			eyes.run(SKAction.sequence([
//				lookCenter,
				lookRight
				]))
		} else if direction == "Up" {
			eyes.run(SKAction.sequence([
//				lookCenter,
				lookUp
				]))
		} else if direction == "Down" {
			eyes.run(SKAction.sequence([
//				lookCenter,
				lookDown
				]))
		} else {
			eyes.run(lookCenter)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("coder aDecoder not loaded")
	}


	

}
