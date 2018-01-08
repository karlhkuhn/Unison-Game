//
//  Wall.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/28/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//



import SpriteKit

class DodgeBall: Wall {
	
	
	override init() {

		super.init()
	}

//	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
//		
//		
//		super.init(texture: texture, color: color, size: size)
//		
//		
//		name = "DodgeBall"
//		zPosition = GameLayer.DodgeBall.rawValue
//		anchorPoint = CGPoint(x: 0.5, y: 0.5)
//		physicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPoint(x: 0, y: 0))
//		physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
//		physicsBody?.contactTestBitMask = PhysicsCategory.Player
//		physicsBody?.dynamic = false
//		
//	}
//	
//	convenience init(imageNamed name: String) {
//		self.init()
//		
//		self.texture = SKTexture(imageNamed: name)
//		
//	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("coder aDecoder not loaded")
	}
	

	

	
	
}
