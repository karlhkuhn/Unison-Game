//
//  FinalWinScene.swift
//  Unison
//
//  Created by Karl H Kuhn on 12/12/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit
import Foundation


class FinalWinScene: SKScene {

	var totalTextSpacing: CGFloat = 0
	let textLineGroupSpacer: CGFloat = 120
	let textLineSpacer: CGFloat = 70
	
	let textFontSize: CGFloat = 50
	let titleFontSize: CGFloat = 70
	
	let playableRect: CGRect
	let playableHeight: CGFloat
	let playableMargin: CGFloat

	var backgroundNode = SKNode()
	var cloudsNode = SKNode()
	var sunNode = SKNode()
	var playersNode = SKNode()
	var textNode = SKNode()
	var playerNode = SKNode()
	var uiNode = SKNode()
	var thanksNode = SKNode()
	
	var animationGraphicArray = [SKSpriteNode]()
	var animationStartPosition: CGPoint
	
	var scrollTextArrayGroup1 = [SKNode]()
	var scrollTextArrayGroup2 = [SKNode]()
	var scrollTextArrayGroup3 = [SKNode]()
	var scrollTextArrayGroup4 = [SKNode]()
	
	let cloudsImage = SKSpriteNode(imageNamed: "FinalWinSceneClouds")
	let cloudsImage2 = SKSpriteNode(imageNamed: "FinalWinSceneClouds")
	let cloudsMovePerSec: CGFloat = 100
	var dt: TimeInterval = 0.02


	let blackFadeImage = SKSpriteNode(imageNamed: "FinalWinSceneBlackFade")
	let groundImage = SKSpriteNode(imageNamed: "FinalWinSceneGround")
	let sunImage = SKSpriteNode(imageNamed: "FinalWinSceneSun")
	let skyImage = SKSpriteNode(imageNamed: "FinalWinSceneSky")
	let greenPlayerSad = SKSpriteNode(imageNamed: "GreenPlayerSad")
	let redPlayerSad = SKSpriteNode(imageNamed: "RedPlayerSad")
	let backbutton = SKSpriteNode(imageNamed: "backArrow")
	
	let thanksMessage = SKLabelNode(fontNamed: "BubbleGum")

	let scrollTitleText = SKSpriteNode(imageNamed: "unisonTitle")
	
	
	let scrollText2 = SKLabelNode(text: "Designed and Developed by")
	let scrollText3 = SKLabelNode(text: "Karl Kuhn")
	
	let scrollText4 = SKLabelNode(text: "Original Graphics Created Using:")
	let scrollText5 = SKLabelNode(text: "Pixelmator")
	let scrollText6 = SKLabelNode(text: "www.pixelmator.com")
	
	let scrollText7 = SKLabelNode(text: "Music Created Using:")
	let scrollText8 = SKLabelNode(text: "Garageband")
	let scrollText9 = SKLabelNode(text: "www.apple.com/mac/garageband")
	
	let scrollText10 = SKLabelNode(text: "Additional Resources Provided By:")
	let scrollText11 = SKLabelNode(text: "Game Art Guppy")
	let scrollText12 = SKLabelNode(text: "www.gameartguppy.com")
	let scrollText13 = SKLabelNode(text: "Jeremy Sykes")
	let scrollText14 = SKLabelNode(text: "\"Powerup04.wav\"")
	let scrollText15 = SKLabelNode(text: "www.freesound.org/people/jeremysykes/sounds/341682/")
	let scrollText16 = SKLabelNode(text: "www.sharesynth.com")
	let scrollText17 = SKLabelNode(text: "CC01")
	
