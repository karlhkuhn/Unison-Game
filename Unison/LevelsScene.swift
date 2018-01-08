//
//  MainMunuScene.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/26/16.
//  Copyright (c) 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit
import Foundation

class LevelsScene: SKScene {

//	var moc: NSManagedObjectContext?
	
	var levelBox: ButtonBox?
	var levelArray = [AnyObject]()
	let levelsCount = 20
	
	var chosenLevel: Int = 1
	
	let numberOfRowsInGrid: Int = 2
	let numberOfTilesPerRow: Int = 5
	let gridStartPosition: CGPoint
	let gridStartPositionWorld2: CGPoint

	
	let playableRect: CGRect
	let playableHeight: CGFloat
	let playableMargin: CGFloat
	
	override func didMove(to view: SKView) {
		
		let meloTechnoLevelSongURL = URL(fileURLWithPath: "MeloTechnoLevelSong.mp3")

		if backgroundMusicPlayer.isPlaying == true {
			if backgroundMusicPlayer.url == meloTechnoLevelSongURL {
				playBackgroundMusic("MainMenuNewSong.mp3")
			}
		} else if backgroundMusicPlayer.isPlaying == false {
			playBackgroundMusic("MainMenuNewSong.mp3")
		}
		
		for level in 1...levelsCount {
			//			let rand = Int(arc4random_uniform(4))
			levelBox = ButtonBox(chosenLevel: level, successStarCount: levelStars[level - 1], levelUnlocked: levelUnlockedBools[level - 1])
			levelBox?.name = "levelBox"
			if levelBox != nil {
				levelArray.append(levelBox!)
			}
		}
		
		setupBackground()
		setupLevelBoxesWorld1()
		setupLevelBoxesWorld2()
		setupNavButtons()

	}
	
	override func willMove(from view: SKView) {
		levelArray.removeAll()
		removeAllActions()
		removeAllChildren()
		print("Did move from view")
		
		
	}
	
	
	override init(size: CGSize) {
		
//		playBackgroundMusic("MainMenuNewSong.mp3")

		
		let maxAspectRatio:CGFloat = 16.0/9.0
		playableHeight = size.width / maxAspectRatio
		playableMargin = (size.height-playableHeight)/2.0
		playableRect = CGRect(x: 0, y: playableMargin,
			width: size.width,
			height: playableHeight)
		
		gridStartPosition = CGPoint(x: 250, y: size.height - playableMargin - 220)

		gridStartPositionWorld2 = CGPoint(x: 250, y: size.height - playableMargin - 800)
		

		

		
		super.init(size: size)
		
		

	}
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	// MARK: SETUP
	func setupBackground() {
		let tempBackground = SKSpriteNode(imageNamed: "mainmenuBackground")
		tempBackground.anchorPoint = CGPoint(x: 0, y: 0)
		tempBackground.position = CGPoint(x: 0, y: 0)
		tempBackground.zPosition = GameLayer.background.rawValue
		addChild(tempBackground)

	}
	
	func setupLevelBoxesWorld1() {
		chosenLevel = 1
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: 225 * CGFloat((row - 1)))
			let rowStartPosition = gridStartPosition - newRowOffset
			
