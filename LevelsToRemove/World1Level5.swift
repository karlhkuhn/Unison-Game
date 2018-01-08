//
//  World1Level5.swift
//  Unison
//
//  Created by Karl H Kuhn on 2/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit
import AVFoundation




class World1Level5: SKScene, SKPhysicsContactDelegate {
	
	//MARK: LEVEL VARIABLES
	
	var currentLevelNumber: Int
	
	var currentLevelTitle: String
	
	
	// SET ROWS IN GRID
	var numberOfRowsInGrid: Int
	
	// SET TILES IN ROW
	var numberOfTilesPerRow: Int
	
	// SET PLAYER GRID START POSITION
	var playerGridStartNumber: String
	
	// SET MIRROR PLAYER GRID START POSITION
	var mirrorPlayerGridStartPosition: String
	
	// SET GOAL POSITIONS
	var goalTilePosition: String
	var mirrorGoalTilePosition: String
	
	
	
	//MARK: INIT
	
	
	override init (size: CGSize) {
		
		
		currentLevelNumber = 5
		currentLevelTitle = "World 1 - Level 5"
		numberOfRowsInGrid = 4
		numberOfTilesPerRow = 4
		playerGridStartNumber = "H1"
		mirrorPlayerGridStartPosition = "H1"
		goalTilePosition = "I4"
		mirrorGoalTilePosition = "H4"
		
		
		let maxAspectRatio:CGFloat = 16.0/9.0
		playableHeight = size.width / maxAspectRatio
		playableMargin = (size.height-playableHeight)/2.0
		playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
		playerPositionBeforeMove = CGPoint(x: 0, y: 0)
		mirrorPositionBeforeMove = CGPoint(x: 0, y: 0)
		
		buttonCenteredPosition = playableRect.size.height + 105
		
		leftPlayableArea = CGRect(x: 0, y: playableMargin + 160, width: size.width/2, height: playableHeight - 250)
		rightPlayableArea = CGRect(x: leftPlayableArea.width, y: playableMargin + 160, width: size.width/2 - 100, height: playableHeight - 250)
		
		tileSide = (leftPlayableArea.width / CGFloat(numberOfTilesPerRow)) * 0.6
		tileSize = CGSize(width: tileSide, height: tileSide)
		tileBufferWidth = tileSide * 0.6  //Space between the tiles
		firstTileBufferWidth = tileSide * 0.0001
		tileBufferHeight = tileSide * 0.4
		
		numberOfColumnAllysInGrid = numberOfRowsInGrid - 1
		
		
		referencePointsStartPosition = CGPoint(x: firstTileBufferWidth * 5 - 15, y: size.height - playableMargin - tileSide * 0.70)
		
		gridStartPosition = CGPoint(x: firstTileBufferWidth * 5, y: size.height - playableMargin - tileSide - tileBufferHeight)
		horizontalWallStartPosition = CGPoint(x: firstTileBufferWidth * 5, y: size.height - playableMargin - tileSide - tileSide/2 - tileBufferHeight)
		
		wall1StartPosition = gridStartPosition + CGPoint(x: tileBufferWidth * 2.3, y: 0)
		
		bottomGridYPosition = wall1StartPosition.y - (tileSide * 3) - (tileBufferHeight * 3)
		
		
		wall2StartPosition = wall1StartPosition + CGPoint(x: tileSide + tileBufferWidth, y: 0)
		
		pauseMenuBackgroundBox = SKShapeNode(rect: CGRect(x: 700, y: playableRect.size.height - playableMargin - 500, width: playableRect.size.width - 1400, height: playableRect.size.height - 400))
		
		
		movePlayerRight = SKAction.moveByX(tileSide + tileBufferWidth, y: 0, duration: playerMoveSpeedByDuration)
		movePlayerLeft = SKAction.moveByX(-tileSide - tileBufferWidth, y: 0, duration: playerMoveSpeedByDuration)
		movePlayerUp = SKAction.moveByX(0, y: tileSide + tileBufferHeight, duration: playerMoveSpeedByDuration)
		movePlayerDown = SKAction.moveByX(0, y: -tileSide - tileBufferHeight, duration: playerMoveSpeedByDuration)
		
		mirrorWaitMove = SKAction.waitForDuration(mirrorMoveWaitTime)
		mirrorWaitBounce = SKAction.waitForDuration(mirrorBounceWaitTime)
		moveMirrorRight = SKAction.moveByX(tileSide + tileBufferWidth, y: 0, duration: mirrorMoveSpeedByDuration)
		moveMirrorLeft = SKAction.moveByX(-tileSide - tileBufferWidth, y: 0, duration: mirrorMoveSpeedByDuration)
		moveMirrorUp = SKAction.moveByX(0, y: tileSide + tileBufferHeight, duration: mirrorMoveSpeedByDuration)
		moveMirrorDown = SKAction.moveByX(0, y: -tileSide - tileBufferHeight, duration: mirrorMoveSpeedByDuration)
		
		scaleUp.timingMode = .EaseInEaseOut
		scaleDown.timingMode = .EaseInEaseOut
		
		
		super.init(size: size)
		
		
	}
	
	override func didMoveToView(view: SKView) {
		
		physicsWorld.gravity = CGVectorMake(0, 0)
		physicsWorld.contactDelegate = self
		
		setupLevelNode()
		setupBackground()
		setupLeftGrid()
		setupRightGrid()
		setupLeftGridReferencePoints()
		setupRightGridReferencePoints()
		setupBorders()
		setupGoal(goalTilePosition)
		
		
		
		setupMirrorGoal(mirrorGoalTilePosition)
		
		adjustPayingBoardPosition()
		
		defineSwipes()
		setUpObstacles()
		setupPlayers()
		setupLevelDescription()
		fadeInOutLevelDescription()
		setupPauseMenuUI()
		setupPauseButton()
		fadeInPauseButton()
		setupGameOverScreen()
		setupSuccessScreen()
	}
	
	
	
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupLevelNode() {
		addChild(backgroundNode)
		backgroundNode.zPosition = GameLayer.Background.rawValue
		addChild(playingBoardNode)
		playingBoardNode.zPosition = GameLayer.PlayingBoard.rawValue
		addChild(levelDescriptionNode)
		levelDescriptionNode.zPosition = GameLayer.UI.rawValue
		addChild(uiNode)
		uiNode.zPosition = GameLayer.UIText.rawValue
		addChild(uiGameOverNode)
		uiGameOverNode.zPosition = GameLayer.UIText.rawValue
		addChild(uiPlayNode)
		uiPlayNode.zPosition = GameLayer.UIText.rawValue
	}
	
	
	
