//
//  Wall.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/28/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//



import SpriteKit

class PlayerObject: GameObject {
	
	var emitter: SKEmitterNode

	var playerType: Grid?
	
	
	override init() {
		emitter = SKEmitterNode(fileNamed: "ModifierParticles.sks")!

		super.init()
		
		emitter.name = "modifierEmitter"
		emitter.zPosition = GameLayer.modifierParticles.rawValue
		emitter.particleBirthRate = 0
		addChild(emitter)
		
	}
	
	convenience init(playerType: Grid, bodySize: CGSize, position: CGPoint) {
		self.init()
		
		self.position = position
		self.playerType = playerType
		self.bodySize = bodySize
		
		createPlayer(playerType, size: bodySize)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let positionDecoded = aDecoder.decodeCGPoint(forKey: "position")
		let playerTypeDecoded = aDecoder.decodeCInt(forKey: "playerType")
		let sizeDecoded = aDecoder.decodeCGSize(forKey: "size")
		
		self.init()

		playerType = Grid(rawValue: Int(playerTypeDecoded))
		bodySize = sizeDecoded
		self.position = positionDecoded
		createPlayer(playerType!, size: bodySize!)
	}
	
	override func encode(with coder: NSCoder) {
		coder.encode(self.position, forKey: "position")
		coder.encode(self.playerType!.rawValue, forKey: "playerType")
		coder.encode(self.bodySize!, forKey: "size")
	}

	
	
	func createPlayer(_ playerType: Grid, size: CGSize) {
		
		

		if playerType == Grid.player {
			name = "Player"
			body = SKSpriteNode(imageNamed: "GreenPlayerSad")
			body!.size = size
			body!.name = "PlayerBody"
			body!.zPosition = GameLayer.player.rawValue
			body!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			physicsBody = SKPhysicsBody(rectangleOf: bodySize!, center: CGPoint(x: 0.5, y: 0.5))
			physicsBody!.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Enemy | PhysicsCategory.EnemyUpDown | PhysicsCategory.EnemyLeftRight | PhysicsCategory.Goal | PhysicsCategory.BackGroundTile
			physicsBody!.collisionBitMask =
				PhysicsCategory.VerticalWall
				| PhysicsCategory.VerticalWallDeivation
				| PhysicsCategory.HorizontalWall
				| PhysicsCategory.HorizontalWallDeivation
				| PhysicsCategory.VerticalSpikedWall
				| PhysicsCategory.HorizontalSpikedWall
			physicsBody!.categoryBitMask = PhysicsCategory.Player
		} else if playerType == Grid.mirror {
			name = "MirrorPlayer"
			body = SKSpriteNode(imageNamed: "RedPlayerSad")
			body!.size = size
			body!.name = "MirrorPlayerBody"
			body!.zPosition = GameLayer.mirrorPlayer.rawValue
			body!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			physicsBody = SKPhysicsBody(rectangleOf: bodySize!, center: CGPoint(x: 0.5, y: 0.5))
			physicsBody!.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Enemy | PhysicsCategory.EnemyUpDown | PhysicsCategory.EnemyLeftRight | PhysicsCategory.Goal | PhysicsCategory.BackGroundTile
			physicsBody!.collisionBitMask =
				PhysicsCategory.VerticalWall
				| PhysicsCategory.VerticalWallDeivation
				| PhysicsCategory.HorizontalWall
				| PhysicsCategory.HorizontalWallDeivation
				| PhysicsCategory.VerticalSpikedWall
				| PhysicsCategory.HorizontalSpikedWall
			physicsBody!.categoryBitMask = PhysicsCategory.MirrorPlayer

		}

		addChild(body!)
		
		

	}
	

}
