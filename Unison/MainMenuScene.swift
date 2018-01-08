//
//  MainMenuScene
//  Unison
//
//  Created by Karl H Kuhn on 1/26/16.
//  Copyright (c) 2016 Karl Kuhn. All rights reserved.
//
// --------

import SpriteKit
import Foundation
import AVFoundation



class MainMenuScene: SKScene {
	
	let isFirstLaunch = UserDefaults.isFirstLaunch()
	let levelsScene = LevelsScene(size:(CGSize(width: 2048, height: 1536)))
	
	let playableRect: CGRect
	let playableHeight: CGFloat
	let playableMargin: CGFloat
	
	var animationsNode = SKNode()
	
	var animationGraphicArray = [SKSpriteNode]()
	var animationStartPosition: CGPoint
	
	
	override init(size: CGSize) {
		let maxAspectRatio:CGFloat = 16.0/9.0
		playableHeight = size.width / maxAspectRatio
		playableMargin = (size.height-playableHeight)/2.0
		playableRect = CGRect(x: 0, y: playableMargin,
		                      width: size.width,
		                      height: playableHeight)
		
		animationStartPosition = CGPoint(x: -playableRect.size.width * 2, y: playableRect.size.height * 3)
		
		super.init(size: size)
//		NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)

		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMove(to view: SKView) {
//		self.view!.window!.rootViewController!.canDisplayBannerAds = true
//		self.bannerView?.delegate = self
//		self.bannerView?.hidden = true
		
		let meloTechnoLevelSongURL = URL(fileURLWithPath: "MeloTechnoLevelSong.mp3")

		if backgroundMusicPlayer.isPlaying == true {
			if backgroundMusicPlayer.url == meloTechnoLevelSongURL {
				playBackgroundMusic("MainMenuNewSong.mp3")
			}
		} else if backgroundMusicPlayer.isPlaying == false {
			playBackgroundMusic("MainMenuNewSong.mp3")
		}

		addChild(animationsNode)
		setupMainMenuUI()
		setupAnimationObjectArrays()
		addAnimationGraphicArray()
		runBackgroundAnimation()
		
		
		if !allLevelsUnlocked {
			
			if isFirstLaunch {
				resetLockedLevels()
				resetToZeroStars()
			} else {
				unArchiveLockedLevels()
				unArchiveStars()
			}
		} else {
			unlockAllLevels()
			resetToZeroStars()
		}
		
//		if levelUnlockedBools.isEmpty {
//			if isFirstLaunch {
//				resetLockedLevels()
//			} else {
//				unArchiveLockedLevels()
//			}
//		}
		
	}

	override func willMove(from view: SKView) {
		
		animationsNode.enumerateChildNodes(withName: "animationGraphic", using: {node, stop in
			node.removeAllActions()
			node.removeFromParent()
			})
		animationsNode.removeAllActions()
		
		self.removeAllActions()
		self.removeAllChildren()
	}
	
	// MARK: SETUP
	func runBackgroundAnimation() {

		let forwardRotateAction = SKAction.rotate(byAngle: -5, duration: 3)
		let backwardRotateAction = SKAction.rotate(byAngle: 2, duration: 1)
		let rotateSequence = SKAction.sequence([forwardRotateAction, backwardRotateAction])
		let repeatingRotateSequecne = SKAction.repeatForever(rotateSequence)
		
		forwardRotateAction.timingMode = .easeInEaseOut
		backwardRotateAction.timingMode = .easeInEaseOut

		animationsNode.enumerateChildNodes(withName: "animationGraphic", using: {node, stop in
			node.run(repeatingRotateSequecne)
		})
		
		let moveUpRightAction = SKAction.moveBy(x: 800, y: 800, duration: 4)
		let moveDownRightAction = SKAction.moveBy(x: 800, y: -800, duration: 4)
		let moveDownLeftAction = SKAction.moveBy(x: -800, y: -800, duration: 4)
		let moveUpLeftAction = SKAction.moveBy(x: -800, y: 800, duration: 4)
		let backgroundMoveSequence = SKAction.sequence([
			moveUpRightAction,
			moveDownRightAction,
			moveDownLeftAction,
			moveUpLeftAction
			])
		
		let changeTextureWaitTime = SKAction.wait(forDuration: 2.5)
		
		let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
		let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
		
		fadeInAction.timingMode = .easeInEaseOut
		fadeOutAction.timingMode = .easeInEaseOut
		
		let changeTextureSequence = SKAction.sequence(([
			changeTextureWaitTime,
			fadeOutAction,
			SKAction.run({self.changeArrayTextures("RedPlayerSad")}),
			fadeInAction,
			changeTextureWaitTime,
			fadeOutAction,
			SKAction.run({self.changeArrayTextures("successStar")}),
			fadeInAction,
			changeTextureWaitTime,
			fadeOutAction,
			SKAction.run({self.changeArrayTextures("RedPlayerSad")}),
			fadeInAction,
			changeTextureWaitTime,
			fadeOutAction,
			SKAction.run({self.changeArrayTextures("successStar")}),
			fadeInAction
			]))

		animationsNode.run(SKAction.repeatForever(backgroundMoveSequence))
		animationsNode.run(SKAction.repeatForever(changeTextureSequence))
		
	}
	
	func changeArrayTextures(_ textureName: String) {
		animationsNode.enumerateChildNodes(withName: "animationGraphic", using: {node, stop in
			node.run(SKAction.setTexture(SKTexture(imageNamed: textureName)))
		})
	}

	
	func setupAnimationObjectArrays() {
		for image in 1...80 {
			let newRowOffset = CGPoint(x: 0, y: 225 * CGFloat((image - 1)))
			let rowStartPosition = animationStartPosition - newRowOffset
			
			for tile in 1...80 {
				let fullwidth = size.width - 100
				let levelBoxStep = fullwidth / 5
				
				let newTilePosition = rowStartPosition + CGPoint(x: CGFloat(tile - 1) * CGFloat(levelBoxStep), y: 0)
				
				let animationGraphic = SKSpriteNode(imageNamed: "successStar")
				animationGraphic.position = newTilePosition
				animationGraphic.run(SKAction.scale(by: 2, duration: 0))
				animationGraphic.zPosition = GameLayer.foreground.rawValue
				animationGraphic.name = "animationGraphic"
								animationGraphicArray.append(animationGraphic)
				
				animationGraphic.run(SKAction.fadeAlpha(to: 0.3, duration: 0))

			}
		}
	}
	
	func addAnimationGraphicArray() {
		for theGraphic in 0..<animationGraphicArray.count {
			animationsNode.addChild(animationGraphicArray[theGraphic])
		}
	}
	
	func setupBackground() {
		let tempBackground = SKSpriteNode(imageNamed: "mainmenuBackground.png")
		tempBackground.anchorPoint = CGPoint(x: 0, y: 0)
		tempBackground.position = CGPoint(x: 0, y: 0)

		tempBackground.zPosition = GameLayer.background.rawValue
		addChild(tempBackground)
	}
	
	func setupMainMenuUI() {
		let buttonBuffer:CGFloat = 300
		
		setupBackground()
		let mainTitle = SKSpriteNode(imageNamed: "unisonTitle")
		mainTitle.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		mainTitle.position = CGPoint(x: size.width / 2, y: size.height * 0.66)
		mainTitle.zPosition = GameLayer.ui.rawValue
		addChild(mainTitle)
		
		
		let playButton = SKSpriteNode(imageNamed: "playButton")
		playButton.name = "Play"
		playButton.anchorPoint = CGPoint(x: 0.5, y: 1)
		playButton.position = CGPoint(x: mainTitle.position.x, y: mainTitle.position.y - mainTitle.size.height / 2)
		playButton.zPosition = GameLayer.ui.rawValue
		addChild(playButton)
		
		
		let levelsButton = SKSpriteNode(imageNamed: "levelButton")
		levelsButton.name = "Levels"
		levelsButton.anchorPoint = CGPoint(x: 0.5, y: 1)
		levelsButton.position = CGPoint(x: mainTitle.position.x, y: playButton.position.y - buttonBuffer)
		levelsButton.zPosition = GameLayer.ui.rawValue
		addChild(levelsButton)
		
		
//		let creditsButton = SKSpriteNode(imageNamed: "creditsButton")
//		creditsButton.name = "Credits"
//		creditsButton.anchorPoint = CGPoint(x: 0.5, y: 1)
//		creditsButton.position = CGPoint(x: levelsButton.position.x * 0.5, y: levelsButton.position.y)
//		creditsButton.zPosition = GameLayer.ui.rawValue
//		addChild(creditsButton)
//		
//		let howToPlayButton = SKSpriteNode(imageNamed: "howToPlayButton")
//		howToPlayButton.name = "Achivements"
//		howToPlayButton.anchorPoint = CGPoint(x: 0.5, y: 1)
//		howToPlayButton.position = CGPoint(x: levelsButton.position.x * 1.5, y: levelsButton.position.y)
//		howToPlayButton.zPosition = GameLayer.ui.rawValue
//		addChild(howToPlayButton)
//		
//		let settingsButton = SKSpriteNode(imageNamed: "settingsCog")
//		settingsButton.name = "Settings"
//		settingsButton.anchorPoint = CGPoint(x: 1, y: 0)
//		settingsButton.position = CGPoint(x: playableRect.size.width - settingsButton.size.width / 2, y: playableMargin)
//		settingsButton.zPosition = GameLayer.ui.rawValue
//		addChild(settingsButton)
		

	}
	
//	func setupHowToPlayScreen() {
//		uiNode.alpha = 0
//		
//		htpBackground.strokeColor = SKColor.white
//		htpBackground.lineWidth = 10
//		htpBackground.fillColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.95)
//		htpBackground.zPosition = GameLayer.ui.rawValue
//		
//		htpPlayer.anchorPoint = CGPoint(x: 0.5, y: 0)
//		restartButton.name = "Restart"
//		restartButton.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height - 325)
//		restartButton.zPosition = GameLayer.uiText.rawValue
//		
//		backToGameButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		backToGameButton.name = "UnPause"
//		backToGameButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y + backToGameButton.size.height)
//		backToGameButton.zPosition = GameLayer.uiText.rawValue
//		
//		levelsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		levelsButton.name = "Levels"
//		levelsButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y - levelsButton.size.height - 35)
//		levelsButton.zPosition = GameLayer.uiText.rawValue
//		
//		quitButton.anchorPoint = CGPoint(x: 0.5, y:0)
//		quitButton.name = "Quit"
//		quitButton.position = CGPoint(x: levelsButton.position.x, y: levelsButton.position.y - quitButton.size.height - 35)
//		quitButton.zPosition = GameLayer.uiText.rawValue
//		
//		//		designLevelButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		//		designLevelButton.name = "Design"
//		//		designLevelButton.position = CGPoint(x: quitButton.position.x, y: quitButton.position.y - designLevelButton.size.height - 35)
//		//		designLevelButton.zPosition = GameLayer.uiText.rawValue
//		
//		//		resetDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		//		resetDesignButton.name = "Reset"
//		//		resetDesignButton.position = CGPoint(x: quitButton.position.x, y: quitButton.position.y - resetDesignButton.size.height - 35)
//		//		resetDesignButton.zPosition = GameLayer.uiText.rawValue
//		
//		pauseMenuBackgroundBox.name = "pauseMenuBackgroundBox"
//		uiNode.addChild(pauseMenuBackgroundBox)
//		pauseMenuBackgroundBox.addChild(backToGameButton)
//		pauseMenuBackgroundBox.addChild(restartButton)
//		pauseMenuBackgroundBox.addChild(levelsButton)
//		pauseMenuBackgroundBox.addChild(quitButton)
//		//		pauseMenuBackgroundBox.addChild(designLevelButton)
//		//		pauseMenuBackgroundBox.addChild(resetDesignButton)
//	}
	
	func newGame() {
		

		
		if isFirstLaunch {
			let newScene = GameLevel(size: gameSize)
			let transition = SKTransition.crossFade(withDuration: 1)
			newScene.scaleMode = .aspectFill
			newScene.currentLevelNumber = firstLevelNumber
//			playBackgroundMusic("MeloTechnoLevelSong.mp3")
			view!.presentScene(newScene, transition: transition)
		} else {
			let newScene = GameLevel(size: gameSize)
			let transition = SKTransition.crossFade(withDuration: 1)
			newScene.scaleMode = .aspectFill
			newScene.currentLevelNumber = firstLevelNumber
			playBackgroundMusic("MeloTechnoLevelSong.mp3")
			view!.presentScene(newScene, transition: transition)

		}

		
	}
	
	func gotoLevelsScene() {
		let transition = SKTransition.moveIn(with: .left, duration: 1)

		levelsScene.scaleMode = .aspectFill
//		levelsScene.moc = self.moc
		view!.presentScene(levelsScene, transition: transition)
		
	}
	
	
	// MARK: USER INPUT
	
		func sceneTouched(_ location: CGPoint) {
			
			let targetNode = self.atPoint(location)
			
			if targetNode.name == "Play" {
				run(SKAction.sequence([
					SKAction.group([
						playButtonPressSound,
						SKAction.fadeOut(withDuration: 1)
						]),
					SKAction.run(newGame)
					]))
			} else if targetNode.name == "Levels" {
				run(
					SKAction.group([
						playButtonPressSound,
						SKAction.run(gotoLevelsScene)
						]))
			} else if targetNode.name == "Credits" {
				// TODO:  ADD CREDITS LOGIC
			} else if targetNode.name == "Achivements" {
				// TODO: ADD ACHIVEMENTS LOGIC
			} else {
				return
			}
			
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		sceneTouched(touches.first!.location(in: self))
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
	}
}
