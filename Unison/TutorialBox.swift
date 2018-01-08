//
//  TutorialBox.swift
//  Unison
//
//  Created by Karl H Kuhn on 5/29/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialBox: SKNode {
	
	let textYStartPosition:CGFloat = 100
	
	var numberOfStars = 0
	
	let spacingIndent: CGFloat = 100
	
	let tutorialBoxBackground = SKSpriteNode(imageNamed: "plainBlackBox")
	
	
	override init() {
		super.init()
	}
	
	init(theText: String) {
		super.init()
		
		tutorialBoxBackground.size.height = tutorialBoxBackground.size.height * 0.60
		tutorialBoxBackground.size.width = tutorialBoxBackground.size.width * 1.5
		tutorialBoxBackground.run(SKAction.fadeAlpha(to: 0.75, duration: 0))
		addChild(tutorialBoxBackground)
		name = "TutorialBox"
		
		setupTutorialText(theText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	


func setupTutorialText(_ theText: String) {
	//		var numberOfLines: Int = 1
	let tutorialText = SKLabelNode(fontNamed: "Arial Bold")
	let textLine1 = SKLabelNode(fontNamed: "Arial Bold")
	let textLine2 = SKLabelNode(fontNamed: "Arial Bold")
	let textLine3 = SKLabelNode(fontNamed: "Arial Bold")
	let textLine4 = SKLabelNode(fontNamed: "Arial Bold")
	
	tutorialText.text = theText
	let lengthOfString = tutorialText.text!.characters.count
	print("Full text character count = \(tutorialText.text!.characters.count)")
	print("Full text = \(tutorialText.text)")
	//
	//		if lengthOfString > 0 && lengthOfString <= 68 {
	//			//			textLine1.text = tutorialText.text![0...68]
	//			for character in textLine1.text!.characters {
	//				while tutorialText.text!.characters.count > 63 && tutorialText.text!.characters.count < 68 {
	//					if character == " " {
	//						let index = tutorialText.text!.characters.indexOf(character)
	//						textLine1.text! = tutorialText.text!.substringToIndex(index!)
	//						break
	//					}
	//
	//				}
	//			}
	//			textLine1.fontColor = SKColor.whiteColor()
	//			textLine1.fontSize = 40
	//			textLine1.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 0)
	//			textLine1.zPosition = GameLayer.UIText.rawValue
	//			uiTutorialNode.tutorialBoxBackground.addChild(textLine1)
	//
	//			print("Line1 text = \(textLine1.text)")
	//
	//		}
	
	
	if lengthOfString > 0 && lengthOfString <= 68 {
		textLine1.text = tutorialText.text!
		textLine1.fontColor = SKColor.white
		textLine1.fontSize = 40
		textLine1.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 0)
		textLine1.zPosition = GameLayer.uiText.rawValue
		addChild(textLine1)
		
		print("Line1 text = \(textLine1.text)")
	}
	
	if lengthOfString > 68 && lengthOfString <= 136 {
		textLine1.text = tutorialText.text![0...68]
		textLine1.fontColor = SKColor.white
		textLine1.fontSize = 40
		textLine1.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 0)
		textLine1.zPosition = GameLayer.uiText.rawValue
		addChild(textLine1)
		
		textLine2.text = tutorialText.text![69...Int(lengthOfString - 1)]
		textLine2.fontColor = SKColor.white
		textLine2.fontSize = 40
		textLine2.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 1)
		textLine2.zPosition = GameLayer.uiText.rawValue
		addChild(textLine2)
		
	}
	
	if lengthOfString > 136 && lengthOfString <= 204 {
		textLine1.text = tutorialText.text![0...68]
		textLine1.fontColor = SKColor.white
		textLine1.fontSize = 40
		textLine1.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 0)
		textLine1.zPosition = GameLayer.uiText.rawValue
		addChild(textLine1)
		
		textLine2.text = tutorialText.text![69...135]
		textLine2.fontColor = SKColor.white
		textLine2.fontSize = 40
		textLine2.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 1)
		textLine2.zPosition = GameLayer.uiText.rawValue
		addChild(textLine2)
		
		textLine3.text = tutorialText.text![136...Int(lengthOfString - 1)]
		textLine3.fontColor = SKColor.white
		textLine3.fontSize = 40
		textLine3.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 2)
		textLine3.zPosition = GameLayer.uiText.rawValue
		addChild(textLine3)
		
		
	}
	
	if lengthOfString > 204 {
		textLine1.text = tutorialText.text![0...68]
		textLine1.fontColor = SKColor.white
		textLine1.fontSize = 40
		textLine1.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 0)
		textLine1.zPosition = GameLayer.uiText.rawValue
		addChild(textLine1)
		
		textLine2.text = tutorialText.text![69...135]
		textLine2.fontColor = SKColor.white
		textLine2.fontSize = 40
		textLine2.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 1)
		textLine2.zPosition = GameLayer.uiText.rawValue
		addChild(textLine2)
		
		textLine3.text = tutorialText.text![136...203]
		textLine3.fontColor = SKColor.white
		textLine3.fontSize = 40
		textLine3.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 2)
		textLine3.zPosition = GameLayer.uiText.rawValue
		addChild(textLine3)
		
		textLine4.text = tutorialText.text![204...Int(lengthOfString - 1)]
		textLine4.fontColor = SKColor.white
		textLine4.fontSize = 40
		textLine4.position = CGPoint(x: 0, y: textYStartPosition - gameTextLineBreakSpacer * 3)
		textLine4.zPosition = GameLayer.uiText.rawValue
		addChild(textLine4)
		
		
	}
}



}
