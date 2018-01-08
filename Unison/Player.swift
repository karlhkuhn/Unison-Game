//
//  Player.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/27/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
	
	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
		self.texture = texture
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("coder aDecoder not loaded")
	}

}
