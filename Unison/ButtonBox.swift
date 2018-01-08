//
//  ButtonBox.swift
//  Unison
//
//  Created by Karl H Kuhn on 5/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class ButtonBox: SKNode {
	
	var levelIsUnlocked: Bool = false
	
	let levelButtonBox = SKSpriteNode(imageNamed: "levelBox")
	let levelButtonBoxText = SKLabelNode(fontNamed: "Arial Rounded Bold")
	let successStar1 = SKSpriteNode(imageNamed: "successStarHolder")
	let successStar2 = SKSpriteNode(imageNamed: "successStarHolder")
	let successStar3 = SKSpriteNode(imageNamed: "successStarHolder")
	let levelLock = SKSpriteNode(imageNamed: "LockForLevel")
	
	var chosenLevel: Int = 0
	
	override init() {
		
		super.init()
	}
	
	init(chosenLevel: Int, successStarCount: Int?, levelUnlocked: Bool?) {

		super.init()
		
		name = "buttonBox"
		zPosition = GameLayer.ui.rawValue
		self.chosenLevel = chosenLevel
		
		levelIsUnlocked = levelUnlocked!
		
		levelButtonBox.name = "levelButtonBox"
		levelButtonBox.anchorPoint = CGPoint(x: 0, y: 0)
		levelButtonBox.zPosition = GameLayer.ui.rawValue
		
		levelButtonBoxText.text = String(chosenLevel)
		levelButtonBoxText.name = "levelButtonBoxText"
		levelButtonBoxText.fontSize = CGFloat(64)
		levelButtonBoxText.fontColor = SKColor.black
		levelButtonBoxText.position = CGPoint(x: levelButtonBox.size.width / 2, y: levelButtonBox.size.height / 2 - levelButtonBoxText.fontSize / 2 + 30)
		levelButtonBoxText.zPosition = GameLayer.uiText.rawValue
		
		successStar1.position = CGPoint(x: 30, y: 20)
		successStar2.position = CGPoint(x: levelButtonBox.size.width / 2, y: 40)
		successStar3.position = CGPoint(x: levelButtonBox.size.width - 30, y: 20)
		
		levelLock.name = "LevelLock"
		
		
		addChild(levelButtonBox)
		levelButtonBox.addChild(levelButtonBoxText)

		if levelUnlocked! {
			if (successStarCount != nil) {
			
				switch successStarCount! {
				case 0: successStar1.texture = SKTexture(imageNamed: "successStarHolder")
				successStar2.texture = SKTexture(imageNamed: "successStarHolder")
				successStar3.texture = SKTexture(imageNamed: "successStarHolder")
					
				case 1: successStar1.texture = SKTexture(imageNamed: "successStar")
				
				case 2: successStar1.texture = SKTexture(imageNamed: "successStar")
					  successStar3.texture = SKTexture(imageNamed: "successStar")
				
				case 3: successStar1.texture = SKTexture(imageNamed: "successStar")
					  successStar2.texture = SKTexture(imageNamed: "successStar")
					  successStar3.texture = SKTexture(imageNamed: "successStar")
					
				default: return
				}
			}
			
			levelButtonBox.addChild(successStar1)
			levelButtonBox.addChild(successStar2)
			levelButtonBox.addChild(successStar3)
		} else if !levelUnlocked! {
			levelLock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			levelLock.position = CGPoint(x: levelButtonBox.size.width / 2, y: levelButtonBox.size.height / 2)
			levelLock.zPosition = 200
			levelButtonBox.addChild(levelLock)
		}


	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