	let cloudsStartPosition: CGPoint
	let groundStartPosition: CGPoint
	

	
	override init(size: CGSize) {
		let maxAspectRatio:CGFloat = 16.0/9.0
		playableHeight = size.width / maxAspectRatio
		playableMargin = (size.height-playableHeight)/2.0
		playableRect = CGRect(x: 0, y: playableMargin,
		                      width: size.width,
		                      height: playableHeight)
		animationStartPosition = CGPoint(x: -playableRect.size.width * 2, y: playableRect.size.height * 3)
		
		cloudsStartPosition = CGPoint(x: 0, y: playableHeight - cloudsImage.size.height + 150)
		groundStartPosition = CGPoint(x: 0, y: playableMargin)
		
		scrollTextArrayGroup1 = [scrollText2,
		                         scrollText3]
		
		scrollTextArrayGroup2 = [scrollText4,
						 scrollText5,
						 scrollText6]
		
		scrollTextArrayGroup3 = [scrollText7,
						 scrollText8,
						 scrollText9]
		
		scrollTextArrayGroup4 = [scrollText10,
						 scrollText11,
						 scrollText12,
						 scrollText13,
						 scrollText14,
						 scrollText15,
						 scrollText16,
						 scrollText17]
		
		super.init(size: size)
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMove(to view: SKView) {
//			let finalWinSceneSong = URL(fileURLWithPath: "FinalWinSceneSong.mp3")
		

		playBackgroundMusic("FinalWinSceneSong.mp3")
		
		setupNodeLayers()
		textNode.zPosition = 75
		setupBackground()
		createScrollText()
		scrollTextUp()
		setupCloudMove()
		moveClouds()
		moveSun()
		setupPlayers()
		setupBackButton()
		setupThanksForPlaying()
	}
	

	
	func setupNodeLayers() {
		addChild(backgroundNode)
		backgroundNode.addChild(textNode)
		backgroundNode.addChild(skyImage)
		backgroundNode.addChild(sunNode)
		backgroundNode.addChild(groundImage)
		backgroundNode.addChild(cloudsNode)
		backgroundNode.addChild(thanksNode)
		backgroundNode.addChild(playerNode)
		backgroundNode.addChild(uiNode)
	}
	
	func setupPlayers() {
		
		greenPlayerSad.anchorPoint = CGPoint(x: 0.5, y: 0)
		greenPlayerSad.position = CGPoint(x: playableRect.size.width * 0.65, y: playableMargin + groundImage.size.height - 20)
		greenPlayerSad.size = CGSize(width: 100, height: 100)
		
		playerNode.addChild(greenPlayerSad)
		
		
		redPlayerSad.anchorPoint = CGPoint(x: 0.5, y: 0)
		redPlayerSad.position = CGPoint(x: greenPlayerSad.position.x + greenPlayerSad.size.width + 50, y: playableMargin + groundImage.size.height - 20)
		redPlayerSad.size = CGSize(width: 100, height: 100)
		
		playerNode.addChild(redPlayerSad)
		
		movePlayer()
	}
	
	func setupThanksForPlaying() {
		
		thanksMessage.text = "Thanks For Playing!"
		thanksMessage.fontColor = SKColor.blue
		thanksMessage.fontSize = 159
		thanksMessage.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height / 2 + 150)
		thanksNode.addChild(thanksMessage)
		
		thanksMessage.run(SKAction.sequence([
			SKAction.fadeAlpha(to: 0, duration: 0),
			SKAction.fadeAlpha(to: 1, duration: 0.25),
			SKAction.wait(forDuration: 4),
			SKAction.fadeAlpha(to: 0, duration: 0.5),
			SKAction.wait(forDuration: 45),
			SKAction.fadeAlpha(to: 1, duration: 1)]))

	}
	
	func movePlayer() {
		
		let moveRight = SKAction.moveBy(x: 500, y: 0, duration: 2)
		let moveLeft = SKAction.moveBy(x: -700, y: 0, duration: 1)
		let moveRight2 = SKAction.moveBy(x: 200, y: 0, duration: 1)
		let moveLeft2 = SKAction.moveBy(x: -400, y: 0, duration: 2)
		let moveRight3 = SKAction.moveBy(x: 100, y: 0, duration: 1)
		let moveLeft3 = SKAction.moveBy(x: -600, y: 0, duration: 1)
		let moveRight4 = SKAction.moveBy(x: 500, y: 0, duration: 2)
		let moveLeft4 = SKAction.moveBy(x: -700, y: 0, duration: 1)
		
		let firstSequence = SKAction.sequence([moveRight, moveLeft])
		let secondSequence = SKAction.sequence([moveRight2, moveLeft2])
		let thirdSequence = SKAction.sequence([moveRight3, moveLeft3])
		let fourthSequence = SKAction.sequence([moveRight4, moveLeft4])
		
		let forwardSequenceGroup = SKAction.sequence([firstSequence, secondSequence, thirdSequence, fourthSequence])
		let reverseSequenceGroup = SKAction.reversed(forwardSequenceGroup)
		
		playerNode.run(SKAction.repeatForever(SKAction.sequence([
			forwardSequenceGroup, reverseSequenceGroup()
			])))
	}
	
