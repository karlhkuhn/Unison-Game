//
//  WallPath.swift
//  Unison
//
//  Created by Karl H Kuhn on 4/30/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit



class WallPath: SKShapeNode {
	
	let thePath = CGMutablePath()
//	var theTexture = SKTexture?()
	var bounceType: WallBounceType?
	
	override init() {
		
		
		super.init()
	}
	
	init(wallBounceType: WallBounceType, wallPoints: [CGPoint]) {
		super.init()
		
		bounceType = wallBounceType
		
		createWallPath(wallPoints)
		
	}
//	
	func createWallPath(_ linePoints: [CGPoint]) {
		thePath.move(to: linePoints[0])

		for thePoint in 1..<linePoints.count {
			thePath.addLine(to: linePoints[thePoint])
		}
		
		self.path = thePath
		self.lineWidth = 25.0
		self.zPosition = GameLayer.obstacle.rawValue
		
		physicsBody = SKPhysicsBody(edgeChainFrom: thePath)
		physicsBody?.contactTestBitMask = PhysicsCategory.Player
		physicsBody?.collisionBitMask = PhysicsCategory.Player

	}
	

	
	
	

	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