			for tile in 1...numberOfTilesPerRow {
				let fullwidth = size.width - 100
				let levelBoxStep = fullwidth / 5
				
				let newTilePosition = rowStartPosition + CGPoint(x: CGFloat(tile - 1) * CGFloat(levelBoxStep), y: 0)
//				let rand = Int(arc4random_uniform(4))
				let levelBoxItem = levelArray[chosenLevel - 1] as! ButtonBox
				levelBoxItem.position = newTilePosition
				addChild(levelBoxItem)
				
				matrixGridWorldLevels1["World1Level" + String(chosenLevel)] = chosenLevel
				
				

				chosenLevel += 1
				
			}
		}
	}
	
	func setupLevelBoxesWorld2() {
		chosenLevel = 11
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: 225 * CGFloat((row - 1)))
			let rowStartPosition = gridStartPositionWorld2 - newRowOffset
			
			for tile in 1...numberOfTilesPerRow {
				let fullwidth = size.width - 100
				let levelBoxStep = fullwidth / 5
				
				let newTilePosition = rowStartPosition + CGPoint(x: CGFloat(tile - 1) * CGFloat(levelBoxStep), y: 0)
				//				let rand = Int(arc4random_uniform(4))
				let levelBoxItem = levelArray[chosenLevel - 1] as! ButtonBox
				levelBoxItem.position = newTilePosition
				addChild(levelBoxItem)
				
				matrixGridWorldLevels2["World2Level" + String(chosenLevel - 10)] = chosenLevel
				
				
				
				chosenLevel += 1
				
			}
		}
	}

	func setupNavButtons() {
		let backHomeButton = SKSpriteNode(imageNamed: "backArrow")
		backHomeButton.name = "BackHomeButton"
		backHomeButton.anchorPoint = CGPoint(x: 0, y: 0)
		backHomeButton.position = CGPoint(x: backHomeButton.size.width / 2, y: playableMargin)
		backHomeButton.zPosition = GameLayer.ui.rawValue
		addChild(backHomeButton)
	}
	
	func setupMainMenuUI() {
		
		let mainTitle = SKSpriteNode(imageNamed: "unisonTitle")
		mainTitle.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		mainTitle.position = CGPoint(x: size.width / 2, y: size.height * 0.66)
		mainTitle.zPosition = GameLayer.ui.rawValue
		addChild(mainTitle)
		
		
	}
	
	func newGame(_ level: Int) {		
		let newScene = GameLevel(size: gameSize)
		
		let transition = SKTransition.crossFade(withDuration: 1)
		newScene.scaleMode = .aspectFill
		newScene.currentLevelNumber = level
		view!.presentScene(newScene, transition: transition)
	}
	
	func gotoMainMenuScene() {
		let newScene = MainMenuScene(size:(CGSize(width: 2048, height: 1536)))
		let transition = SKTransition.moveIn(with: .right, duration:1)
		newScene.scaleMode = .aspectFill

		view!.presentScene(newScene, transition: transition)
	}
	
	
	// MARK: USER INPUT
	
		func sceneTouched(_ location: CGPoint) {
			
			let targetNode = self.atPoint(location)
						
			if targetNode.name == "levelButtonBox" || targetNode.name == "levelButtonBoxText"{
				if targetNode.name == "levelButtonBoxText" {
					let tempBox = targetNode.parent
					let skBox = tempBox?.parent as! ButtonBox
					if skBox.levelIsUnlocked {
						run(SKAction.sequence([
							SKAction.group([
								playButtonPressSound,
								SKAction.fadeOut(withDuration: 1)
								]),
//							SKAction.run({playBackgroundMusic("MeloTechnoLevelSong.mp3")}),
							SKAction.run({self.newGame(skBox.chosenLevel)})
							]))
					}
				}
				else if targetNode.name == "levelButtonBox" {
					let skBox = targetNode.parent as! ButtonBox
					if skBox.levelIsUnlocked {
						run(SKAction.sequence([
							SKAction.group([
								playButtonPressSound,
								SKAction.fadeOut(withDuration: 1)
								]),
//							SKAction.run({playBackgroundMusic("MeloTechnoLevelSong.mp3")}),
							SKAction.run({self.newGame(skBox.chosenLevel)})
							]))
					}
				}
					
				else if targetNode.name == "successStarHolder" {
					let skBox = targetNode.parent as! ButtonBox
					if skBox.levelIsUnlocked {

						run(SKAction.sequence([
							SKAction.group([
								playButtonPressSound,
								SKAction.fadeOut(withDuration: 1)
								]),
//							SKAction.run({playBackgroundMusic("MeloTechnoLevelSong.mp3")}),
							SKAction.run({self.newGame(skBox.chosenLevel)})
							]))
					}
				}
				else if targetNode.name == "successStar" {
					let skBox = targetNode.parent as! ButtonBox
					if skBox.levelIsUnlocked {

						run(SKAction.sequence([
							SKAction.group([
								playButtonPressSound,
								SKAction.fadeOut(withDuration: 1)
								]),
//							SKAction.run({playBackgroundMusic("MeloTechnoLevelSong.mp3")}),
							SKAction.run({self.newGame(skBox.chosenLevel)})
							]))
					}
				}
			}
			
			else if targetNode.name == "BackHomeButton" {
				gotoMainMenuScene()
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