	func setupBackground() {
		skyImage.anchorPoint = CGPoint.zero
		skyImage.position = CGPoint.zero
		
		groundImage.anchorPoint = CGPoint.zero
		groundImage.position = groundStartPosition
		
		
	}
	
	func moveSun() {
		sunImage.anchorPoint = CGPoint(x: 0.5, y: 1)
		sunImage.position = CGPoint(x: 0, y: playableMargin + groundImage.size.height)
		
		sunNode.addChild(sunImage)
		
		let sunMoveAction = SKAction.move(to: CGPoint(x: playableRect.size.width + sunImage.size.width, y: sunImage.size.height * 2), duration: 100)
		
		sunNode.run(sunMoveAction)
	}
	
	func setupCloudMove() {
		cloudsImage.anchorPoint = CGPoint.zero
		cloudsImage.position = cloudsStartPosition
		cloudsImage.name = "cloudBackground"
		cloudsImage2.anchorPoint = CGPoint.zero
		cloudsImage2.position = CGPoint(x: cloudsImage.position.x + cloudsImage.size.width, y: cloudsImage.position.y)
		cloudsImage2.name = "cloudBackground"
		
		cloudsNode.addChild(cloudsImage)
		cloudsNode.addChild(cloudsImage2)
	}
	
	func moveClouds() {

		cloudsNode.enumerateChildNodes(withName: "cloudBackground") {node, _ in
			
			let clouds = node as! SKSpriteNode
			let backgroundVelocity = CGPoint(x: -self.cloudsMovePerSec, y: 0)
			let amountToMove = backgroundVelocity * CGFloat(self.dt)
			clouds.position += amountToMove
			
			if clouds.position.x <= -clouds.size.width {
				clouds.position = CGPoint(
					x: clouds.position.x + clouds.size.width + self.playableRect.size.width,
					y: clouds.position.y)
			}
		}
	}
	
	func setupBackButton() {
		backbutton.anchorPoint = CGPoint.zero
		backbutton.position = CGPoint(x: 100, y: 200)
		backbutton.name = "backButton"
		uiNode.addChild(backbutton)
		
		backbutton.run(SKAction.sequence([
			SKAction.fadeAlpha(to: 0, duration: 0),
			SKAction.wait(forDuration: 10),
			SKAction.fadeAlpha(to: 1, duration: 0.5)]))

	}
	
