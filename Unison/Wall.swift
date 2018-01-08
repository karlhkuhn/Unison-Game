//
//  Wall.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/28/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//



import SpriteKit

class Wall: GameObject {
	

	
	
	override init() {
		
		super.init()
		
	}
	
	convenience init(wallAxisType: WallAxisType, wallBounceType: WallBounceType, bodySize: CGSize, position: CGPoint) {
		self.init()
		
		setWall(wallAxisType, bounceType: wallBounceType, bodySize: bodySize)
		self.position = position
		self.axisType = wallAxisType
		print("The init axisType is \(self.axisType!.rawValue)")
		self.bounceType = wallBounceType
		self.bodySize = bodySize
		name = "WallNode"
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let positionDecoded = aDecoder.decodeCGPoint(forKey: "position")
		let axisTypeDecoded = aDecoder.decodeInteger(forKey: "axisType")
//		let axisTypeDecoded = aDecoder.decodeObject(forKey: "axisType") as! Int
		let bounceTypeDecoded = aDecoder.decodeInteger(forKey: "bounceType")
		let sizeDecoded = aDecoder.decodeCGSize(forKey: "size")
		
		self.init()

		self.axisType = WallAxisType(rawValue: Int(axisTypeDecoded))
		bounceType = WallBounceType(rawValue: Int(bounceTypeDecoded))
		bodySize = sizeDecoded
		setWall(axisType!, bounceType: bounceType!, bodySize: sizeDecoded)
		self.position = positionDecoded
		name = "WallNode"
	}
	
	override func encode(with coder: NSCoder) {
		coder.encode(self.position, forKey: "position")
		coder.encode(self.axisType!.rawValue, forKey: "axisType")
		print("The axis type int is \(self.axisType!.rawValue)")
		coder.encode(self.bounceType!.rawValue, forKey: "bounceType")
		coder.encode(self.bodySize!, forKey: "size")
		coder.encode(self.name, forKey: "bodyName")
	}

	
	
	
	func changeWallType(_ bounceType: WallBounceType) {
		if bounceType == WallBounceType.verticalWall {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wallObstacle.png")))
			body!.name = "VerticalWall"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.VerticalWall
			
		} else if bounceType  == WallBounceType.horizontalWall {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wallObstacle.png")))
			body!.name = "HorizontalWall"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalWall
			
		} else if bounceType == WallBounceType.verticalWallDeivation {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wallDeivationObstacle.png")))
			body!.name = "VerticalWallDeivation"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.VerticalWallDeivation
			
		} else if bounceType == WallBounceType.horizontalWallDeivation {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wallDeivationObstacle.png")))
			body!.name = "HorizontalWallDeivation"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalWallDeivation
			
		}  else if bounceType  == WallBounceType.verticalSpikedWall {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wood-spike-block.png")))
			body!.name = "VerticalSpikedWall"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.VerticalSpikedWall
			
		}  else if bounceType  == WallBounceType.horizontalSpikedWall {
			body!.run(SKAction.setTexture(SKTexture(imageNamed: "wood-spike-block.png")))
			body!.name = "HorizontalSpikedWall"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalSpikedWall
		}
	}
	
	func setWallAxisType(_ theAxisType: WallAxisType, wallBounceType: WallBounceType) {
		
	}
	
	
	func setWall(_ wallAxisType: WallAxisType, bounceType: WallBounceType, bodySize: CGSize) {
		
		//SET A VERTICAL WALL
		if bounceType == WallBounceType.verticalWall {
			body = SKSpriteNode(imageNamed: "wallObstacle.png")
			addChild(body!)
			body!.name = "VerticalWall"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.VerticalWall
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player
			body?.physicsBody?.isDynamic = false
			body?.zRotation = π / 2

			//SET A HORIZONTAL WALL
		} else if bounceType == WallBounceType.horizontalWall {
			body = SKSpriteNode(imageNamed: "wallObstacle.png")
			addChild(body!)
			body!.name = "HorizontalWall"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalWall
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player
			body?.physicsBody?.isDynamic = false
			
			//SET A VERTICAL SPIKED WALL
		} else if bounceType  == WallBounceType.verticalSpikedWall {
			body = SKSpriteNode(imageNamed: "wood-spike-block.png")
			addChild(body!)
			body!.name = "VerticalSpikedWall"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.VerticalSpikedWall
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.MirrorPlayer
			body?.physicsBody?.isDynamic = false
			body?.zRotation = π / 2
			
			//SET A HORIZONTAL SPIKED WALL
		} else if bounceType  == WallBounceType.horizontalSpikedWall {
			body = SKSpriteNode(imageNamed: "wood-spike-block.png")
			addChild(body!)
			body!.name = "HorizontalSpikedWall"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalSpikedWall
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.MirrorPlayer
			body?.physicsBody?.isDynamic = false
			
			//SET A VERTICAL WALL DEIVATION
		} else if bounceType == WallBounceType.verticalWallDeivation {
			body = SKSpriteNode(imageNamed: "wallDeivationObstacle.png")
			addChild(body!)
			body!.name = "VerticalWallDeivation"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.VerticalWallDeivation
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player
			body?.physicsBody?.isDynamic = false
			body?.zRotation = π / 2
			
			//SET A HORIZONTAL WALL DEIVATION
		} else if bounceType == WallBounceType.horizontalWallDeivation {
			body = SKSpriteNode(imageNamed: "wallDeivationObstacle.png")
			addChild(body!)
			body!.name = "HorizontalWallDeivation"
			body!.zPosition = GameLayer.wall.rawValue
			body?.size = bodySize
			body?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			body?.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: 0))
			body?.physicsBody?.categoryBitMask = PhysicsCategory.HorizontalWallDeivation
			body?.physicsBody?.contactTestBitMask = PhysicsCategory.Player
			body?.physicsBody?.isDynamic = false
		}
		
		
		
	}

}