	// MARK: UI SETUPS
	
	
	func setupSuccessScreen() {
		
	}
	
	func displaySuccessScreen() {
		
		
		pauseButton.removeFromParent()
		
		let successScreen = SuccessScreenLayover(successStarCount: starCalculator(currentLevelNumber, swipeCount: swipesMade, swipesFor2Stars: 7, swipesFor3Stars: 5))
		successScreen.position = CGPoint(x: -successScreen.theSuccessScreen.size.width, y: playableRect.size.height * 0.8)
		successScreen.zPosition = GameLayer.UIText.rawValue
		
		let fromLeftAction = SKAction.moveToX(playableRect.size.width / 2, duration: successScreenAppearDuration)
		fromLeftAction.timingMode = .EaseOut
		successScreen.name = "sucessScreen"
		uiPlayNode.addChild(successScreen)
		successScreen.runAction(fromLeftAction)
	}

	
	
	func fadeInPauseMenu() {
		//		let moveToCenter = SKAction.moveTo(<#T##location: CGPoint##CGPoint#>, duration: <#T##NSTimeInterval#>)
		let fadeInAction = SKAction.fadeInWithDuration(pauseScreenFadeInOutDuration)
		uiNode.runAction(fadeInAction)
	}
	
	func fadeOutPauseMenu() {
		let fadeOutAction = SKAction.fadeOutWithDuration(pauseScreenFadeInOutDuration)
		uiNode.runAction(fadeOutAction)
	}
	
	
	func setupPauseMenuUI() {
		uiNode.alpha = 0
		
		pauseMenuBackgroundBox.strokeColor = SKColor.whiteColor()
		pauseMenuBackgroundBox.lineWidth = 10
		pauseMenuBackgroundBox.fillColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.95)
		pauseMenuBackgroundBox.zPosition = GameLayer.UI.rawValue
		
		restartButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		restartButton.name = "Restart"
		restartButton.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height - 300)
		restartButton.zPosition = GameLayer.UIText.rawValue
		
		backToGameButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		backToGameButton.name = "UnPause"
		backToGameButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y + backToGameButton.size.height + 40 )
		backToGameButton.zPosition = GameLayer.UIText.rawValue
		
		levelsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		levelsButton.name = "Levels"
		levelsButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y - levelsButton.size.height - 50)
		levelsButton.zPosition = GameLayer.UIText.rawValue
		
		quitButton.anchorPoint = CGPoint(x: 0.5, y:0)
		quitButton.name = "Quit"
		quitButton.position = CGPoint(x: levelsButton.position.x, y: levelsButton.position.y - quitButton.size.height - 50)
		quitButton.zPosition = GameLayer.UIText.rawValue
		
		uiNode.addChild(pauseMenuBackgroundBox)
		pauseMenuBackgroundBox.addChild(backToGameButton)
		pauseMenuBackgroundBox.addChild(restartButton)
		pauseMenuBackgroundBox.addChild(levelsButton)
		pauseMenuBackgroundBox.addChild(quitButton)
	}
	
	func 	displayGameOverScreen() {
		pauseButton.removeFromParent()
		
		let fromTopAction = SKAction.moveToY(playableRect.size.height / 2 + 200, duration: 1)
		fromTopAction.timingMode = .EaseOut
		
		if gameOverScreen.parent == uiGameOverNode {
			return
		} else {
			uiGameOverNode.addChild(gameOverScreen)
		}
		
		gameOverScreen.runAction(fromTopAction)
		
	}
	
	func setupGameOverScreen() {
		gameOverScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		gameOverScreen.name = "GameOver"
		gameOverScreen.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height + gameOverScreen.size.height)
		
		gameOverScreen.zPosition = GameLayer.UIText.rawValue
	}
	
	
	func fadeInOutLevelDescription() {
		let levelDescriptionSetToAlpha = SKAction.fadeAlphaTo(0, duration: 0)
		let levelDescriptionFadeInAction = SKAction.fadeInWithDuration(levelDescriptionFadeInDuration)
		let levelDescriptionFadeOutAction = SKAction.fadeOutWithDuration(levelDescriptionFadeOutDuration)
		let waitTime = SKAction.waitForDuration(levelDescriptionDisplayedDuration)
		
		let levelDescriptionFadeSequence = SKAction.sequence([SKAction.waitForDuration(0.1), levelDescriptionFadeInAction, waitTime,levelDescriptionFadeOutAction])
		
		levelDescriptionNode.runAction(levelDescriptionSetToAlpha)
		levelDescriptionNode.runAction(levelDescriptionFadeSequence)
	}
	
	func fadeInPauseButton() {
		let pauseButtonSetToAlpha = SKAction.fadeAlphaTo(0, duration: 0)
		let pauseButtonFadeIn = SKAction.fadeInWithDuration(pauseButtonFromStartFadeInDuration)
		let waitTime = SKAction.waitForDuration(pauseButtonWaitToAppear)
		
		pauseButton.runAction(SKAction.sequence([pauseButtonSetToAlpha, waitTime, pauseButtonFadeIn]))
		
	}
	
	func fadeOutPauseButton() {
		let pauseButtonFadeOut = SKAction.fadeOutWithDuration(pauseButtonFadeInOutDuration)
		pauseButton.runAction(pauseButtonFadeOut)
	}
	
	func fadeInResumeFromPauseButton() {
		let pauseButtonFadeIn = SKAction.fadeInWithDuration(pauseButtonFadeInOutDuration)
		pauseButton.runAction(pauseButtonFadeIn)
	}
	
	func setupLevelDescription() {
		
		
		let uiBackgroundBox = SKShapeNode(rect: CGRect(x: 0, y: playableRect.size.height + 90, width: playableRect.size.width, height: 125))
		uiBackgroundBox.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0, alpha: 0.4)
		uiBackgroundBox.zPosition = GameLayer.UI.rawValue
		levelDescriptionNode.addChild(uiBackgroundBox)
		
		
		
		let levelTitle = SKLabelNode(fontNamed: "Arial Bold")
		levelTitle.text = currentLevelTitle
		levelTitle.fontColor = SKColor.whiteColor()
		levelTitle.fontSize = 82
		levelTitle.position = CGPoint(x: playableRect.size.width / 2, y: buttonCenteredPosition)
		levelTitle.zPosition = GameLayer.UIText.rawValue
		levelDescriptionNode.addChild(levelTitle)
	}
	
	func setupPauseButton() {
		pauseButton.name = "Pause"
		pauseButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		pauseButton.size = CGSize(width: pauseButton.size.width * 0.75, height: pauseButton.size.height * 0.75)
		//		pauseButton.position = CGPoint(x: playableRect.size.width / 2, y: buttonCenteredPosition)
		pauseButton.position = CGPoint(x: playableRect.size.width / 2, y: 220)
		
		pauseButton.zPosition = GameLayer.UIText.rawValue
		uiPlayNode.addChild(pauseButton)
	}
	
	func setupBorders() {
		//		let rightGridBordersArea = rightPlayableArea
		let shape = SKShapeNode()
		let path = CGPathCreateMutable()
		CGPathMoveToPoint(path, nil, matrixGridLeftReferencePoints["A1"]!.x - borderMargin, matrixGridLeftReferencePoints["A1"]!.y + borderMargin)
		CGPathAddLineToPoint(path, nil, matrixGridLeftReferencePoints["E1"]!.x + 20, matrixGridLeftReferencePoints["E1"]!.y + borderMargin)
		CGPathAddLineToPoint(path, nil, matrixGridLeftReferencePoints["E5"]!.x + 20, matrixGridLeftReferencePoints["E5"]!.y - borderMargin)
		CGPathAddLineToPoint(path, nil, matrixGridLeftReferencePoints["A5"]!.x - borderMargin, matrixGridLeftReferencePoints["A5"]!.y - borderMargin)
		CGPathAddLineToPoint(path, nil, matrixGridLeftReferencePoints["A1"]!.x - borderMargin, matrixGridLeftReferencePoints["A1"]!.y + borderMargin)
		shape.path = path
		shape.strokeColor = SKColor.clearColor()
		shape.lineWidth = 10.0
		shape.zPosition = GameLayer.Debug.rawValue
		playingBoardNode.addChild(shape)
		
		let shape2 = SKShapeNode()
		let path2 = CGPathCreateMutable()
		CGPathMoveToPoint(path2, nil, matrixGridRightReferencePoints["A1"]!.x - 20, matrixGridRightReferencePoints["A1"]!.y + borderMargin)
		CGPathAddLineToPoint(path2, nil, matrixGridRightReferencePoints["E1"]!.x + borderMargin, matrixGridRightReferencePoints["E1"]!.y + borderMargin)
		CGPathAddLineToPoint(path2, nil, matrixGridRightReferencePoints["E5"]!.x + borderMargin, matrixGridRightReferencePoints["E5"]!.y - borderMargin)
		CGPathAddLineToPoint(path2, nil, matrixGridRightReferencePoints["A5"]!.x - 20, matrixGridRightReferencePoints["A5"]!.y - borderMargin)
		CGPathAddLineToPoint(path2, nil, matrixGridRightReferencePoints["A1"]!.x - 20, matrixGridRightReferencePoints["A1"]!.y + borderMargin)
		shape2.path = path2
		shape2.strokeColor = SKColor.clearColor()
		shape2.lineWidth = 10.0
		shape2.zPosition = GameLayer.Debug.rawValue
		playingBoardNode.addChild(shape2)
		
		shape.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
		shape.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
		shape.physicsBody?.collisionBitMask = PhysicsCategory.None
		shape.physicsBody?.contactTestBitMask = PhysicsCategory.Player
		
		shape2.physicsBody = SKPhysicsBody(edgeLoopFromPath: path2)
		shape2.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
		shape2.physicsBody?.collisionBitMask = PhysicsCategory.None
		shape2.physicsBody?.contactTestBitMask = PhysicsCategory.Player
		
	}
	
	//MARK: PLAYER SETUP
	
	func setupPlayers() {
		
		player = Player(texture: SKTexture(imageNamed: "GreenPlayerSad"), color: UIColor.clearColor(), size: CGSize(width:tileSide, height:tileSide))
		
		mirrorPlayer = Player(texture: SKTexture(imageNamed: "RedPlayerSad"), color: UIColor.clearColor(), size: CGSize(width:tileSide, height:tileSide))
		
		player.name = "Player"
		player.zPosition = GameLayer.Player.rawValue
		player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tileSide * 0.8, height: tileSide * 0.8), center: CGPoint(x: 0.5, y: 0.5))
		player.physicsBody!.categoryBitMask = PhysicsCategory.Player
		player.physicsBody!.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Goal
		player.physicsBody!.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.WallDeivation
		
		mirrorPlayer.name = "MirrorPlayer"
		mirrorPlayer.zPosition = GameLayer.MirrorPlayer.rawValue
		mirrorPlayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		mirrorPlayer.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tileSide * 0.8, height: tileSide * 0.8), center: CGPoint(x: 0.5, y: 0.5))
		mirrorPlayer.physicsBody!.categoryBitMask = PhysicsCategory.MirrorPlayer
		mirrorPlayer.physicsBody!.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Goal
		mirrorPlayer.physicsBody!.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.WallDeivation
		
		player.position = matrixGridLeft[playerGridStartNumber]!
		mirrorPlayer.position = matrixGridRight[mirrorPlayerGridStartPosition]!
		
		playingBoardNode.addChild(player)
		playingBoardNode.addChild(mirrorPlayer)
		
		
		player.runAction(SKAction.repeatActionForever(SKAction.sequence([
			self.scaleUp, self.scaleDown
			])))
		mirrorPlayer.runAction(SKAction.repeatActionForever(SKAction.sequence([
			self.scaleUp, self.scaleDown
			])))
		
		print(player.position)
		print(matrixGridLeft["H1"])
		
		
	}
	
	
	func setUpObstacles() {
		
		let wall1 = WallPath(wallBounceType: .Wall, wallPoints:
			[
				matrixGridLeftReferencePoints["A3"]!,
				matrixGridLeftReferencePoints["B3"]!
			])
		playingBoardNode.addChild(wall1)
		
		
		let wall2 = WallPath(wallBounceType: .WallDeivation, wallPoints:
			[
				matrixGridLeftReferencePoints["B3"]!,
				matrixGridLeftReferencePoints["C3"]!
			])
		playingBoardNode.addChild(wall2)
		
		let wall3 = WallPath(wallBounceType: .Wall, wallPoints:
			[
				matrixGridLeftReferencePoints["C3"]!,
				matrixGridLeftReferencePoints["C2"]!
			])
		playingBoardNode.addChild(wall3)
		
		let wall4 = WallPath(wallBounceType: .WallDeivation, wallPoints:
			[
				matrixGridLeftReferencePoints["D1"]!,
				matrixGridLeftReferencePoints["E1"]!
			])
		playingBoardNode.addChild(wall4)
		
		
		
		let wall5 = WallPath(wallBounceType: .WallSpiked, wallPoints:
			[
				matrixGridRightReferencePoints["B1"]!,
				matrixGridRightReferencePoints["B2"]!
			])
		playingBoardNode.addChild(wall5)
		
		let wall6 = WallPath(wallBounceType: .WallSpiked, wallPoints:
			[
				matrixGridRightReferencePoints["B3"]!,
				matrixGridRightReferencePoints["C3"]!
			])
		playingBoardNode.addChild(wall6)
		
		let wall7 = WallPath(wallBounceType: .WallSpiked, wallPoints:
			[
				matrixGridRightReferencePoints["C2"]!,
				matrixGridRightReferencePoints["D2"]!
			])
		playingBoardNode.addChild(wall7)
		
		let oppositer1 = ModifierObject(modifierType: ModifierType.Oppositer, on: Grid.Player, at: "K1")
		playingBoardNode.addChild(oppositer1)
		
		let doubleMover1 = ModifierObject(modifierType: ModifierType.DoubleMover, on: Grid.Player, at: "J3")
		playingBoardNode.addChild(doubleMover1)

		let oppositer2 = ModifierObject(modifierType: ModifierType.Oppositer, on: Grid.Mirror, at: "K2")
		playingBoardNode.addChild(oppositer2)
		
		//		let verticalWall1 = Wall(texture: SKTexture(imageNamed: "wallObstacle"), color: UIColor.clearColor(), size: CGSize(width: tileSide * 0.2, height: tileSide * 4))
		//		playingBoardNode.addChild(verticalWall1)
		//		verticalWall1.position = CGPoint(x: matrixGridColumnAllyLeft["1,2"]!.x, y: playableRect.size.height / 2) + CGPoint(x: 0, y: tileSide - 30)
		//
		//		let verticalWall2 = WallDeivation(texture: SKTexture(imageNamed: "wallDeivationObstacle"), color: UIColor.redColor(), size: CGSize(width: tileSide * 0.2, height: tileSide))
		//		playingBoardNode.addChild(verticalWall2)
		//		verticalWall2.position = CGPoint(x: matrixGridColumnAllyLeft["3,2"]!.x, y: playableRect.size.height / 2) + CGPoint(x: 0, y: tileSide - 5)
		
	}
	
	
	
	
	func setupModifiers(modifierName: String, modifierType: ModifierType, onGrid grid: Grid, atPosition position: String) {
		
		let modifierName = ModifierObject(modifierType: modifierType, on: grid, at: position)
		playingBoardNode.addChild(modifierName)
	}
	
	
	
	//MARK: PLAYING BOARD SETUP
	
	func setupBackground() {
		let tempBackground = SKSpriteNode(imageNamed: "background1")
		tempBackground.anchorPoint = CGPoint(x: 0, y: 0)
		tempBackground.position = CGPoint(x: 0, y: 0)
		tempBackground.zPosition = GameLayer.Background.rawValue
		backgroundNode.addChild(tempBackground)
	}
	
	func setupLeftGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = gridStartPosition - newRowOffset
			var gridNumberSequence = 0
			
			for gridLetter in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = SKSpriteNode(imageNamed: "StandardYellowBlock")
				newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.name = "YellowTile"
				newTile.zPosition = GameLayer.PlayingBoard.rawValue
				playingBoardNode.addChild(newTile)
				
				gridNumberSequence += 1
				
				matrixGridLeft[String(gridLetter) + String(row)] = newTile.position
			}
		}
		playingBoardNode.enumerateChildNodesWithName("YellowTile", usingBlock: {node, stop in
			node.runAction(SKAction.repeatActionForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
	}
	
	func setupRightGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width + firstTileBufferWidth * 9, y: gridStartPosition.y) - newRowOffset
			var gridNumberSequence = 0
			
			for gridLetter in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = SKSpriteNode(imageNamed: "StandardSilverBlock")
				newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.name = "SilverTile"
				newTile.zPosition = GameLayer.PlayingBoard.rawValue
				playingBoardNode.addChild(newTile)
				
				gridNumberSequence += 1
				
				matrixGridRight[String(gridLetter) + String(row)] = newTile.position
			}
		}
		playingBoardNode.enumerateChildNodesWithName("SilverTile", usingBlock: {node, stop in
			node.runAction(SKAction.repeatActionForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
	}
	
	func setupGoal(tilePosition: String) {
		let goalTile = SKSpriteNode(imageNamed: "goalTile")
		goalTile.name = "Goal"
		goalTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		goalTile.size = CGSize(width: tileSide, height: tileSide)
		goalTile.physicsBody = SKPhysicsBody(rectangleOfSize: goalTile.size)
		goalTile.physicsBody!.categoryBitMask = PhysicsCategory.Goal
		goalTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player
		goalTile.physicsBody!.collisionBitMask = PhysicsCategory.None
		goalTile.position = matrixGridLeft[tilePosition]!
		goalTile.zPosition = GameLayer.Foreground.rawValue
		playingBoardNode.addChild(goalTile)
	}
	
	func setupMirrorGoal(tilePosition: String) {
		let goalTile = SKSpriteNode(imageNamed: "goalTile")
		goalTile.name = "Goal"
		goalTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		goalTile.size = CGSize(width: tileSide, height: tileSide)
		goalTile.physicsBody = SKPhysicsBody(rectangleOfSize: goalTile.size)
		goalTile.physicsBody!.categoryBitMask = PhysicsCategory.Goal
		goalTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player
		goalTile.physicsBody!.collisionBitMask = PhysicsCategory.None
		goalTile.position = matrixGridRight[tilePosition]!
		goalTile.zPosition = GameLayer.Foreground.rawValue
		playingBoardNode.addChild(goalTile)
		
	}
	
	
	//MARK: REFERENCE POINTS SETUP
	
	func setupLeftGridReferencePoints() {
		let gridLetters = "ABCDE"
		for gridRowNumber in 0...numberOfRowsInGrid + 1 {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(gridRowNumber - 1))
			let rowStartPosition = referencePointsStartPosition - newRowOffset
			var gridColumnSequence = 0
			for gridColumnLetter in gridLetters.characters {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: referencePointsStartPosition.x + (newPositionOffset.x * CGFloat(gridColumnSequence)), y: 0)
				matrixGridLeftReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = verticalWallPosition
				gridColumnSequence += 1
				print(gridColumnLetter, gridRowNumber)
			}
		}
	}
	
	func setupRightGridReferencePoints() {
		let gridLetters = "ABCDE"
		for gridRowNumber in 0...numberOfRowsInGrid + 1 {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(gridRowNumber - 1))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width, y: 0) + referencePointsStartPosition - newRowOffset
			var gridColumnSequence = 0
			for gridColumnLetter in gridLetters.characters {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: referencePointsStartPosition.x + (newPositionOffset.x * CGFloat(gridColumnSequence)), y: 0)
				matrixGridRightReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = verticalWallPosition
				gridColumnSequence += 1
				print(gridColumnLetter, gridRowNumber)
			}
		}
		
	}
	
	func setupLeftGridVerticalWallPositions() {
		
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = gridStartPosition - newRowOffset
			
			for columnAlly in 1...numberOfColumnAllysInGrid {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: wall1StartPosition.x + (newPositionOffset.x * CGFloat(columnAlly - 1)), y: 0)
				matrixGridColumnAllyLeft[String(columnAlly) + "," + String(row)] = verticalWallPosition
			}
		}
	}
	
	func setupLeftGridHorizontalWallPositions() {
		
		for row in 1...numberOfColumnAllysInGrid {
			for columnAlly in 1...numberOfTilesPerRow {
				let tilePosition = matrixGridLeft[String(columnAlly) + "," + String(row)]!
				let rowAllyWallPosition  = tilePosition - CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(0.5))
				matrixGridRowAllyLeft[String(columnAlly) + "," + String(row)] = rowAllyWallPosition
			}
		}
	}
	
	
	func setupRightGridVerticalWallPositions() {
		
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width, y: 0) + gridStartPosition - newRowOffset
			
			for columnAlly in 1...numberOfColumnAllysInGrid {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: wall1StartPosition.x + (newPositionOffset.x * CGFloat(columnAlly - 1)), y: 0)
				matrixGridColumnAllyRight[String(columnAlly) + "," + String(row)] = verticalWallPosition
			}
		}
	}
	
	func setupRightGridHorizontalWallPositions() {
		
		for row in 1...numberOfColumnAllysInGrid {
			for columnAlly in 1...numberOfTilesPerRow {
				let tilePosition = matrixGridRight[String(columnAlly) + "," + String(row)]!
				let rowAllyWallPosition  = tilePosition - CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(0.5))
				
				
				matrixGridRowAllyRight[String(columnAlly) + "," + String(row)] = rowAllyWallPosition
				
			}
		}
	}
	
	
	func adjustPayingBoardPosition() {
		playingBoardNode.position.x += 50
	}
	
	// MARK: AUDIO
	
	func pauseAudio() {
		backgroundMusicPlayer.pause()
	}
	
	func resumeAudio() {
		backgroundMusicPlayer.play()
	}
	
	// MARK: PLAYER ACTIONS
	
	func playerDissapear() {
		player.removeAllActions()
		let dissapearRotateAngle = CGFloat(720).degreesToRadians()
		let playerDissapearSpin = SKAction.rotateByAngle(dissapearRotateAngle, duration: 0.5)
		let playerDissapearShrink = SKAction.scaleTo(0, duration: 0.5)
		let dissapearSequence = SKAction.group([
			playerDissapearSpin,
			playerDissapearShrink
			])
		player.runAction(dissapearSequence)
		
	}
	
	func mirrorPlayerDissapear() {
		mirrorPlayer.removeAllActions()
		let dissapearRotateAngle = CGFloat(720).degreesToRadians()
		let playerDissapearSpin = SKAction.rotateByAngle(dissapearRotateAngle, duration: 0.5)
		let playerDissapearShrink = SKAction.scaleTo(0, duration: 0.5)
		let dissapearSequence = SKAction.group([
			playerDissapearSpin,
			playerDissapearShrink
			])
		mirrorPlayer.runAction(dissapearSequence)
	}
	
	func playerDeath() {
		
	}
	
	func mirrorPlayerDeath() {
		
	}
	
	
	//MARK: GAME ACTIONS
	
	func advanceToNextLevel() {
		
				let scene = World1Level6(size: gameSize)
				let transition = SKTransition.revealWithDirection(.Left, duration: 1.0)
				scene.scaleMode = .AspectFill
				removeAllChildren()
				view!.presentScene(scene, transition: transition)
		
	}
	
	func didRestartLevel() {
		let scene = World1Level5(size: gameSize)
		let transition = SKTransition.crossFadeWithDuration(1.5)
		scene.scaleMode = .AspectFill
		removeAllChildren()
		view!.presentScene(scene, transition: transition)
		
	}
	
	func didGoToLevelsScreen() {
		let transition = SKTransition.moveInWithDirection(.Left, duration: 1)
		let scene = LevelsScene(size:(CGSize(width: 2048, height: 1536)))
		scene.scaleMode = .AspectFill
		view!.presentScene(scene, transition: transition)
		
	}
	
	func didQuitToMainMenu() {
		let transition = SKTransition.moveInWithDirection(.Right, duration: 1)
		let scene = MainMenuScene(size:(CGSize(width: 2048, height: 1536)))
		scene.scaleMode = .AspectFill
		view!.presentScene(scene, transition: transition)
		
	}
	
	// MARK: GAME STATES
	
	func switchToPause() {
		gameState = .Pause
		fadeInPauseMenu()
		fadeOutPauseButton()
		pauseAudio()
		
		
	}
	
	func switchToTutorial() {
		gameState = .Tutorial
		//		setupBackground()
		//		setupForeground()
		//		setupPlayer()
		//		setupSombrero()
		//		setupLabel()
		//		setupTutorial()
		//		setupPlayerAnimation()
	}
	
	func switchToPlay() {
		gameState = .Play
		fadeOutPauseMenu()
		fadeInResumeFromPauseButton()
		resumeAudio()
	}
	
	
	
	func switchToFalling() {
		gameState = .CompletedLevel
		
	}
	
	
	
	func switchToGameOver() {
		self.runAction(playerDeathSound)
		player.removeAllActions()
		mirrorPlayer.removeAllActions()
		gameState = .PlayerDead
		displayGameOverScreen()
		let waitForLoseScreen = SKAction.waitForDuration(3)
		runAction(SKAction.sequence([waitForLoseScreen, SKAction.runBlock(didRestartLevel)]))
	}
	
	// MARK: USER INPUT
	func defineSwipes() {
		
		let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(_:)))
		swipeRight.direction = .Right
		view!.addGestureRecognizer(swipeRight)
		
		
		let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(_:)))
		swipeLeft.direction = .Left
		view!.addGestureRecognizer(swipeLeft)
		
		
		let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(_:)))
		swipeUp.direction = .Up
		view!.addGestureRecognizer(swipeUp)
		
		
		let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(_:)))
		swipeDown.direction = .Down
		view!.addGestureRecognizer(swipeDown)
		
	}
	
	func swipedRight(sender:UISwipeGestureRecognizer){
		if !playerDead {
			checkMovementLogic("right")
			print("Hit Deivation = \(hitDeivationWall)")
			print("Hit Wall = \(hitWall)")
		}
		
		
	}
	
	func swipedLeft(sender:UISwipeGestureRecognizer){
		
		if !playerDead {
			checkMovementLogic("left")
			print("Hit Deivation = \(hitDeivationWall)")
			print("Hit Wall = \(hitWall)")
		}
	}
	
	func swipedUp(sender:UISwipeGestureRecognizer){
		if !playerDead {
			checkMovementLogic("up")
			print("Hit Deivation = \(hitDeivationWall)")
			print("Hit Wall = \(hitWall)")
		}
	}
	
	func swipedDown(sender:UISwipeGestureRecognizer){
		
		if !playerDead {
			checkMovementLogic("down")
			print("Hit Deivation = \(hitDeivationWall)")
			print("Hit Wall = \(hitWall)")
		}
	}
	
	func playerPositionBounceBack(oldPosition: CGPoint){
		if !playerDead {
			player.runAction(SKAction.moveTo(oldPosition, duration: 0.1))
			print("Player Bounced Back")
		}
	}
	
	func mirrorPositionBounceBack(oldPosition: CGPoint){
		if !playerDead {
			mirrorPlayer.runAction(SKAction.moveTo(oldPosition, duration: 0.1))
			
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		if let touch = touches.first {
			sceneTouched(touch.locationInNode(self))
		}
		//		super.touchesBegan(touches, withEvent:event)
	}
	
	
	func sceneTouched(location: CGPoint) {
		//1
		let targetNode = nodeAtPoint(location)
		
		print(targetNode.name)
		
		if gameState == .Play {
			if targetNode.name == "Pause" {
				print("Touched Pause")
				switchToPause()
				
			}
		} else if gameState == .Pause {
			
			if targetNode.name == "UnPause" {
				
				switchToPlay()
			}
				
			else if targetNode.name == "Restart" {
				didRestartLevel()
				removeAllChildren()
				
			}
				
			else if targetNode.name == "Levels" {
				didGoToLevelsScreen()
				removeAllChildren()
			}
				
			else if targetNode.name == "Quit" {
				didQuitToMainMenu()
				removeAllChildren()
			}
		}
		
		//2
		if targetNode.name == "Player" {
			return
		}
		//3
		
	}
	
	
	// MARK: MOVEMENT LOGIC
	
	func checkMovementLogic(swipeDirection: String) {
		if gameState == .Play {
			
			checkHitModifier()
			
			if swipeDirection == "right" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.runAction(SKAction.sequence([
					movePlayerRight,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.runBlock({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			if swipeDirection == "left" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.runAction(SKAction.sequence([
					movePlayerLeft,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.runBlock({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			if swipeDirection == "up" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.runAction(SKAction.sequence([
					movePlayerUp,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.runBlock({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			
			if swipeDirection == "down" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.runAction(SKAction.sequence([
					movePlayerDown,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.runBlock({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})					]))
			}
			
		}
		
	}
	
	
	func checkMirrorOffGrid(swipeDirection: String, mirrorPositionBeforeMove position: CGPoint) {
		if swipeDirection == "left" {
			if mirrorPlayer.position.x < matrixGridRight["H1"]!.x {
				mirrorPositionBounceBack(position)
				//				mirrorPlayer.runAction(SKAction.sequence([
				//					SKAction.fadeAlphaTo(0, duration: 0.1),
				//					SKAction.runBlock({self.mirrorPlayer.position = CGPoint(x: matrixGridRight["K4"]!.x, y: self.mirrorPositionBeforeMove.y)}),
				//					SKAction.fadeAlphaTo(1, duration: 0.1)
				//					]))
				
			}
		}
		
		if swipeDirection == "right" {
			
			if mirrorPlayer.position.x > matrixGridRight["K4"]!.x + 50{
				mirrorPositionBounceBack(position)
				//				mirrorPlayer.runAction(SKAction.sequence([
				//					SKAction.fadeAlphaTo(0, duration: 0.1),
				//					SKAction.runBlock({self.mirrorPlayer.position = CGPoint(x: matrixGridRight["H1"]!.x, y: self.mirrorPositionBeforeMove.y)}),
				//					SKAction.fadeAlphaTo(1, duration: 0.1)
				//					]))
			}
		}
		if swipeDirection == "down" {
			
			if mirrorPlayer.position.y < matrixGridRight["K4"]!.y {
				mirrorPositionBounceBack(position)
				//				mirrorPlayer.runAction(SKAction.sequence([
				//					SKAction.fadeAlphaTo(0, duration: 0.1),
				//					SKAction.runBlock({self.mirrorPlayer.position = CGPoint(x: self.mirrorPositionBeforeMove.x, y: matrixGridRight["H1"]!.y)}),
				//					SKAction.fadeAlphaTo(1, duration: 0.1)
				//
			}
		}
		if swipeDirection == "up" {
			
			if mirrorPlayer.position.y > matrixGridRight["H1"]!.y + 25 {
				mirrorPositionBounceBack(position)
				//				mirrorPlayer.runAction(SKAction.sequence([
				//					SKAction.fadeAlphaTo(0, duration: 0.1),
				//					SKAction.runBlock({self.mirrorPlayer.position = CGPoint(x: self.mirrorPositionBeforeMove.x, y: matrixGridRight["K4"]!.y)}),
				//					SKAction.fadeAlphaTo(1, duration: 0.1)
				//					]))
				
			}
		}
		
	}
	
	//MIRROR MOVEMENT LOGIC WITH WRAP AROUND BOUNCE BACK
	/*
	func checkMirrorMovementLogic(swipeDirection: String, shouldLoop: Bool) {
	
	if doubleMoverOn {
	
	if swipeDirection == "right" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	}
	
	
	if swipeDirection == "left" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "up" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "down" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	} else if oppositerOn {
	
	if swipeDirection == "right" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	}
	
	
	if swipeDirection == "left" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "up" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "down" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	} else if holderOn {
	
	if swipeDirection == "right" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	}
	
	
	if swipeDirection == "left" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "up" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "down" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	} else {
	if swipeDirection == "right" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorRight,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	}
	
	
	if swipeDirection == "left" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorLeft,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "up" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorUp,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	
	
	if swipeDirection == "down" {
	
	swipesMade += 1
	if hitWall {
	hitWall = false
	} else if hitDeivationWall {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	hitDeivationWall = false
	} else {
	mirrorPlayer.runAction(SKAction.sequence([
	moveMirrorDown,
	mirrorMoveSound,
	SKAction.runBlock({self.checkMirrorOffGrid(swipeDirection)})
	]))
	}
	
	}
	}
	
	}
	*/
	
	func checkMirrorMovementLogic(swipeDirection: String, mirrorPositionBeforeMove position: CGPoint, shouldLoop: Bool) {
		
		if doubleMoverOn {
			
			if swipeDirection == "right" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						moveMirrorRight,
						mirrorMoveSound,
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						moveMirrorRight,
						mirrorMoveSound
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						moveMirrorLeft,
						mirrorMoveSound,
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						moveMirrorLeft,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						moveMirrorUp,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						moveMirrorUp,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						moveMirrorDown,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						moveMirrorDown,
						mirrorMoveSound
						]))
				}
				
			}
			
		} else if oppositerOn {
			
			if swipeDirection == "right" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound
						]))
				}
			}
			
		} else if holderOn {
			
			if swipeDirection == "right" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound
						]))
				}
				
			}
			
		} else {
			if swipeDirection == "right" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				swipesMade += 1
				if hitWall {
					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.runAction(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						]))
				}
				
			}
		}

	}
	
	func checkHitModifier() {
		if hitHolder {
			
			if !holderOn {
				oppositerOn = false
				holderOn = true
				doubleMoverOn = false
				hitHolder = false
				print("Holder On")

			} else {
				holderOn = false
			}
			hitHolder = false
		}
		if hitOppositer {
			if !oppositerOn {
				oppositerOn = true
				holderOn = false
				doubleMoverOn = false
				hitOppositer = false
				print("Oppositer On")
			} else {
				oppositerOn = false
			}
			hitOppositer = false
		}
		if hitDoubleMover {
			if !doubleMoverOn {
				oppositerOn = false
				holderOn = false
				doubleMoverOn = true
				hitDoubleMover = false
				print("Doubler On")
			} else {
				doubleMoverOn = false
			}
			hitDoubleMover = false
		}
	}
	
	
	
	// MARK: PHYSICS
	
	func createGoalSpark(at position: CGPoint) {
		let goalEmitter = SKEmitterNode(fileNamed: "GoalSpark.sks")
		
		goalEmitter!.position = position
		goalEmitter!.name = "goalEmitter"
		goalEmitter!.zPosition = GameLayer.Goal.rawValue
		playingBoardNode.addChild(goalEmitter!)
		
	}
	
	func createDoublerSpark(at position: CGPoint, withNode node: SKSpriteNode) {
		let emitter = SKEmitterNode(fileNamed: "ModifierParticles.sks")
		
		emitter!.position = position
		emitter!.name = "modifierEmitter"
		node.addChild(emitter!)
		emitter!.zPosition = GameLayer.ModifierParticles.rawValue
		
	}
	
	func createModifierSpark(withNode node: SKSpriteNode) {
		
		if node == player {
			player.emitter.particleBirthRate = 1000
		}
		
		
	}
	
	func modifierColorCycler(node: SKSpriteNode) {
		
		let colorizeActionForever = SKAction.repeatActionForever(
			SKAction.sequence([
				SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0.5),
				SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 0.5, duration: 0.5),
				SKAction.colorizeWithColor(SKColor.blueColor(), colorBlendFactor: 0.5, duration: 0.5),
				
				])
		)
		//				SKAction.colorizeWithColorBlendFactor(0.0, duration: 1.0),
		
		node.runAction(colorizeActionForever, withKey: "colorizeAction")
		
	}
	
	func centerPlayerOnTile() {
	}
	
	func didEndContact(contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if collision == PhysicsCategory.Player | PhysicsCategory.Goal {
			playerHitGoal = false
			print("player off of goal")
		}
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask |
			contact.bodyB.categoryBitMask
		
		
		if collision == PhysicsCategory.Player | PhysicsCategory.Wall {
			hitWall = true
			playerPositionBounceBack(playerPositionBeforeMove)
			//
			//			mirrorPlayer.runAction(SKAction.sequence([
			//				SKAction.waitForDuration(0.2),
			//				SKAction.runBlock({self.mirrorPositionBounceBack(self.mirrorPositionBeforeMove)})
			//				]))
			
			
		}
		
		if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Wall {
			hitWall = true
			
			playerPositionBounceBack(playerPositionBeforeMove)
			mirrorPositionBounceBack(mirrorPositionBeforeMove)
			//
			//			mirrorPlayer.runAction(SKAction.sequence([
			//				SKAction.waitForDuration(0.2),
			//				SKAction.runBlock({self.mirrorPositionBounceBack(self.mirrorPositionBeforeMove)})
			//				]))
			
			
		}
		
		if collision == PhysicsCategory.Player | PhysicsCategory.WallDeivation {
			hitDeivationWall = true
			
			playerPositionBounceBack(playerPositionBeforeMove)
			
			//TODO: Need to make WallPath Object created with two "versions" so when the player hits it, they can be switched out.
			if contact.bodyA.node?.name == "WallDeivation" {
				let hitWall = contact.bodyA.node as! WallPath
				hitWall.changeWallType(.Wall)
				
			} else if contact.bodyB.node?.name == "WallDeivation" {
				let hitWall = contact.bodyB.node as! WallPath
				hitWall.changeWallType(.Wall)			}
		}
		
		if collision == PhysicsCategory.Player | PhysicsCategory.Modifier {
			
			modifierColorCycler(player)
			modifierColorCycler(mirrorPlayer)
			
			if contact.bodyA.node?.name == "Holder" || contact.bodyB.node?.name == "Holder" {
				hitHolder = true
				
			}
			
			if contact.bodyA.node?.name == "DoubleMover" || contact.bodyB.node?.name == "DoubleMover" {
				hitDoubleMover = true
				
				//					createModifierSpark(withNode: player)
				//					createModifierSpark(withNode: mirrorPlayer)
			}
			
			if contact.bodyA.node?.name == "Oppositer" || contact.bodyB.node?.name == "Oppositer" {
				hitOppositer = true
				
				
			}
		}
		
		if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Modifier {
			
			modifierColorCycler(player)
			modifierColorCycler(mirrorPlayer)
			
			if contact.bodyA.node?.name == "Holder" || contact.bodyB.node?.name == "Holder" {
				hitHolder = true
			}
			
			if contact.bodyA.node?.name == "DoubleMover" || contact.bodyB.node?.name == "DoubleMover" {
				hitDoubleMover = true
			}
			
			if contact.bodyA.node?.name == "Oppositer" || contact.bodyB.node?.name == "Oppositer" {
				hitOppositer = true
			}
		}
		
		if collision == PhysicsCategory.Player | PhysicsCategory.Obstacle {
			switchToGameOver()
			
		} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Obstacle {
			switchToGameOver()
		}
		
		if collision == PhysicsCategory.Player | PhysicsCategory.Goal {
			playerHitGoal = true
			
		}
		
		
		if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Goal {
			if playerHitGoal == true {
				print("The number of swipes for this level was \(swipesMade)")
			
				
				let levelCompleteSequence = SKAction.sequence([
					SKAction.waitForDuration(0.2),
					SKAction.group([
						SKAction.runBlock(mirrorPlayerDissapear),
						SKAction.runBlock(playerDissapear),
						playerAtGoalSound,
						SKAction.runBlock({(self.createGoalSpark(at: self.mirrorPlayer.position))}),
						SKAction.runBlock({(self.createGoalSpark(at: self.player.position))})
						]),
					//					SKAction.runBlock(removeAllActions),
					SKAction.waitForDuration(1.5),
					SKAction.runBlock(setupSuccessScreen),
					SKAction.runBlock(displaySuccessScreen),
					SKAction.waitForDuration(waitTimeToLoadNextLevel),
					SKAction.runBlock(advanceToNextLevel)
					])
				
				let defaults = NSUserDefaults.standardUserDefaults()
				defaults.setInteger(swipesMade, forKey: "Swipes-World1Level5")
				runAction(levelCompleteSequence)
			}
		}
	}
	
	// MARK: GENERAL VARIABLES
	
	
	var gameState: GameState = .Play
	
	var buttonCenteredPosition: CGFloat
	
	var pauseMenuBackgroundBox = SKShapeNode()
	var gameOverScreen = SKSpriteNode(imageNamed: "gameOverScreen")
	let restartButton = SKSpriteNode(imageNamed: "restartButton")
	let backToGameButton = SKSpriteNode(imageNamed: "backArrow")
	let levelsButton = SKSpriteNode(imageNamed: "levelButton")
	let quitButton = SKSpriteNode(imageNamed: "quitButton")
	let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
	
	let successScreen = SuccessScreenLayover(successStarCount: 2)
	
	
	var player = Player()
	var mirrorPlayer = Player()
	
	
	let backgroundNode = SKNode()
	let playingBoardNode = SKNode()
	let levelDescriptionNode = SKNode()
	let uiNode = SKNode()
	let uiGameOverNode = SKNode()
	let uiPlayNode = SKNode()
	
	
	var numberOfColumnAllysInGrid: Int
	
	
	var doubleMoverOn = false
	var holderOn = false
	var oppositerOn = false
	
	var hitHolder = false
	var hitDoubleMover = false
	var hitOppositer = false
	
	var playableRect: CGRect
	var playableHeight: CGFloat
	var playableMargin: CGFloat
	var tileSide: CGFloat
	var tileSize: CGSize
	var tileBufferWidth: CGFloat
	var firstTileBufferWidth: CGFloat
	var tileBufferHeight: CGFloat
	var bottomGridYPosition: CGFloat
	var playerPositionBeforeMove: CGPoint
	var mirrorPositionBeforeMove: CGPoint
	
	var leftPlayableArea: CGRect
	var rightPlayableArea: CGRect
	
	var playerDead = false
	var hitDeivationWall = false
	var hitWall = false
	var playerHitGoal = false
	
	
	var movePlayerRight: SKAction
	var movePlayerLeft: SKAction
	var movePlayerUp: SKAction
	var movePlayerDown: SKAction
	
	var mirrorWaitMove: SKAction
	var mirrorWaitBounce: SKAction
	var moveMirrorRight: SKAction
	var moveMirrorLeft: SKAction
	var moveMirrorUp: SKAction
	var moveMirrorDown: SKAction
	
	
	
	var wall1StartPosition: CGPoint
	var wall2StartPosition: CGPoint
	
	
	var gridStartPosition: CGPoint
	var referencePointsStartPosition: CGPoint
	var horizontalWallStartPosition: CGPoint
	
	// Bounce button
	let scaleUp = SKAction.scaleTo(gameObjectsScaleUpToSize, duration: gameObjectsScaleDuration)
	let scaleDown = SKAction.scaleTo(gameObjectsScaleDownToSize, duration: gameObjectsScaleDuration)
	
	
	
}