	func createScrollText() {

		scrollTitleText.position = CGPoint(x: playableRect.width/2, y: 0 - scrollTitleText.size.height)

		
		scrollText2.position = CGPoint(x: playableRect.width/2, y:  scrollTitleText.position.y - textLineGroupSpacer * 2)
		scrollText2.fontSize = CGFloat(titleFontSize)
		scrollText2.fontColor = UIColor.blue
		scrollText2.fontName = ("Arial-BoldMT")

		scrollText3.position = CGPoint(x: playableRect.width/2, y:  scrollText2.position.y - textLineSpacer)
		scrollText3.fontSize = CGFloat(textFontSize)
		scrollText3.fontColor = UIColor.black
		scrollText3.fontName = ("ArialMT")

		
		
		scrollText4.position = CGPoint(x: playableRect.width/2, y:  scrollText3.position.y - textLineGroupSpacer)
		scrollText4.fontSize = CGFloat(titleFontSize)
		scrollText4.fontColor = UIColor.blue
		scrollText4.fontName = ("Arial-BoldMT")
		
		scrollText5.position = CGPoint(x: playableRect.width/2, y:  scrollText4.position.y - textLineSpacer)
		scrollText5.fontSize = CGFloat(textFontSize)
		scrollText5.fontColor = UIColor.black
		scrollText5.fontName = ("Arial-BoldMT")
		
		scrollText6.position = CGPoint(x: playableRect.width/2, y:  scrollText5.position.y - textLineSpacer)
		scrollText6.fontSize = CGFloat(textFontSize)
		scrollText6.fontColor = UIColor.black
		scrollText6.fontName = ("ArialMT")
		
		
		
		scrollText7.position = CGPoint(x: playableRect.width/2, y:  scrollText6.position.y - textLineGroupSpacer)
		scrollText7.fontSize = CGFloat(titleFontSize)
		scrollText7.fontColor = UIColor.blue
		scrollText7.fontName = ("Arial-BoldMT")
		
		scrollText8.position = CGPoint(x: playableRect.width/2, y:  scrollText7.position.y - textLineSpacer)
		scrollText8.fontSize = CGFloat(textFontSize)
		scrollText8.fontColor = UIColor.black
		scrollText8.fontName = ("Arial-BoldMT")
		
		scrollText9.position = CGPoint(x: playableRect.width/2, y:  scrollText8.position.y - textLineSpacer)
		scrollText9.fontSize = CGFloat(textFontSize)
		scrollText9.fontColor = UIColor.black
		scrollText9.fontName = ("ArialMT")
		
		
		
		scrollText10.position = CGPoint(x: playableRect.width/2, y:  scrollText9.position.y - textLineGroupSpacer)
		scrollText10.fontSize = CGFloat(titleFontSize)
		scrollText10.fontColor = UIColor.blue
		scrollText10.fontName = ("Arial-BoldMT")
		
		scrollText11.position = CGPoint(x: playableRect.width/2, y:  scrollText10.position.y - textLineSpacer)
		scrollText11.fontSize = CGFloat(textFontSize)
		scrollText11.fontColor = UIColor.black
		scrollText11.fontName = ("Arial-BoldMT")
		
		scrollText12.position = CGPoint(x: playableRect.width/2, y:  scrollText11.position.y - textLineSpacer)
		scrollText12.fontSize = CGFloat(textFontSize)
		scrollText12.fontColor = UIColor.black
		scrollText12.fontName = ("ArialMT")
		
		scrollText13.position = CGPoint(x: playableRect.width/2, y:  scrollText12.position.y - textLineGroupSpacer)
		scrollText13.fontSize = CGFloat(textFontSize)
		scrollText13.fontColor = UIColor.black
		scrollText13.fontName = ("Arial-BoldMT")
		
		scrollText14.position = CGPoint(x: playableRect.width/2, y:  scrollText13.position.y - textLineSpacer)
		scrollText14.fontSize = CGFloat(textFontSize)
		scrollText14.fontColor = UIColor.black
		scrollText14.fontName = ("ArialMT")
		
		scrollText15.position = CGPoint(x: playableRect.width/2, y:  scrollText14.position.y - textLineSpacer)
		scrollText15.fontSize = CGFloat(textFontSize)
		scrollText15.fontColor = UIColor.black
		scrollText15.fontName = ("ArialMT")
		
		scrollText16.position = CGPoint(x: playableRect.width/2, y:  scrollText15.position.y - textLineSpacer)
		scrollText16.fontSize = CGFloat(textFontSize)
		scrollText16.fontColor = UIColor.black
		scrollText16.fontName = ("ArialMT")
		
		scrollText17.position = CGPoint(x: playableRect.width/2, y:  scrollText16.position.y - textLineSpacer)
		scrollText17.fontSize = CGFloat(textFontSize)
		scrollText17.fontColor = UIColor.black
		scrollText17.fontName = ("ArialMT")
		
		textNode.addChild(scrollTitleText)
		textNode.addChild(scrollText2)
		textNode.addChild(scrollText3)
		textNode.addChild(scrollText4)
		textNode.addChild(scrollText5)
		textNode.addChild(scrollText6)
		textNode.addChild(scrollText7)
		textNode.addChild(scrollText8)
		textNode.addChild(scrollText9)
		textNode.addChild(scrollText10)
		textNode.addChild(scrollText11)
		textNode.addChild(scrollText12)
		textNode.addChild(scrollText13)
		textNode.addChild(scrollText14)
		textNode.addChild(scrollText15)
		textNode.addChild(scrollText16)
		textNode.addChild(scrollText17)
		
	}
	
	func scrollTextUp() {
		let textMoveAction = SKAction.moveBy(x: 0, y: 5000, duration: 80)
		
		textNode.run(textMoveAction)
	}
	
	override func update(_ currentTime: TimeInterval) {
		moveClouds()
	}
	
	func newGame() {
		let newScene = MainMenuScene(size: gameSize)
		let transition = SKTransition.crossFade(withDuration: 1)
		newScene.scaleMode = .aspectFill
		playBackgroundMusic("MainMenuNewSong.mp3")
		view!.presentScene(newScene, transition: transition)

	}
	
	
	// MARK: USER INPUT
	
	func sceneTouched(_ location: CGPoint) {
		
		let targetNode = self.atPoint(location)
		
		if targetNode.name == "backButton" {
			run(SKAction.sequence([
				SKAction.group([
					playButtonPressSound,
					SKAction.fadeOut(withDuration: 1)
					]),
				SKAction.run(newGame)
				]))

		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		sceneTouched(touches.first!.location(in: self))
		
	}
	
	

}
