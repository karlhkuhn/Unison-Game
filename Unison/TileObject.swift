//
//  TileObject
//  Unison
//
//  Created by Karl H Kuhn on 1/26/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class TileObject: SKNode {
	
	
	var isTouchHeld = false
	var theTile: SKSpriteNode
	let thePath = CGMutablePath()
	var highlightBox = SKShapeNode()

	
	override init() {
		
		theTile = SKSpriteNode()
		
		super.init()
	}
	
	convenience init(grid: Grid) {
		
		self.init()
		
		switch grid {
			
		case .player:
			theTile = SKSpriteNode(imageNamed: "StandardYellowBlock")
			theTile.name = "YellowTile"
			
		case .mirror:
			theTile = SKSpriteNode(imageNamed: "StandardSilverBlock")
			theTile.name = "SilverTile"
		
		case .none:
			return
		}

		addChild(theTile)
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addHighlight() {
		highlightBox.path = CGPath(rect: CGRect(x: -theTile.size.width / 2, y: -theTile.size.height / 2, width: theTile.size.width, height: theTile.size.height), transform: nil)
		highlightBox.strokeColor = UIColor.red
		highlightBox.lineWidth = 10
		highlightBox.fillColor = UIColor.clear
		highlightBox.name = "HighlightBox"
		addChild(highlightBox)
	}
	
	func removeHighlight() {
		highlightBox.removeFromParent()
	}
	
}
