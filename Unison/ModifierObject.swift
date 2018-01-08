//
//  ModifierObject.swift
//  Unison
//
//  Created by Karl H Kuhn on 5/8/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class ModifierObject: GameObject {
	
	var modifierType: ModifierType?
	
	
	override init() {
		super.init()
	}
	
	
	init(modifierType: ModifierType, at position: CGPoint, size: CGSize ) {
		super.init()
		
		bodySize = size
		self.position = position
		self.grid = grid
		self.modifierType = modifierType
		
		setupBody(modifierType)
		
//		if grid != nil {
//			switch grid! {
//			case .Player: body!.position = matrixGridLeft[position]!
//			case .Mirror: body!.position = matrixGridRight[position]!
//			case .None: return
//			}
//		}
	
	}

	
	required convenience init?(coder aDecoder: NSCoder) {
		let positionDecoded = aDecoder.decodeCGPoint(forKey: "position")
		let modifierTypeDecoded = aDecoder.decodeInteger(forKey: "modifierType")
//		let gridDecoded = aDecoder.decodeObjectForKey("grid") as? Int
		let sizeDecoded = aDecoder.decodeCGSize(forKey: "size")
		
		self.init()
		
		modifierType = ModifierType(rawValue: Int(modifierTypeDecoded))
//		grid = Grid(rawValue: gridDecoded!)
		bodySize = sizeDecoded
		self.position = positionDecoded
		setupBody(modifierType!)
	}
	
	override func encode(with coder: NSCoder) {
		coder.encode(self.position, forKey: "position")
		coder.encode(self.modifierType!.rawValue, forKey: "modifierType")
//		coder.encodeObject(self.grid!.rawValue, forKey: "grid")
		coder.encode(self.bodySize!, forKey: "size")
	}
	
	func setupBody(_ theModifierType: ModifierType) {
		switch theModifierType {
		case .doubleMover: body = SKSpriteNode(imageNamed: "modifierDoubleMover")
		body!.name = "DoubleMover"
		body!.zPosition = GameLayer.modifierDoubleMover.rawValue
		case .holder: body = SKSpriteNode(imageNamed: "modifierHolder")
		body!.name = "Holder"
		body!.zPosition = GameLayer.modifierHolder.rawValue
		case .oppositer: body = SKSpriteNode(imageNamed: "modifierOppositer")
		body!.name = "Oppositer"
		body!.zPosition = GameLayer.modifierOppositer.rawValue
		case .none: return
		}
		
		
		body!.size = bodySize!
		body!.position = CGPoint.zero
		body!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		body!.physicsBody = SKPhysicsBody(rectangleOf: body!.size)
		body!.physicsBody?.categoryBitMask = PhysicsCategory.Modifier
		body!.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.MirrorPlayer | PhysicsCategory.BackGroundTile
		body!.physicsBody?.collisionBitMask = PhysicsCategory.None
//		body!.physicsBody?.isDynamic
		addChild(body!)

	}
}
