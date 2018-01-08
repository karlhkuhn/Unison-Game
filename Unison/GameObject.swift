//
//  Wall.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/28/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//


import Foundation
import SpriteKit

class GameObject: SKNode {
	
	var body: SKSpriteNode?
	var axisType: WallAxisType?
	var bounceType: WallBounceType?
	var bodySize: CGSize?
	var grid: Grid?
	
	override init() {
		super.init()
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let positionDecoded = aDecoder.decodeCGPoint(forKey: "position")
		let sizeDecoded = aDecoder.decodeCGSize(forKey: "size")
		
		self.init()
		
		bodySize = sizeDecoded
		self.position = positionDecoded
		
		
	}
	
	override func encode(with coder: NSCoder) {
		coder.encode(self.position, forKey: "position")
		coder.encode(self.bodySize!, forKey: "size")
	}
	
	func setHorizontalWallRotation() {
		zRotation = CGFloat(90).degreesToRadians()
	}
	
	
	
}
