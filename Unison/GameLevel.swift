//
//  GameLevel.swift
//  Unison
//
//  Created by Karl H Kuhn on 2/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit
import AVFoundation
import Foundation

enum TutorialBoxNumber {
	case tutorialBox0
	case tutorialBox1
	case tutorialBox2
	case tutorialBox3
	case tutorialBox4
	case tutorialBox5
}




class GameLevel: SKScene, SKPhysicsContactDelegate {
	
//	var moc: NSManagedObjectContext?

	
	//MARK: LEVEL VARIABLES

	var nextSceneIsWinScene = false
	
	var currentLevelNumber: Int?
	var theNextLevel: GameLevel?
	var theCurrentLevel: GameLevel?
	var currentLevelTitle: String
	var numberOfRowsInGrid: Int
	var numberOfTilesPerRow: Int
	var playerGridStartNumber: String
	var mirrorPlayerGridStartPosition: String
	var goalTilePosition: CGPoint?
	var mirrorGoalTilePosition: CGPoint?
	var backgroundImage: String?
	
	var goalTiles: [SKSpriteNode]?
	
	var gameObjectArray = [SKNode]()
	var theFilePath: String?
	
	var loadedLevelGoals: [SKNode]?
	var theXPosition: NSNumber?
	var theYPosition: NSNumber?
	
	var numberOfVerticalWalls = 0
	var numberofHorizontalWalls = 0
	var numberofHorizontalWallDeivations = 0
	var numberOfVerticalWallDeivations = 0
	var gameObjectArrayName: String?
	
	
	
	// MARK: GENERAL VARIABLES
	
	let gameLevelNotifier = NotificationCenter.default
	var gameState: GameState
	
	var buttonCenteredPosition: CGFloat
	
	var tutorialScreenBackgroundBox = SKShapeNode()
	var pauseMenuBackgroundBox = SKShapeNode()
	var designMenuToolboxBox = SKShapeNode()
	var gameOverScreen = SKSpriteNode(imageNamed: "gameOverScreen")
	let restartButton = SKSpriteNode(imageNamed: "restartButton")
	let backToGameButton = SKSpriteNode(imageNamed: "backArrow")
	let levelsButton = SKSpriteNode(imageNamed: "levelButton")
	let quitButton = SKSpriteNode(imageNamed: "quitButton")
	let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
	let designLevelButton = SKSpriteNode(imageNamed: "levelDesignButton")
	let resetDesignButton = SKSpriteNode(imageNamed: "resetDesignButton")
	let verticalWallButton = SKSpriteNode(imageNamed: "wallObstacle")
	let horizontalWallButton = SKSpriteNode(imageNamed: "wallObstacle")
	let verticalDeivationWallButton = SKSpriteNode(imageNamed: "wallDeivationObstacle")
	let horizontalDeivationWallButton = SKSpriteNode(imageNamed: "wallDeivationObstacle")
	let verticalSpikeWallButton = SKSpriteNode(imageNamed: "metal-spike-block")
	let horizontalSpikeWallButton = SKSpriteNode(imageNamed: "metal-spike-block")
	let oppositerDesignButton = SKSpriteNode(imageNamed: "modifierOppositer")
	let holderDesignButton = SKSpriteNode(imageNamed: "modifierHolder")
	let doubleMoverDesignButton = SKSpriteNode(imageNamed: "modifierDoubleMover")
	let goalDesignButton = SKSpriteNode(imageNamed: "goalTile")
	let mirrorGoalDesignButton = SKSpriteNode(imageNamed: "goalTile")
	let playerDesignButton = SKSpriteNode(imageNamed: "GreenPlayerSad")
	let enemyDesignButton = SKSpriteNode(imageNamed: "monster02_idle")
	let enemyLeftRightButton = SKSpriteNode(imageNamed: "MonsterMoveLeftRightButton")
	let enemyUpDownButton = SKSpriteNode(imageNamed: "MonsterMoveUpDownButton")
	let mirrorPlayerDesignButton = SKSpriteNode(imageNamed: "RedPlayerSad")
	let cancelDesignObjectButton = SKSpriteNode(imageNamed: "cancelObjectIcon")
	let leftOutOfBoundsBorder = SKShapeNode()
	let rightOutOfBoundsBorder = SKShapeNode()
	let tileGroupSelectedBorder = SKShapeNode()
	let readyText = SKLabelNode(fontNamed: "BubbleGum")
	let goText = SKLabelNode(fontNamed: "BubbleGum")
	
	var pauseButtonSize: CGSize



	
	var heldDesignNode: SKNode?

	var theTiles = [TileObject]()
	
	let successScreen = SuccessScreenLayover(successStarCount: 2)
	
	
	var player: PlayerObject
	var mirrorPlayer: PlayerObject
	
	var tutorialBoxes = [TutorialBox]()
	var currentTutorialBox: Int = 0
	

	
	let scoreTimer = ScoreKeeper()
	
	let mainLevelNode = SKNode()
	let backgroundNode = SKNode()
	let playingBoardNode = SKNode()
	let levelDescriptionNode = SKNode()
	let uiNode = SKNode()
	let uiGameOverNode = SKNode()
	let uiPlayNode = SKNode()
	let uiDesignNode = SKNode()
	let uiTutorialNode = SKNode()
	var fadeBox = SKShapeNode()
	
	
	var numberOfColumnAllysInGrid: Int
	
	
	var doubleMoverOn = false
	var holderOn = false
	var oppositerOn = false
	
	var hitHolder = false
	var hitDoubleMover = false
	var hitOppositer = false
	
	var isHoldingPlayer = false
	var isHoldingMirrorPlayer = false
	var isHoldingGoal = false
	var isHoldingMirrorGoal = false
	var isTouchingTrash = false
	
	var playableRect: CGRect
	var playableHeight: CGFloat
	var playableMargin: CGFloat
	var tileSide: CGFloat
	var tileSize: CGSize
	var modifierSize: CGSize
	var ballObjectSize: CGSize
	var tileBufferWidth: CGFloat
	var firstTileBufferWidth: CGFloat
	var tileBufferHeight: CGFloat
	var movingTileOffScreenLeftPositionX: CGFloat = 0
	var movingTileOffScreenRightPositionX: CGFloat = 0
	var movingTileOffScreenTopPositionY: CGFloat = 0
	var movingTileOffScreenBottomPositionY: CGFloat = 0
	var bottomGridYPosition: CGFloat
	var playerPositionBeforeMove: CGPoint
	var mirrorPositionBeforeMove: CGPoint
	var tutorialPreMovePosition: CGPoint = CGPoint.zero
	var wallSize: CGSize
	var playerSize: CGSize
	
	
	var designReleasePosition: CGPoint = CGPoint.zero
	var currentHeldDesignObject: DesignObject = .none
//	var currentHeldVerticalWallDataObjet: VerticalWall?
//	var currentHeldGoalDataObject: LevelGoal?
//	var currentHeldVerticalWallDeivationDataObjet: VerticalWallDeivation?
//	var currentHeldHorizontalWallDataObjet: HorizontalWall?
//	var currentHeldHorizontalWallDeivationDataObjet: HorizontalWallDeivation?
	var currentHeldSpriteNode: SKNode?
	var movingSpriteNode: SKNode?
	var currentHeldSpriteNodeReferenceNumber: Int?
	
	var leftPlayableArea: CGRect
	var rightPlayableArea: CGRect
	
	var playerDead = false
	var hitDeivationWall = false
	var hitWall = false
	var playerHitGoal = false
	var mirrorPlayerHitGoal = false
	
	
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
	
	
	var startOffScreen: SKAction
	var moveToCenterOfScreen: SKAction
	var moveToOffScreen: SKAction
	
	let levelDescriptionSetToAlpha: SKAction

	
	
	var wall1StartPosition: CGPoint
	var wall2StartPosition: CGPoint
	
	
	var gridStartPosition: CGPoint
	var referencePointsStartPosition: CGPoint
	var horizontalWallStartPosition: CGPoint
	
	// Bounce button
	let scaleUp = SKAction.scale(to: gameObjectsScaleUpToSize, duration: gameObjectsScaleDuration)
	let scaleDown = SKAction.scale(to: gameObjectsScaleDownToSize, duration: gameObjectsScaleDuration)
	
	var justUnlockedThisLevel: Int?
	
	
	let skySongUrl = URL(fileURLWithPath: "SkyWorldMusic.mp3")

	
	//MARK: INIT
	

	
	required override init (size: CGSize) {
		
		
		
		currentLevelTitle = " [NEED LEVEL NAME]"
		numberOfRowsInGrid = 4
		numberOfTilesPerRow = 4
		playerGridStartNumber = "H1"
		mirrorPlayerGridStartPosition = "H1"
//		goalTilePosition = "K1"
//		mirrorGoalTilePosition = "K1"
		gameState = .levelPreStart
		backgroundImage = "background1"
//		
//		let manager = NSFileManager.defaultManager()
//		let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
//		filePath = url.URLByAppendingPathComponent(gameObjectArrayName!).path!
		
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
		modifierSize = CGSize(width: tileSide * 0.7, height: tileSide * 0.7)
		ballObjectSize = CGSize(width: tileSide / 2.5, height: tileSide / 2.5)
		tileBufferWidth = tileSide * 0.6  //Space between the tiles
		firstTileBufferWidth = tileSide * 0.0001
		tileBufferHeight = tileSide * 0.4
		wallSize = CGSize(width: tileSide, height: tileSide * 0.2)
		playerSize = CGSize(width: tileSide * 0.8, height: tileSide * 0.8)

		
		numberOfColumnAllysInGrid = numberOfRowsInGrid - 1
		
		
		referencePointsStartPosition = CGPoint(x: firstTileBufferWidth * 5 - 15, y: size.height - playableMargin - tileSide * 0.70)
		
		gridStartPosition = CGPoint(x: firstTileBufferWidth * 5, y: size.height - playableMargin - tileSide - tileBufferHeight)
		horizontalWallStartPosition = CGPoint(x: firstTileBufferWidth * 5, y: size.height - playableMargin - tileSide - tileSide/2 - tileBufferHeight)
		
		wall1StartPosition = gridStartPosition + CGPoint(x: tileBufferWidth * 2.3, y: 0)
		
		bottomGridYPosition = wall1StartPosition.y - (tileSide * 3) - (tileBufferHeight * 3)
		
		
		wall2StartPosition = wall1StartPosition + CGPoint(x: tileSide + tileBufferWidth, y: 0)
		
		tutorialScreenBackgroundBox = SKShapeNode(rect: CGRect(x: 350, y: playableRect.size.height - playableMargin - 600, width: playableRect.size.width - 700, height: playableRect.size.height - 800))
		
		pauseMenuBackgroundBox = SKShapeNode(rect: CGRect(x: 700, y: playableRect.size.height - playableMargin - 500, width: playableRect.size.width - 1400, height: playableRect.size.height - 400))
		pauseButtonSize = CGSize(width: pauseButton.size.width * 0.65, height: pauseButton.size.height * 0.65)
		designMenuToolboxBox = SKShapeNode(rect: CGRect(x: 20, y: 220, width: playableRect.size.width - 140, height: 300))
		
		fadeBox = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: gameSize))
		
		movePlayerRight = SKAction.moveBy(x: tileSide + tileBufferWidth, y: 0, duration: playerMoveSpeedByDuration)
		movePlayerLeft = SKAction.moveBy(x: -tileSide - tileBufferWidth, y: 0, duration: playerMoveSpeedByDuration)
		movePlayerUp = SKAction.moveBy(x: 0, y: tileSide + tileBufferHeight, duration: playerMoveSpeedByDuration)
		movePlayerDown = SKAction.moveBy(x: 0, y: -tileSide - tileBufferHeight, duration: playerMoveSpeedByDuration)
		
		mirrorWaitMove = SKAction.wait(forDuration: mirrorMoveWaitTime)
		mirrorWaitBounce = SKAction.wait(forDuration: mirrorBounceWaitTime)
		moveMirrorRight = SKAction.moveBy(x: tileSide + tileBufferWidth, y: 0, duration: mirrorMoveSpeedByDuration)
		moveMirrorLeft = SKAction.moveBy(x: -tileSide - tileBufferWidth, y: 0, duration: mirrorMoveSpeedByDuration)
		moveMirrorUp = SKAction.moveBy(x: 0, y: tileSide + tileBufferHeight, duration: mirrorMoveSpeedByDuration)
		moveMirrorDown = SKAction.moveBy(x: 0, y: -tileSide - tileBufferHeight, duration: mirrorMoveSpeedByDuration)
		
		levelDescriptionSetToAlpha = SKAction.fadeAlpha(to: 0, duration: 0)
		
		scaleUp.timingMode = .easeInEaseOut
		scaleDown.timingMode = .easeInEaseOut
		
		
		startOffScreen = SKAction.moveTo(x: -2000 , duration: 0)
		moveToCenterOfScreen = SKAction.moveTo(x: size.width / 2, duration: 0.7)
		moveToOffScreen = SKAction.moveTo(x: playableRect.size.width + 2000 , duration: 0.7)
		
		moveToCenterOfScreen.timingMode = .easeOut
		moveToOffScreen.timingMode = .easeIn
		player = PlayerObject()
		mirrorPlayer = PlayerObject()
		
		
		super.init(size: size)
		
		
	}
	
	override func didMove(to view: SKView) {
		
		firstSetupLeftGrid()
		firstSetupRightGrid()
		firstSetupLeftGridReferencePoints()
		firstSetupRightGridReferencePoints()
		loadLevel(theLevel: currentLevelNumber)
		setupLevel()
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self
		playingBoardNode.position.x += 50
		defineSwipes()

		
		
		

	}
	
	override func willMove(from view: SKView) {
//		
//		playingBoardNode.enumerateChildNodes(withName: "YellowTileBlock", using: {node, stop in
//			node.removeAllActions() })
//
//		playingBoardNode.enumerateChildNodes(withName: "SilverTileBlock", using: {node, stop in
//			node.removeAllActions() })
//		
//		matrixGridLeft.removeAll()
//		matrixGridRight.removeAll()
//		matrixGridLeftHorzReferencePoints.removeAll()
//		matrixGridRightHorzReferencePoints.removeAll()
//		matrixGridLeftVertReferencePoints.removeAll()
//		matrixGridRightVertReferencePoints.removeAll()
//		mainLevelNode.removeAllChildren()
//		self.removeAllActions()
//		self.removeAllChildren()
//		if !gameObjectArray.isEmpty {
//			gameObjectArray.removeAll()
//		}
//		print("Did move from view")
		
		
	}
	
	
	
	
	
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	

	
	func setupLevelDataArchive() {
		
		var filePath:String {
			let manager = FileManager.default
			let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
			return url.appendingPathComponent(gameObjectArrayName!).path
		}
		
		theFilePath = filePath

		
		if let array = NSKeyedUnarchiver.unarchiveObject(withFile: theFilePath!) as? [AnyObject] {
			gameObjectArray = array as! [SKNode]
			print("There are \(array.count) objects currently on this level's array")
			
			
			//ADD THE OBJECTS TO THE PLAYING BOARD
			if !gameObjectArray.isEmpty {
				for obj in 0..<gameObjectArray.count {
					
					if gameObjectArray[obj].name == "Player" {
						player = gameObjectArray[obj] as! PlayerObject
						playingBoardNode.addChild(player)
						print("Player added from arhive")
					} else if gameObjectArray[obj].name == "MirrorPlayer" {
						mirrorPlayer = gameObjectArray[obj] as! PlayerObject
						playingBoardNode.addChild(mirrorPlayer)
						print("Mirror Player added from arhive")
					} else {
						let newObject = gameObjectArray[obj]
						playingBoardNode.addChild(newObject)
						print(" --------------------")
						print("the new object is....")
						print(newObject)
					}
				}
			}
		}
	}
	

	
	
	func setupLevel() {

		setupLevelNodes()
		setupBackground(withImageNamed: backgroundImage)
		setupBackgroundMusic()
		levelDescriptionNode.run(levelDescriptionSetToAlpha)
		setupBorders()
		setupLevelDescription()
		setupPauseMenuUI()
		setupPauseButton()
		fadeInPauseButton()
		setupGameOverScreen()
		setupDesignToolBoxUI()
		addScoreKeeper()
		
		print("The GO-Name is \(String(describing: gameObjectArrayName))")

		
		
	}
	
	func setupBackgroundMusic() {
		if backgroundMusicPlayer.isPlaying {
			if currentLevelNumber! <= 10 {
				if backgroundMusicPlayer.url ==  Bundle.main.url(forResource: "MeloTechnoLevelSong", withExtension: "mp3") {
					
				} else {
					playBackgroundMusic("MeloTechnoLevelSong.mp3")
				}
			} else {
				if backgroundMusicPlayer.url ==  Bundle.main.url(forResource: "SkyWorldMusic", withExtension: "mp3") {
					
				} else {
					playBackgroundMusic("SkyWorldMusic.mp3")
				}
			}
		}
	}
	
	func addScoreKeeper() {
		scoreTimer.position = CGPoint(x: playableRect.size.width / 2, y: bottomUIYPosition)
		
		scoreTimer.timerCount = 20000
		
		if currentLevelNumber! > 10 {
			scoreTimer.label.color = UIColor.green
		}

		playingBoardNode.addChild(scoreTimer)
	}
	
	func fadeScreen() {
		fadeBox.fillColor = UIColor.black
		fadeBox.strokeColor = UIColor.clear
	}
	
	func setupLevelNodes() {
		mainLevelNode.name = "mainLevelNode"
		addChild(mainLevelNode)
		backgroundNode.name = "backgroundNode"
		mainLevelNode.addChild(backgroundNode)
		backgroundNode.zPosition = GameLayer.background.rawValue
		playingBoardNode.name = "playingBoardNode"
		mainLevelNode.addChild(playingBoardNode)
		playingBoardNode.zPosition = GameLayer.playingBoard.rawValue
		levelDescriptionNode.name = "levelDescriptionNode"
		mainLevelNode.addChild(levelDescriptionNode)
		levelDescriptionNode.zPosition = GameLayer.ui.rawValue
		uiNode.name = "uiNode"
		mainLevelNode.addChild(uiNode)
		uiNode.zPosition = GameLayer.uiText.rawValue
		uiGameOverNode.name = "uiGameOverNode"
		mainLevelNode.addChild(uiGameOverNode)
		uiGameOverNode.zPosition = GameLayer.uiText.rawValue
		uiPlayNode.name = "uiPlayNode"
		mainLevelNode.addChild(uiPlayNode)
		uiPlayNode.zPosition = GameLayer.uiText.rawValue
		uiTutorialNode.name = "uiTutorialNode"
		mainLevelNode.addChild(uiTutorialNode)
		uiTutorialNode.zPosition = GameLayer.uiText.rawValue
		uiDesignNode.name = "uiDesignNode"
		mainLevelNode.addChild(uiDesignNode)
		uiDesignNode.zPosition = GameLayer.uiText.rawValue
	}
	
	// MARK: UI SETUPS
	func setupTutorialBox(withText text: String) {
		
		let tutorialBox = TutorialBox(theText: text)
		tutorialBox.position = CGPoint(x: -tutorialBox.tutorialBoxBackground.size.width * 2, y: playableRect.size.height / 2)
		tutorialBoxes.append(tutorialBox)
		uiTutorialNode.addChild(tutorialBox)
		
	}
	
	func testFunc() {
		
	}
	
	func presentNextTutorialBox(_ theTutorialBox: Int) {
	
		if theTutorialBox == 0 {
			switchToTutorial()
			tutorialBoxes[currentTutorialBox].run(moveToCenterOfScreen)
		}
		//ON LAST TUTORIAL BOX
		if theTutorialBox == -1 {
			tutorialBoxes[currentTutorialBox].run(SKAction.sequence([
						moveToOffScreen,
						SKAction.run(tutorialBoxes[currentTutorialBox].removeFromParent),
						SKAction.run(switchToLevelPreStart)
						]))
		}
		//IN MIDDLE OF TUTORIAL BOXES
		if theTutorialBox > 0 {
			tutorialBoxes[currentTutorialBox].run(SKAction.sequence([
				moveToOffScreen,
				SKAction.run(tutorialBoxes[currentTutorialBox].removeFromParent)
				]))
			
			tutorialBoxes[currentTutorialBox + 1].run(moveToCenterOfScreen)
			currentTutorialBox += 1
		}
	}

	func displaySuccessScreen() {
	
		let starsCalculated = starCalculator(currentLevelNumber!, score: Int(scoreTimer.timerCount), minScoreFor2Stars: 14000, minScoreFor3Stars: 17000)
		
		pauseButton.removeFromParent()
		if currentLevelNumber! > 0 {
			saveStars(starsCalculated)
		} else {
			saveStars(3)
		}
		let successScreen = SuccessScreenLayover(successStarCount: starsCalculated)
		successScreen.position = CGPoint(x: -successScreen.theSuccessScreen.size.width, y: playableRect.size.height * 0.8)
		successScreen.zPosition = GameLayer.uiText.rawValue
		
		let fromLeftAction = SKAction.moveTo(x: playableRect.size.width / 2, duration: successScreenAppearDuration)
		fromLeftAction.timingMode = .easeOut
		successScreen.name = "sucessScreen"
		uiPlayNode.addChild(successScreen)
		successScreen.run(fromLeftAction)
	}
	
	func fadeInPauseMenu() {
		if gameState == GameState.levelDesign {
			pauseMenuBackgroundBox.fillColor = UIColor(red: 0.55, green: 0.25, blue: 0.05, alpha: 0.95)
		} else {
			pauseMenuBackgroundBox.fillColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.95)
		}

		let fadeInAction = SKAction.fadeIn(withDuration: pauseScreenFadeInOutDuration)
		uiNode.run(fadeInAction)
	}
	
	func fadeOutPauseMenu() {
		let fadeOutAction = SKAction.fadeOut(withDuration: pauseScreenFadeInOutDuration)
		uiNode.run(fadeOutAction)
	}
	
	func setupPauseMenuUI() {
		uiNode.alpha = 0
		
		pauseMenuBackgroundBox.strokeColor = SKColor.white
		pauseMenuBackgroundBox.lineWidth = 10
		pauseMenuBackgroundBox.fillColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.95)
		pauseMenuBackgroundBox.zPosition = GameLayer.ui.rawValue
		
		restartButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		restartButton.name = "Restart"
		restartButton.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height - 325)
		restartButton.zPosition = GameLayer.uiText.rawValue
		
		backToGameButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		backToGameButton.name = "UnPause"
		backToGameButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y + backToGameButton.size.height)
		backToGameButton.zPosition = GameLayer.uiText.rawValue
		
		levelsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		levelsButton.name = "Levels"
		levelsButton.position = CGPoint(x: restartButton.position.x, y: restartButton.position.y - levelsButton.size.height - 35)
		levelsButton.zPosition = GameLayer.uiText.rawValue
		
		quitButton.anchorPoint = CGPoint(x: 0.5, y:0)
		quitButton.name = "Quit"
		quitButton.position = CGPoint(x: levelsButton.position.x, y: levelsButton.position.y - quitButton.size.height - 35)
		quitButton.zPosition = GameLayer.uiText.rawValue

		pauseMenuBackgroundBox.name = "pauseMenuBackgroundBox"
		uiNode.addChild(pauseMenuBackgroundBox)
		pauseMenuBackgroundBox.addChild(backToGameButton)
		pauseMenuBackgroundBox.addChild(restartButton)
		pauseMenuBackgroundBox.addChild(levelsButton)
		pauseMenuBackgroundBox.addChild(quitButton)
		
//		ADDITIONAL MODES FOR DESIGNING LEVELS

//		designLevelButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		designLevelButton.name = "Design"
//		designLevelButton.position = CGPoint(x: quitButton.position.x, y: quitButton.position.y - designLevelButton.size.height - 35)
//		designLevelButton.zPosition = GameLayer.uiText.rawValue
//
//		resetDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		resetDesignButton.name = "Reset"
//		resetDesignButton.position = CGPoint(x: quitButton.position.x, y: quitButton.position.y - resetDesignButton.size.height - 35)
//		resetDesignButton.zPosition = GameLayer.uiText.rawValue
		
//		pauseMenuBackgroundBox.addChild(designLevelButton)
//		pauseMenuBackgroundBox.addChild(resetDesignButton)
	}
	
	
	
	func setupDesignToolBoxUI() {
		uiDesignNode.alpha = 0
		
		designMenuToolboxBox.strokeColor = SKColor.white
		designMenuToolboxBox.lineWidth = 10
		designMenuToolboxBox.fillColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.75)
		designMenuToolboxBox.zPosition = GameLayer.ui.rawValue
		
		verticalWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		verticalWallButton.name = "VerticalWallDesignButton"
		verticalWallButton.position = CGPoint(x: 100, y: 300)
		verticalWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		verticalWallButton.zRotation = π / 2
		verticalWallButton.zPosition = GameLayer.ui.rawValue
		
		verticalDeivationWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		verticalDeivationWallButton.name = "VerticalDeivationWallDesignButton"
		verticalDeivationWallButton.position = CGPoint(x: verticalWallButton.position.x + designButtonToolboxBuffer * 0.5, y: 300)
		verticalDeivationWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		verticalDeivationWallButton.zRotation = π / 2
		verticalDeivationWallButton.zPosition = GameLayer.ui.rawValue
		
		horizontalWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		horizontalWallButton.name = "HorizontalWallDesignButton"
		horizontalWallButton.position = CGPoint(x: verticalDeivationWallButton.position.x + designButtonToolboxBuffer, y: 300)
		horizontalWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		horizontalWallButton.zPosition = GameLayer.ui.rawValue
		
		horizontalDeivationWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		horizontalDeivationWallButton.name = "HorizontalDeivationWallDesignButton"
		horizontalDeivationWallButton.position = CGPoint(x: horizontalWallButton.position.x + designButtonToolboxBuffer, y: 300)
		horizontalDeivationWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		horizontalDeivationWallButton.zPosition = GameLayer.ui.rawValue
		
		oppositerDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		oppositerDesignButton.name = "OppositerDesignButton"
		oppositerDesignButton.position = CGPoint(x: horizontalDeivationWallButton.position.x + designButtonToolboxBuffer, y: 300)
		oppositerDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		oppositerDesignButton.zPosition = GameLayer.ui.rawValue

		doubleMoverDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		doubleMoverDesignButton.name = "DoubleMoverDesignButton"
		doubleMoverDesignButton.position = CGPoint(x: oppositerDesignButton.position.x + designButtonToolboxBuffer, y: 300)
		doubleMoverDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		doubleMoverDesignButton.zPosition = GameLayer.ui.rawValue
		
		holderDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		holderDesignButton.name = "HolderDesignButton"
		holderDesignButton.position = CGPoint(x: doubleMoverDesignButton.position.x + designButtonToolboxBuffer, y: 300)
		holderDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		holderDesignButton.zPosition = GameLayer.ui.rawValue
		
		goalDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		goalDesignButton.name = "GoalDesignButton"
		goalDesignButton.position = CGPoint(x: holderDesignButton.position.x + designButtonToolboxBuffer, y: 300)
		goalDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		goalDesignButton.zPosition = GameLayer.ui.rawValue

		mirrorGoalDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		mirrorGoalDesignButton.name = "MirrorGoalDesignButton"
		mirrorGoalDesignButton.position = CGPoint(x: goalDesignButton.position.x + designButtonToolboxBuffer, y: 300)
		mirrorGoalDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		mirrorGoalDesignButton.zPosition = GameLayer.ui.rawValue
		
		cancelDesignObjectButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		cancelDesignObjectButton.name = "CancelDesignObjectButton"
		cancelDesignObjectButton.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height / 2)
		cancelDesignObjectButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		cancelDesignObjectButton.zPosition = GameLayer.ui.rawValue
		cancelDesignObjectButton.alpha = 0
		cancelDesignObjectButton.physicsBody = SKPhysicsBody(rectangleOf: cancelDesignObjectButton.size)
		cancelDesignObjectButton.physicsBody?.collisionBitMask = PhysicsCategory.None
		cancelDesignObjectButton.physicsBody?.categoryBitMask = PhysicsCategory.CancelButton
		cancelDesignObjectButton.physicsBody?.contactTestBitMask = PhysicsCategory.Goal
							| PhysicsCategory.HorizontalWall
							| PhysicsCategory.HorizontalWallDeivation
							| PhysicsCategory.HorizontalSpikedWall
							| PhysicsCategory.VerticalWall
							| PhysicsCategory.VerticalWallDeivation
							| PhysicsCategory.VerticalSpikedWall
							| PhysicsCategory.Goal
							| PhysicsCategory.MirrorGoal
							| PhysicsCategory.Modifier
		

		
		//TOP ROW
		verticalSpikeWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		verticalSpikeWallButton.name = "VerticalSpikeWallDesignButton"
		verticalSpikeWallButton.position = CGPoint(x: verticalDeivationWallButton.position.x, y: 450)
		verticalSpikeWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		verticalSpikeWallButton.zRotation = π / 2
		verticalSpikeWallButton.zPosition = GameLayer.ui.rawValue
		
		horizontalSpikeWallButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		horizontalSpikeWallButton.name = "HorizontalSpikeWallDesignButton"
		horizontalSpikeWallButton.position = CGPoint(x: verticalSpikeWallButton.position.x + designButtonToolboxBuffer, y: 450)
		horizontalSpikeWallButton.size = CGSize(width: wallSize.width * 0.7, height: wallSize.height)
		horizontalSpikeWallButton.zPosition = GameLayer.ui.rawValue
		
		playerDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		playerDesignButton.name = "PlayerDesignButton"
		playerDesignButton.position = CGPoint(x: horizontalSpikeWallButton.position.x + designButtonToolboxBuffer, y: 450)
		playerDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		playerDesignButton.zPosition = GameLayer.ui.rawValue
		
		mirrorPlayerDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		mirrorPlayerDesignButton.name = "MirrorPlayerDesignButton"
		mirrorPlayerDesignButton.position = CGPoint(x: playerDesignButton.position.x + designButtonToolboxBuffer, y: 450)
		mirrorPlayerDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		mirrorPlayerDesignButton.zPosition = GameLayer.ui.rawValue
		
		enemyDesignButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		enemyDesignButton.name = "EnemyDesignButton"
		enemyDesignButton.position = CGPoint(x: mirrorPlayerDesignButton.position.x + designButtonToolboxBuffer, y: 450)
		enemyDesignButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		enemyDesignButton.zPosition = GameLayer.ui.rawValue
		
		enemyLeftRightButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		enemyLeftRightButton.name = "EnemyLeftRightDesignButton"
		enemyLeftRightButton.position = CGPoint(x: enemyDesignButton.position.x + designButtonToolboxBuffer, y: 450)
		enemyLeftRightButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		enemyLeftRightButton.zPosition = GameLayer.ui.rawValue
		
		enemyUpDownButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		enemyUpDownButton.name = "EnemyUpDownDesignButton"
		enemyUpDownButton.position = CGPoint(x: enemyLeftRightButton.position.x + designButtonToolboxBuffer, y: 450)
		enemyUpDownButton.size = CGSize(width: tileSize.width * 0.7, height: tileSize.height * 0.7)
		enemyUpDownButton.zPosition = GameLayer.ui.rawValue

		
//		designLevelButton.anchorPoint = CGPoint(x: 0.5, y: 0)
//		designLevelButton.name = "Design"
//		designLevelButton.position = CGPoint(x: quitButton.position.x, y: quitButton.position.y - designLevelButton.size.height - 50)
//		designLevelButton.zPosition = GameLayer.UIText.rawValue
//		
		designMenuToolboxBox.name = "ToolBoxBackground"
		uiDesignNode.addChild(designMenuToolboxBox)
		designMenuToolboxBox.addChild(verticalWallButton)
		designMenuToolboxBox.addChild(horizontalWallButton)
		designMenuToolboxBox.addChild(verticalDeivationWallButton)
		designMenuToolboxBox.addChild(horizontalDeivationWallButton)
		designMenuToolboxBox.addChild(oppositerDesignButton)
		designMenuToolboxBox.addChild(doubleMoverDesignButton)
		designMenuToolboxBox.addChild(holderDesignButton)
		designMenuToolboxBox.addChild(goalDesignButton)
		designMenuToolboxBox.addChild(mirrorGoalDesignButton)
		playingBoardNode.addChild(cancelDesignObjectButton)
		designMenuToolboxBox.addChild(verticalSpikeWallButton)
		designMenuToolboxBox.addChild(horizontalSpikeWallButton)
		designMenuToolboxBox.addChild(playerDesignButton)
		designMenuToolboxBox.addChild(mirrorPlayerDesignButton)
		designMenuToolboxBox.addChild(enemyDesignButton)
		designMenuToolboxBox.addChild(enemyLeftRightButton)
		designMenuToolboxBox.addChild(enemyUpDownButton)
	}
	
	func fadeInDesignToolbox() {
		let fadeInAction = SKAction.fadeIn(withDuration: pauseScreenFadeInOutDuration)
		uiDesignNode.run(fadeInAction)
	}

	func fadeOutDesignToolBox() {
		let fadeOutAction = SKAction.fadeOut(withDuration: pauseScreenFadeInOutDuration)
		uiDesignNode.run(fadeOutAction)
	}
	
	
	func setupBlackTryAgainScreen(_ playerContactPosition: CGPoint) {
		
		let blackDeathScreen = SKSpriteNode(imageNamed: "blackDeathScreen")
		blackDeathScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		blackDeathScreen.size = CGSize(width: 100000, height: 75000)
		blackDeathScreen.position = CGPoint(x: playerContactPosition.x + player.body!.size.width * 0.3, y: playerContactPosition.y)
		blackDeathScreen.zPosition = 100
		blackDeathScreen.alpha = 1
		mainLevelNode.addChild(blackDeathScreen)
		let resizeAction = SKAction.resize(toWidth: 7000, height: 5250, duration: 1.5)
		resizeAction.timingMode = .easeOut
		blackDeathScreen.run(resizeAction)

	}
	
	func 	displayGameOverScreen() {
		pauseButton.removeFromParent()
		
		let fromTopAction = SKAction.moveTo(y: playableRect.size.height / 2 + 200, duration: 1)
		fromTopAction.timingMode = .easeOut
		
		if gameOverScreen.parent == uiGameOverNode {
			return
		} else {
			uiGameOverNode.addChild(gameOverScreen)
		}
		
		gameOverScreen.run(fromTopAction)
		
	}
	
	func setupGameOverScreen() {
		gameOverScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		gameOverScreen.name = "GameOver"
		gameOverScreen.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height + gameOverScreen.size.height)
		
		gameOverScreen.zPosition = GameLayer.uiText.rawValue
	}
	
	
	func fadeInOutLevelDescription() {
		let levelDescriptionFadeInAction = SKAction.fadeIn(withDuration: levelDescriptionFadeInDuration)
		let levelDescriptionFadeOutAction = SKAction.fadeOut(withDuration: levelDescriptionFadeOutDuration)
		let waitTime = SKAction.wait(forDuration: levelDescriptionDisplayedDuration)
		
		let levelDescriptionFadeSequence = SKAction.sequence([SKAction.wait(forDuration: 0.1), levelDescriptionFadeInAction, waitTime,levelDescriptionFadeOutAction])
		
		levelDescriptionNode.run(levelDescriptionFadeSequence)
	}
	
	func fadeInPauseButton() {
		let pauseButtonSetToAlpha = SKAction.fadeAlpha(to: 0, duration: 0)
		let pauseButtonFadeIn = SKAction.fadeIn(withDuration: pauseButtonFromStartFadeInDuration)
		let waitTimeBeforeFadeIn = SKAction.wait(forDuration: pauseButtonWaitToAppear)
		
		pauseButton.run(SKAction.sequence([pauseButtonSetToAlpha, waitTimeBeforeFadeIn, pauseButtonFadeIn]))
		
	}
	
	func fadeOutPauseButton() {
		let pauseButtonFadeOut = SKAction.fadeOut(withDuration: pauseButtonFadeInOutDuration)
		pauseButton.run(pauseButtonFadeOut)
	}
	
	func fadeInResumeFromPauseButton() {
		let pauseButtonFadeIn = SKAction.fadeIn(withDuration: pauseButtonFadeInOutDuration)
		pauseButton.run(pauseButtonFadeIn)
	}
	
	func setupLevelDescription() {
		
		
//		let uiBackgroundBox = SKShapeNode(rect: CGRect(x: 0, y: playableRect.size.height + 90, width: playableRect.size.width, height: 125))
//		uiBackgroundBox.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0, alpha: 0.4)
//		uiBackgroundBox.zPosition = GameLayer.UI.rawValue
//		levelDescriptionNode.addChild(uiBackgroundBox)
		
		
		
		let levelTitle = SKLabelNode(fontNamed: "Arial Bold")
		levelTitle.text = currentLevelTitle
		if currentLevelNumber! > 10 {
			levelTitle.fontColor = SKColor.darkGray
		} else {
			levelTitle.fontColor = SKColor.white
		}
//		levelTitle.fontSize = 164
//		levelTitle.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height / 2)

		levelTitle.fontSize = 70
		levelTitle.position = CGPoint(x: playableRect.size.width / 2, y: buttonCenteredPosition)
		levelTitle.zPosition = GameLayer.uiText.rawValue
		levelDescriptionNode.addChild(levelTitle)
	}
	
	func setupReadyGoText() {

		readyText.text = "Ready"
		readyText.fontColor = SKColor.blue
		readyText.fontSize = 350
		readyText.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height / 2 + 150)
		readyText.zPosition = GameLayer.uiText.rawValue
		readyText.run(SetAlphaTo0)
		uiPlayNode.addChild(readyText)
		
		goText.text = "Go!"
		goText.fontColor = SKColor.blue
		goText.fontSize = 350
		goText.position = CGPoint(x: playableRect.size.width / 2, y: playableRect.size.height / 2 + 150)
		goText.zPosition = GameLayer.uiText.rawValue
		goText.run(SetAlphaTo0)
		uiPlayNode.addChild(goText)
		
		readyText.run(SKAction.sequence([
			SKAction.fadeAlpha(to: 1, duration: 0.25),
			SKAction.wait(forDuration: 0.5),
			SKAction.fadeAlpha(to: 0, duration: 0.5)]))
		
		goText.run(SKAction.sequence([
			SKAction.wait(forDuration: 1.25),
			SKAction.fadeAlpha(to: 1, duration: 0.5),
			SKAction.wait(forDuration: 0.5),
			SKAction.fadeAlpha(to: 0, duration: 0.25),
			SKAction.run(goText.removeFromParent),
			SKAction.run(readyText.removeFromParent),
			SKAction.run(switchToPlay)]))
	}
	
	func setupPauseButton() {
		pauseButton.name = "Pause"
		pauseButton.anchorPoint = CGPoint(x: 0.5, y: 0)
		pauseButton.size = pauseButtonSize
		//		pauseButton.position = CGPoint(x: playableRect.size.width / 2, y: buttonCenteredPosition)
		pauseButton.position = CGPoint(x: playableRect.size.width - pauseButton.size.width - 60, y: buttonCenteredPosition - 30)
		
		pauseButton.zPosition = GameLayer.uiText.rawValue
		uiPlayNode.addChild(pauseButton)
	}
	

	
	func setupBorders() {
		
		//		let rightGridBordersArea = rightPlayableArea
		let path = CGMutablePath()
		path.move(to: CGPoint(x: matrixGridLeftReferencePoints["A1"]!.x - borderMargin, y: matrixGridLeftReferencePoints["A1"]!.y + borderMargin))
		path.addLine(to: CGPoint(x: matrixGridLeftReferencePoints["E1"]!.x + 20, y: matrixGridLeftReferencePoints["E1"]!.y + borderMargin))
		path.addLine(to: CGPoint(x: matrixGridLeftReferencePoints["E5"]!.x + 20, y: matrixGridLeftReferencePoints["E5"]!.y - borderMargin))
		path.addLine(to: CGPoint(x: matrixGridLeftReferencePoints["A5"]!.x - borderMargin, y: matrixGridLeftReferencePoints["A5"]!.y - borderMargin))
		path.addLine(to: CGPoint(x: matrixGridLeftReferencePoints["A1"]!.x - borderMargin, y: matrixGridLeftReferencePoints["A1"]!.y + borderMargin))

		leftOutOfBoundsBorder.path = path
		leftOutOfBoundsBorder.strokeColor = SKColor.clear
		leftOutOfBoundsBorder.lineWidth = 10.0
		leftOutOfBoundsBorder.zPosition = GameLayer.debug.rawValue
		playingBoardNode.addChild(leftOutOfBoundsBorder)
		
		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: matrixGridRightReferencePoints["A1"]!.x - 20, y: matrixGridRightReferencePoints["A1"]!.y + borderMargin))
		path2.addLine(to: CGPoint(x: matrixGridRightReferencePoints["E1"]!.x + borderMargin, y: matrixGridRightReferencePoints["E1"]!.y + borderMargin))
		path2.addLine(to: CGPoint(x: matrixGridRightReferencePoints["E5"]!.x + borderMargin, y: matrixGridRightReferencePoints["E5"]!.y - borderMargin))
		path2.addLine(to: CGPoint(x: matrixGridRightReferencePoints["A5"]!.x - 20, y: matrixGridRightReferencePoints["A5"]!.y - borderMargin))
		path2.addLine(to: CGPoint(x: matrixGridRightReferencePoints["A1"]!.x - 20, y: matrixGridRightReferencePoints["A1"]!.y + borderMargin))
		rightOutOfBoundsBorder.path = path2
		rightOutOfBoundsBorder.strokeColor = SKColor.clear
		rightOutOfBoundsBorder.lineWidth = 10.0
		rightOutOfBoundsBorder.zPosition = GameLayer.debug.rawValue
		playingBoardNode.addChild(rightOutOfBoundsBorder)
		
		leftOutOfBoundsBorder.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
		leftOutOfBoundsBorder.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
		leftOutOfBoundsBorder.physicsBody?.collisionBitMask = PhysicsCategory.None
		leftOutOfBoundsBorder.physicsBody?.contactTestBitMask = PhysicsCategory.Player
		
		rightOutOfBoundsBorder.physicsBody = SKPhysicsBody(edgeLoopFrom: path2)
		rightOutOfBoundsBorder.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
		rightOutOfBoundsBorder.physicsBody?.collisionBitMask = PhysicsCategory.None
		rightOutOfBoundsBorder.physicsBody?.contactTestBitMask = PhysicsCategory.Player
		
	}
	
	func setupTileGroupHighlightLine(_ startPosition: CGPoint, endPosition: CGPoint) {
		let path = CGMutablePath()
		path.move(to: startPosition)
		path.addLine(to: endPosition)
		
		tileGroupSelectedBorder.path = path
		tileGroupSelectedBorder.strokeColor = SKColor.green
		tileGroupSelectedBorder.lineWidth = 20
		tileGroupSelectedBorder.zPosition = GameLayer.obstacle.rawValue
		playingBoardNode.addChild(tileGroupSelectedBorder)
	}
	
	//MARK: PLAYER SETUP
	
	func setupPlayer(_ position: String) {
		
		player = PlayerObject(playerType: Grid.player, bodySize: tileSize, position: matrixGridLeft[position]!)
		player.name = "Player"

		playingBoardNode.addChild(player)
		gameObjectArray.append(player)
		if !gameObjectArray.isEmpty {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}
	}

	func setupMirrorPlayer(_ position: String) {
		
		mirrorPlayer = PlayerObject(playerType: Grid.mirror, bodySize: tileSize, position: matrixGridRight[position]!)
		mirrorPlayer.name = "mirrorPlayer"
		
		playingBoardNode.addChild(mirrorPlayer)
		gameObjectArray.append(mirrorPlayer)
		if !gameObjectArray.isEmpty {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}
	}
	
	func createWall(_ position: CGPoint, wallAxisType: WallAxisType, wallBounceType: WallBounceType) {
		let wall = Wall(wallAxisType: wallAxisType, wallBounceType: wallBounceType, bodySize: wallSize, position: position)
		playingBoardNode.addChild(wall)
		gameObjectArray.append(wall)
		if !gameObjectArray.isEmpty {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}

	}
	
	
	func createDodgeBall(_ startSide: MovingWallStartSide, atStartPosition position: String) {
		
//		let dodgeBall = DodgeBall(texture: SKTexture(imageNamed: "dodgeBall"), color: UIColor.clearColor(), size: ballObjectSize)
//		if startSide == .Left {
//			dodgeBall.position = CGPoint(x: movingTileOffScreenLeftPositionX, y: matrixGridLeftReferencePoints[position]!.y)
//			playingBoardNode.addChild(dodgeBall)
//			
//			dodgeBall.moveWallForever(startSide)
//		}
//		if startSide == .Right {
//			dodgeBall.position = CGPoint(x: movingTileOffScreenRightPositionX, y: matrixGridLeftReferencePoints[position]!.y)
//			playingBoardNode.addChild(dodgeBall)
//			dodgeBall.moveWallForever(startSide)
//		}
//		if startSide == .Top {
//			dodgeBall.position = CGPoint(x: matrixGridLeftReferencePoints[position]!.x, y: movingTileOffScreenTopPositionY )
//			playingBoardNode.addChild(dodgeBall)
//			dodgeBall.moveWallForever(startSide)
//		}
//		if startSide == .Bottom {
//			dodgeBall.position = CGPoint(x: matrixGridLeftReferencePoints[position]!.x, y: movingTileOffScreenBottomPositionY)
//			playingBoardNode.addChild(dodgeBall)
//			dodgeBall.moveWallForever(startSide)
//		}

	}
	
	
	func createWall(_ startSide: MovingWallStartSide, atStartPosition position: String) {
		
		//HorizontalWall
//		if startSide == MovingWallStartSide.Left || startSide == MovingWallStartSide.Right {
//			let wall = Wall(texture: SKTexture(imageNamed: "metal-spike-block.png"), color: UIColor.clearColor(), size: wallSize)
//			if startSide == .Left {
//				wall.position = CGPoint(x: movingTileOffScreenLeftPositionX, y: matrixGridLeftReferencePoints[position]!.y)
//				playingBoardNode.addChild(wall)
//				
//				wall.moveWallForever(startSide)
//			} else {
//				wall.position = CGPoint(x: movingTileOffScreenRightPositionX, y: matrixGridLeftReferencePoints[position]!.y)
//				playingBoardNode.addChild(wall)
//				wall.moveWallForever(startSide)
//			}
//		}
//		
//		//VerticalWall
//		if startSide == MovingWallStartSide.Top || startSide == MovingWallStartSide.Bottom {
//			let wall = Wall(texture: SKTexture(imageNamed: "metal-spike-block.png"), color: UIColor.clearColor(), size: CGSize(width: tileSide * 0.2, height: tileSide))
//			if startSide == .Top {
//				wall.position = CGPoint(x: matrixGridLeftReferencePoints[position]!.x, y: movingTileOffScreenTopPositionY)
//				playingBoardNode.addChild(wall)
//				
//				wall.moveWallForever(startSide)
//			} else {
//				wall.position = CGPoint(x: matrixGridLeftReferencePoints[position]!.x, y: movingTileOffScreenBottomPositionY)
//				playingBoardNode.addChild(wall)
//				wall.moveWallForever(startSide)
//			}
//		}
	}

	func setupBadGuy(onGrid grid: Grid, atPosition position: String) {

		let badGuy = GhostEnemy()
		
		badGuy.name = "BadGuy"
		badGuy.zPosition = GameLayer.player.rawValue
		badGuy.ghostBody.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSide * 0.9, height: tileSide * 0.9), center: CGPoint(x: 0.5, y: 0.5))
		badGuy.ghostBody.physicsBody!.categoryBitMask = PhysicsCategory.Player
		badGuy.ghostBody.physicsBody!.contactTestBitMask = PhysicsCategory.Player
		badGuy.ghostBody.physicsBody!.collisionBitMask =
			PhysicsCategory.VerticalWall
			| PhysicsCategory.VerticalWallDeivation
			| PhysicsCategory.HorizontalWall
			| PhysicsCategory.HorizontalWallDeivation
			| PhysicsCategory.VerticalSpikedWall
			| PhysicsCategory.HorizontalSpikedWall
		
		if grid == .player {
			badGuy.position = matrixGridLeft[position]!

		} else {
			badGuy.position = matrixGridRight[position]!

		}
		
		run(SKAction.repeatForever(
			SKAction.sequence([
				SKAction.run({badGuy.eyesLook("Up")}),
				SKAction.wait(forDuration: 1),
				SKAction.run({badGuy.eyesLook("Right")}),
				SKAction.wait(forDuration: 1),
				SKAction.run({badGuy.eyesLook("Down")}),
				SKAction.wait(forDuration: 1),
				SKAction.run({badGuy.eyesLook("Left")}),
				SKAction.wait(forDuration: 1),
			
			])))
		

		
//		playingBoardNode.addChild(badGuy)
	
	}
	
	func setupObstacle(_ modifierType: ModifierType, atPosition position: CGPoint) {
		
		let modifier = ModifierObject(modifierType: modifierType, at: position, size: modifierSize)

		playingBoardNode.addChild(modifier)
		gameObjectArray.append(modifier)
		if (!gameObjectArray.isEmpty) {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}
		
	}
	
	func setupObstacleFromDesign(_ modifierType: ModifierType, onGrid grid: Grid, atPosition position: CGPoint) {
		
		let modifier = ModifierObject(modifierType: modifierType, at: matrixGridLeft["I1"]!, size: tileSize)
		playingBoardNode.addChild(modifier)
		
	}
	
	func setupObstacle(_ wallType: WallBounceType, onGrid grid: Grid, wallStartPoint: String, wallEndPoint: String) {
		
		if grid == .player {
			let wall = WallPath(wallBounceType: wallType, wallPoints: [matrixGridLeftReferencePoints[wallStartPoint]!, matrixGridLeftReferencePoints[wallEndPoint]!])
			playingBoardNode.addChild(wall)
		}
		if grid == .mirror {
			let wall = WallPath(wallBounceType: wallType, wallPoints: [matrixGridRightReferencePoints[wallStartPoint]!, matrixGridRightReferencePoints[wallEndPoint]!])
			playingBoardNode.addChild(wall)
		}

	}
	
	func setupEnemy(atPosition position: CGPoint, onGrid grid: Grid, withStartDelay startDelay: TimeInterval, inDirection direction: MovementDirection) {
		
		let theEnemy = TinyEnemy(bodySize: tileSize, onGrid: grid, withStartDelay: startDelay, inDirection: direction)
		theEnemy.body!.position = position
		theEnemy.name = "Enemy"
		playingBoardNode.addChild(theEnemy)
		gameObjectArray.append(theEnemy)
		if (!gameObjectArray.isEmpty) {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}
	}
	
	func setupEnemy(atPosition position: CGPoint, startLeft: Bool, grid: Grid) {
		
		let theEnemy = TinyEnemy(bodySize: tileSize, idle: true, startLeft: startLeft, grid: grid)
		theEnemy.body!.position = position
		playingBoardNode.addChild(theEnemy)
		gameObjectArray.append(theEnemy)
		if (!gameObjectArray.isEmpty) {
			NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
		}
	}
	

	
	
	
	//MARK: PLAYING BOARD SETUP
	
	func setupBackground(withImageNamed imageName: String?) {
		
		if imageName != nil {
			let tempBackground = SKSpriteNode(imageNamed: imageName!)
			tempBackground.anchorPoint = CGPoint(x: 0, y: 0)
			tempBackground.position = CGPoint(x: 0, y: 0)
			tempBackground.zPosition = GameLayer.background.rawValue
			backgroundNode.addChild(tempBackground)
		} else {
			let tempBackground = SKSpriteNode(imageNamed: "image1")
			tempBackground.anchorPoint = CGPoint(x: 0, y: 0)
			tempBackground.position = CGPoint(x: 0, y: 0)
			tempBackground.zPosition = GameLayer.background.rawValue
			backgroundNode.addChild(tempBackground)
		}
	}
	
	
	
	func firstSetupLeftGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = gridStartPosition - newRowOffset
			var gridNumberSequence = 0
			
			for gridLetter in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = TileObject(grid: .player)
				newTile.theTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.theTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.zPosition = GameLayer.playingBoard.rawValue
				newTile.name = "YellowTileBlock"
				playingBoardNode.addChild(newTile)
				newTile.physicsBody = SKPhysicsBody(rectangleOf: newTile.theTile.size)
				newTile.physicsBody!.categoryBitMask = PhysicsCategory.BackGroundTile
				newTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Goal | PhysicsCategory.MirrorGoal
				newTile.physicsBody!.collisionBitMask = PhysicsCategory.None
				gridNumberSequence += 1
				
				matrixGridLeft[String(gridLetter) + String(row)] = newTile.position
			}
		}
		
		playingBoardNode.enumerateChildNodes(withName: "YellowTileBlock", using: {node, stop in
			node.run(SKAction.repeatForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
		
	}
	
	func setupLeftGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = gridStartPosition - newRowOffset
			var gridNumberSequence = 0
			
			for _ in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = TileObject(grid: .player)
				newTile.theTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.theTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.zPosition = GameLayer.playingBoard.rawValue
				newTile.name = "YellowTileBlock"
				playingBoardNode.addChild(newTile)
				newTile.physicsBody = SKPhysicsBody(rectangleOf: newTile.theTile.size)
				newTile.physicsBody!.categoryBitMask = PhysicsCategory.BackGroundTile
				newTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Goal | PhysicsCategory.MirrorGoal
				newTile.physicsBody!.collisionBitMask = PhysicsCategory.None
				gridNumberSequence += 1
			}
		}
		
		playingBoardNode.enumerateChildNodes(withName: "YellowTileBlock", using: {node, stop in
			node.run(SKAction.repeatForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
	}

	
	func firstSetupRightGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width + firstTileBufferWidth * 9, y: gridStartPosition.y) - newRowOffset
			var gridNumberSequence = 0
			
			for gridLetter in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = TileObject(grid: .mirror)
				newTile.theTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.theTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.zPosition = GameLayer.playingBoard.rawValue
				newTile.name = "SilverTileBlock"
				playingBoardNode.addChild(newTile)
				newTile.physicsBody = SKPhysicsBody(rectangleOf: newTile.theTile.size)
				newTile.physicsBody!.categoryBitMask = PhysicsCategory.BackGroundTile
				newTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Goal | PhysicsCategory.MirrorGoal
				newTile.physicsBody!.collisionBitMask = PhysicsCategory.None
				gridNumberSequence += 1
				
				theTiles.append(newTile)
//				if matrixGridRight.count == 0 {
					matrixGridRight[String(gridLetter) + String(row)] = newTile.position
//				}
			}
		}
		playingBoardNode.enumerateChildNodes(withName: "SilverTileBlock", using: {node, stop in
			node.run(SKAction.repeatForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
	}
	
	func setupRightGrid() {
		let gridSquareLetters = "HIJK"
		for row in 1...numberOfRowsInGrid {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat((row - 1)))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width + firstTileBufferWidth * 9, y: gridStartPosition.y) - newRowOffset
			var gridNumberSequence = 0
			
			for _ in gridSquareLetters.characters {
				let newTilePosition = rowStartPosition + CGPoint(x: tileBufferWidth, y: 0) + CGPoint(x: (tileSide + tileBufferWidth) * CGFloat((gridNumberSequence)) , y: 0)
				let newTile = TileObject(grid: .mirror)
				newTile.theTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
				newTile.theTile.size = CGSize(width: tileSide, height: tileSide)
				newTile.position = newTilePosition
				newTile.zPosition = GameLayer.playingBoard.rawValue
				newTile.name = "SilverTileBlock"
				playingBoardNode.addChild(newTile)
				newTile.physicsBody = SKPhysicsBody(rectangleOf: newTile.theTile.size)
				newTile.physicsBody!.categoryBitMask = PhysicsCategory.BackGroundTile
				newTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Goal | PhysicsCategory.MirrorGoal
				newTile.physicsBody!.collisionBitMask = PhysicsCategory.None
				gridNumberSequence += 1
				
				theTiles.append(newTile)
			}
		}
		playingBoardNode.enumerateChildNodes(withName: "SilverTileBlock", using: {node, stop in
			node.run(SKAction.repeatForever(SKAction.sequence([
				self.scaleUp, self.scaleDown
				])))})
	}
	
	func setupGoal(_ tilePosition: CGPoint?) {
		
		if tilePosition == nil {
			
		} else {
			
			
			let goalTile = SKSpriteNode(imageNamed: "goalTile")
			goalTile.name = "Goal"
			goalTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			goalTile.size = CGSize(width: tileSide, height: tileSide)
			goalTile.physicsBody = SKPhysicsBody(rectangleOf: goalTile.size)
			goalTile.physicsBody!.categoryBitMask = PhysicsCategory.Goal
			goalTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.BackGroundTile
			goalTile.physicsBody!.collisionBitMask = PhysicsCategory.None
			if let thePosition = tilePosition {
				goalTile.position = thePosition
			}
			goalTile.zPosition = GameLayer.goal.rawValue
			playingBoardNode.addChild(goalTile)
			
			goalTiles?.append(goalTile)
			gameObjectArray.append(goalTile)
			if (!gameObjectArray.isEmpty) {
				NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
			}
		
			
//			let newCoreDataObject = NSEntityDescription.insertNewObjectForEntityForName("LevelGoal", inManagedObjectContext: moc!) as! LevelGoal
//			newCoreDataObject.xPosition = matrixGridLeft["I1"]!.x
//			newCoreDataObject.yPosition = matrixGridLeft["I1"]!.y
//			newCoreDataObject.theGoalsLevel = currentLevelData!
//			currentLevelData!.theGoal?.setByAddingObject(newCoreDataObject)
//			
//			do {
//				try moc?.save()
//				
//			} catch {
//				let nserror = error as NSError
//				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//				abort()
//				
//			}
	
		}
	}
	
	func setupMirrorGoal(_ tilePosition: CGPoint?) {
		
		if tilePosition == nil {
			
		} else {
			
			
			let goalTile = SKSpriteNode(imageNamed: "goalTile")
			goalTile.name = "Goal"
			goalTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			goalTile.size = CGSize(width: tileSide, height: tileSide)
			goalTile.physicsBody = SKPhysicsBody(rectangleOf: goalTile.size)
			goalTile.physicsBody!.categoryBitMask = PhysicsCategory.Goal
			goalTile.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.BackGroundTile
			goalTile.physicsBody!.collisionBitMask = PhysicsCategory.None
			if let thePosition = tilePosition {
				goalTile.position = thePosition
			}
			goalTile.zPosition = GameLayer.goal.rawValue
			playingBoardNode.addChild(goalTile)
			
			goalTiles?.append(goalTile)
			gameObjectArray.append(goalTile)
			if (!gameObjectArray.isEmpty) {
				NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
			}
		}
	}
	
	//MARK: MOVEMENT HIGHLIGHT
	
	func setupSquareHighlight() {
		
	}
	
	
	//MARK: REFERENCE POINTS SETUP
	
	func setupLeftGridReferencePoints() {
		let gridLetters = "ABCDE"
		for gridRowNumber in 0...numberOfRowsInGrid + 1 {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(gridRowNumber - 1))
			let rowStartPosition = referencePointsStartPosition - newRowOffset
			var gridColumnSequence = 0
			for _ in gridLetters.characters {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: referencePointsStartPosition.x + (newPositionOffset.x * CGFloat(gridColumnSequence)), y: 0)
				gridColumnSequence += 1
				
				let verticalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				verticalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				verticalReferenceMarker.size = CGSize(width: 60, height: 100)
				verticalReferenceMarker.position = CGPoint(x: verticalWallPosition.x, y: verticalWallPosition.y - (tileSide / 1.5))

				playingBoardNode.addChild(verticalReferenceMarker)
				
				verticalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: verticalReferenceMarker.size)
				verticalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.VerticalReferencePoint
				verticalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.VerticalWall | PhysicsCategory.VerticalWallDeivation
				verticalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				
				
				let horizontalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				horizontalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				horizontalReferenceMarker.size = CGSize(width: 100, height: 60)
				horizontalReferenceMarker.position = CGPoint(x: verticalWallPosition.x - (tileSide * 0.80), y: verticalWallPosition.y)

				playingBoardNode.addChild(horizontalReferenceMarker)
				
				
				horizontalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: horizontalReferenceMarker.size)
				horizontalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.HorizontalReferencePoint
				horizontalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.HorizontalWall | PhysicsCategory.HorizontalWallDeivation
				horizontalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				
				
				let cornerReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				cornerReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				cornerReferenceMarker.size = CGSize(width: 25, height: 25)
				cornerReferenceMarker.position = verticalWallPosition
				playingBoardNode.addChild(cornerReferenceMarker)
				
				cornerReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: cornerReferenceMarker.size)
				cornerReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.CornerReferencePoint
				cornerReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.None
				cornerReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
			}
		}



	}
	
	func setupRightGridReferencePoints() {
		let gridLetters = "ABCDE"
		for gridRowNumber in 0...numberOfRowsInGrid + 1 {
			let newRowOffset = CGPoint(x: 0, y: (tileSide + tileBufferHeight) * CGFloat(gridRowNumber - 1))
			let rowStartPosition = CGPoint(x: leftPlayableArea.width, y: 0) + referencePointsStartPosition - newRowOffset
			var gridColumnSequence = 0
			for _ in gridLetters.characters {
				let newPositionOffset = CGPoint(x: tileSide + tileBufferWidth, y: 0)
				let verticalWallPosition = rowStartPosition + CGPoint(x: referencePointsStartPosition.x + (newPositionOffset.x * CGFloat(gridColumnSequence)), y: 0)
				gridColumnSequence += 1
				
				let verticalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				verticalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				verticalReferenceMarker.size = CGSize(width: 60, height: 100)
				verticalReferenceMarker.position = CGPoint(x: verticalWallPosition.x, y: verticalWallPosition.y - (tileSide / 1.5))

				playingBoardNode.addChild(verticalReferenceMarker)
				
				verticalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: verticalReferenceMarker.size)
				verticalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.VerticalReferencePoint
				verticalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.VerticalWall | PhysicsCategory.VerticalWallDeivation
				verticalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				let horizontalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				horizontalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				horizontalReferenceMarker.size = CGSize(width: 100, height: 60)
				horizontalReferenceMarker.position = CGPoint(x: verticalWallPosition.x + (tileSide * 0.80), y: verticalWallPosition.y)

				playingBoardNode.addChild(horizontalReferenceMarker)
				
				horizontalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: horizontalReferenceMarker.size)
				horizontalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.HorizontalReferencePoint
				horizontalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.HorizontalWall | PhysicsCategory.HorizontalWallDeivation
				horizontalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				let cornerReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				cornerReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				cornerReferenceMarker.size = CGSize(width: 25, height: 25)
				cornerReferenceMarker.position = verticalWallPosition
				playingBoardNode.addChild(cornerReferenceMarker)
				
				cornerReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: cornerReferenceMarker.size)
				cornerReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.CornerReferencePoint
				cornerReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.None
				cornerReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None

			}
		}
		
	}
	
	func firstSetupLeftGridReferencePoints() {
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
				
				let verticalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				verticalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				verticalReferenceMarker.size = CGSize(width: 60, height: 100)
				verticalReferenceMarker.position = CGPoint(x: verticalWallPosition.x, y: verticalWallPosition.y - (tileSide / 1.5))
				matrixGridLeftVertReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = verticalReferenceMarker.position
				
				playingBoardNode.addChild(verticalReferenceMarker)
				
				verticalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: verticalReferenceMarker.size)
				verticalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.VerticalReferencePoint
				verticalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.VerticalWall | PhysicsCategory.VerticalWallDeivation
				verticalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				
				
				let horizontalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				horizontalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				horizontalReferenceMarker.size = CGSize(width: 100, height: 60)
				horizontalReferenceMarker.position = CGPoint(x: verticalWallPosition.x - (tileSide * 0.80), y: verticalWallPosition.y)
				matrixGridLeftHorzReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = horizontalReferenceMarker.position
				
				playingBoardNode.addChild(horizontalReferenceMarker)
				
				
				horizontalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: horizontalReferenceMarker.size)
				horizontalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.HorizontalReferencePoint
				horizontalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.HorizontalWall | PhysicsCategory.HorizontalWallDeivation
				horizontalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				
				
				let cornerReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				cornerReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				cornerReferenceMarker.size = CGSize(width: 25, height: 25)
				cornerReferenceMarker.position = verticalWallPosition
				playingBoardNode.addChild(cornerReferenceMarker)
				
				cornerReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: cornerReferenceMarker.size)
				cornerReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.CornerReferencePoint
				cornerReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.None
				cornerReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
			}
		}
		
		
		
	}
	
	func firstSetupRightGridReferencePoints() {
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
				
				let verticalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				verticalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				verticalReferenceMarker.size = CGSize(width: 60, height: 100)
				verticalReferenceMarker.position = CGPoint(x: verticalWallPosition.x, y: verticalWallPosition.y - (tileSide / 1.5))
				matrixGridRightVertReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = verticalReferenceMarker.position
				
				playingBoardNode.addChild(verticalReferenceMarker)
				
				verticalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: verticalReferenceMarker.size)
				verticalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.VerticalReferencePoint
				verticalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.VerticalWall | PhysicsCategory.VerticalWallDeivation
				verticalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				let horizontalReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				horizontalReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				horizontalReferenceMarker.size = CGSize(width: 100, height: 60)
				horizontalReferenceMarker.position = CGPoint(x: verticalWallPosition.x + (tileSide * 0.80), y: verticalWallPosition.y)
				matrixGridRightHorzReferencePoints[String(gridColumnLetter) + String(gridRowNumber)] = horizontalReferenceMarker.position
				
				playingBoardNode.addChild(horizontalReferenceMarker)
				
				horizontalReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: horizontalReferenceMarker.size)
				horizontalReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.HorizontalReferencePoint
				horizontalReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.HorizontalWall | PhysicsCategory.HorizontalWallDeivation
				horizontalReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
				let cornerReferenceMarker = SKSpriteNode(imageNamed: "StandardYellowBlock")
				cornerReferenceMarker.run(SKAction.fadeAlpha(to: 0, duration: 0))
				cornerReferenceMarker.size = CGSize(width: 25, height: 25)
				cornerReferenceMarker.position = verticalWallPosition
				playingBoardNode.addChild(cornerReferenceMarker)
				
				cornerReferenceMarker.physicsBody = SKPhysicsBody.init(rectangleOf: cornerReferenceMarker.size)
				cornerReferenceMarker.physicsBody!.categoryBitMask = PhysicsCategory.CornerReferencePoint
				cornerReferenceMarker.physicsBody!.contactTestBitMask = PhysicsCategory.None
				cornerReferenceMarker.physicsBody!.collisionBitMask = PhysicsCategory.None
				
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
	
	func playerDissapear(withWait waitTime: TimeInterval) {
		player.removeAllActions()
		let dissapearRotateAngle = CGFloat(720).degreesToRadians()
		let playerDissapearSpin = SKAction.rotate(byAngle: dissapearRotateAngle, duration: 0.5)
		let playerDissapearShrink = SKAction.scale(to: 0, duration: 0.5)
		let dissapearSequence = SKAction.group([
			playerDissapearSpin,
			playerDissapearShrink
			])
		player.run(SKAction.sequence([
			SKAction.wait(forDuration: waitTime),
			dissapearSequence
			]))
		
	}
	
	func mirrorPlayerDissapear(withWait waitTime: TimeInterval) {
		mirrorPlayer.removeAllActions()
		let dissapearRotateAngle = CGFloat(720).degreesToRadians()
		let playerDissapearSpin = SKAction.rotate(byAngle: dissapearRotateAngle, duration: 0.5)
		let playerDissapearShrink = SKAction.scale(to: 0, duration: 0.5)
		let dissapearSequence = SKAction.group([
			playerDissapearSpin,
			playerDissapearShrink
			])
		mirrorPlayer.run(SKAction.sequence([
			SKAction.wait(forDuration: waitTime),
			dissapearSequence
			]))
	}

	
	//MARK: GAME ACTIONS
	

	
	func startNewLevel(_ level: Int) {
		
		mainLevelNodeReset()
		currentLevelNumber = currentLevelNumber! + 1
		if !nextSceneIsWinScene {
			unlockNextLevel()
			loadLevel(theLevel: currentLevelNumber)
			setupNextLevel()
		} else {
			let scene = FinalWinScene(size: gameSize)
			let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
			scene.scaleMode = .aspectFill

			view!.presentScene(scene, transition: transition)
		}
	}
	
	func didRestartLevel(_ level: Int) {
		mainLevelNodeReset()
		loadLevel(theLevel: currentLevelNumber)
		setupNextLevel()
		
	}
	
	func didGoToLevelsScreen() {
		let transition = SKTransition.moveIn(with: .left, duration: 1)
		let scene = LevelsScene(size:(CGSize(width: 2048, height: 1536)))
		scene.scaleMode = .aspectFill
//		scene.moc = moc
		view!.presentScene(scene, transition: transition)
		
	}
	
	func didQuitToMainMenu() {
		let transition = SKTransition.moveIn(with: .right, duration: 1)
		let scene = MainMenuScene(size:(CGSize(width: 2048, height: 1536)))
		scene.scaleMode = .aspectFill
//		scene.moc = moc
		view!.presentScene(scene, transition: transition)
		
	}
	
	// MARK: GAME STATES
	
	func saveStars(_ numberOfStars: Int ) {
		if currentLevelNumber! > 0 {
			if numberOfStars > levelStars[currentLevelNumber! - 1] {
				levelStars[currentLevelNumber! - 1] = numberOfStars
			}
		}
			archiveStars()
	}
	
	func unlockNextLevel() {
		if currentLevelNumber! > 0 {
			
			if levelUnlockedBools[currentLevelNumber! - 1] == false {
				levelUnlockedBools[currentLevelNumber! - 1] = true
				archiveLockedLevels()
				justUnlockedThisLevel? = currentLevelNumber!
			}
		}
	}
	
	func switchToEndTurn() {
		if playerHitGoal && mirrorPlayerHitGoal {
			gameState = .completedLevel
			winLevel()
		}
	}
	
	func switchToPause() {
		fadeInPauseMenu()
		fadeOutPauseButton()
		fadeOutDesignToolBox()
		gameState = .pause

		enumerateChildNodes(withName: "EnemyMoving", using: {node, stop in
			let theMovingEnemy = node as! TinyEnemy
			if let action = theMovingEnemy.body!.action(forKey: "moving") {
				action.speed = 0
			}
		})
		
		pauseAudio()
		scoreTimer.stop()
		leftOutOfBoundsBorder.strokeColor = UIColor.clear
		rightOutOfBoundsBorder.strokeColor = UIColor.clear
		
		
	}
	
	func switchToTutorial() {
		gameState = .tutorial
		leftOutOfBoundsBorder.strokeColor = UIColor.clear
		rightOutOfBoundsBorder.strokeColor = UIColor.clear
		if !backgroundMusicPlayer.isPlaying {
			resumeAudio()
		}
		
	}
	
	func switchToPlay() {
		gameState = .play
		scoreTimer.start()
		fadeInOutLevelDescription()
		fadeOutPauseMenu()
		fadeInResumeFromPauseButton()
		resumeAudio()
		defineSwipes()
		leftOutOfBoundsBorder.strokeColor = UIColor.clear
		rightOutOfBoundsBorder.strokeColor = UIColor.clear
		turnOnCollision()

				enumerateChildNodes(withName: "EnemyMoving", using: {node, stop in
					let theMovingEnemy = node as! TinyEnemy
					
					
					if let action = theMovingEnemy.body!.action(forKey: "moving") {
						action.speed = 1
					}
					
					theMovingEnemy.startMovement(theMovingEnemy.grid!)
				})
	}
	
	
	
	func switchToPlayerDeadShowContact(_ playerContactPosition: CGPoint) {
		gameState = .playerDeadShowContact

		playingBoardNode.enumerateChildNodes(withName: "Enemy", using: { node, stop in
			let enemy = node as! TinyEnemy
			enemy.body!.removeAllActions()
		})
		player.removeAllActions()
		mirrorPlayer.removeAllActions()
		setupBlackTryAgainScreen(playerContactPosition)
		playerDissapear(withWait: 2.0)
		mirrorPlayerDissapear(withWait: 2.0)
		switchToGameOver()
	}
	
	func switchToLevelPreStart() {
		gameState = GameState.levelPreStart
		scoreTimer.stop()
		scoreTimer.timerCount = 20000
		scoreTimer.updateLabel()
		setupReadyGoText()
		leftOutOfBoundsBorder.strokeColor = UIColor.clear
		rightOutOfBoundsBorder.strokeColor = UIColor.clear
		if !backgroundMusicPlayer.isPlaying {
			resumeAudio()
		}

	}
	
	func switchToDesignMode() {
		gameState = GameState.levelDesign
		leftOutOfBoundsBorder.strokeColor = UIColor.red
		rightOutOfBoundsBorder.strokeColor = UIColor.red
		fadeOutPauseMenu()
		fadeInResumeFromPauseButton()
		fadeInDesignToolbox()
		removeSwipeRecognizers()
		turnOffPlayerCollision()

	}
	
	
	
	func switchToGameOver() {
		self.run(playerDeathSound)

		scoreTimer.stop()
		gameState = .gameOver
//		displayGameOverScreen()
		let waitForLoseScreen = SKAction.wait(forDuration: 3)
		run(SKAction.sequence([waitForLoseScreen, SKAction.run({self.didRestartLevel(self.currentLevelNumber!)})]))
	}
	
	func turnOffPlayerCollision() {
		player.physicsBody?.collisionBitMask = PhysicsCategory.None
		player.physicsBody?.contactTestBitMask = PhysicsCategory.None
		player.physicsBody?.categoryBitMask = PhysicsCategory.None
		mirrorPlayer.physicsBody?.collisionBitMask = PhysicsCategory.None
		mirrorPlayer.physicsBody?.contactTestBitMask = PhysicsCategory.None
		mirrorPlayer.physicsBody?.categoryBitMask = PhysicsCategory.None
//		enumerateChildNodes(withName: "Enemy", using: {node, stop in
//			let theEnemy = node as! TinyEnemy
//			theEnemy.body!.physicsBody?.collisionBitMask = PhysicsCategory.None
//			theEnemy.body!.physicsBody?.contactTestBitMask = PhysicsCategory.None
//			theEnemy.body!.physicsBody?.categoryBitMask = PhysicsCategory.None
//		})

	}
	
	func winLevel() {
		print("The number of swipes for this level was \(swipesMade)")
		turnOffPlayerCollision()
		scoreTimer.stop()
		
		let levelCompleteSequence = SKAction.sequence([
			SKAction.wait(forDuration: 0.2),
			SKAction.group([
				SKAction.run({self.mirrorPlayerDissapear(withWait: 0)}),
				SKAction.run({self.playerDissapear(withWait: 0)}),
				playerAtGoalSound,
				SKAction.run({(self.createGoalSpark(at: self.mirrorPlayer.position))}),
				SKAction.run({(self.createGoalSpark(at: self.player.position))})
				]),
			//					SKAction.runBlock(removeAllActions),
			SKAction.wait(forDuration: 1.5),
			SKAction.run(displaySuccessScreen),
			SKAction.wait(forDuration: waitTimeToLoadNextLevel),
			SKAction.run({self.startNewLevel(self.currentLevelNumber!)})
			])
		
		let defaults = UserDefaults.standard
		defaults.set(swipesMade, forKey: "Tutorial3-Swipes")
		defaults.set(Int(scoreTimer.timerCount), forKey: "Tutorial3-Score")
		run(levelCompleteSequence)
	}

	func turnOnCollision() {
		player.physicsBody?.categoryBitMask = PhysicsCategory.Player
		player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Goal | PhysicsCategory.BackGroundTile
		player.physicsBody?.collisionBitMask =
			PhysicsCategory.VerticalWall
			| PhysicsCategory.VerticalWallDeivation
			| PhysicsCategory.HorizontalWall
			| PhysicsCategory.HorizontalWallDeivation
			| PhysicsCategory.VerticalSpikedWall
			| PhysicsCategory.HorizontalSpikedWall
		mirrorPlayer.physicsBody?.categoryBitMask = PhysicsCategory.MirrorPlayer
		mirrorPlayer.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Goal | PhysicsCategory.BackGroundTile
		mirrorPlayer.physicsBody?.collisionBitMask =
			PhysicsCategory.VerticalWall
			| PhysicsCategory.VerticalWallDeivation
			| PhysicsCategory.HorizontalWall
			| PhysicsCategory.HorizontalWallDeivation
			| PhysicsCategory.VerticalSpikedWall
			| PhysicsCategory.HorizontalSpikedWall
//		enumerateChildNodesWithName("Wall", usingBlock: {node, stop in
//			let theWall = node as! Wall
//			theWall.physicsBody?.collisionBitMask = PhysicsCategory.None
//		})
	}
	
	
	func removeSwipeRecognizers() {
		view!.gestureRecognizers?.forEach(view!.removeGestureRecognizer)

	}
	
	// MARK: USER INPUT
	func defineSwipes() {
			let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(_:)))
			swipeRight.direction = .right
			view!.addGestureRecognizer(swipeRight)
			
			
			let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(_:)))
			swipeLeft.direction = .left
			view!.addGestureRecognizer(swipeLeft)
			
			
			let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(_:)))
			swipeUp.direction = .up
			view!.addGestureRecognizer(swipeUp)
			
			
			let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(_:)))
			swipeDown.direction = .down
			view!.addGestureRecognizer(swipeDown)
	}
	
	func swipedRight(_ sender:UISwipeGestureRecognizer){
		if gameState == GameState.play {
			checkMovementLogic("right")

		}
		
		
	}
	
	func swipedLeft(_ sender:UISwipeGestureRecognizer){
		if gameState == GameState.play {
			checkMovementLogic("left")

		}
	}
	
	func swipedUp(_ sender:UISwipeGestureRecognizer){
		if gameState == GameState.play {
			checkMovementLogic("up")

		}
	}
	
	func swipedDown(_ sender:UISwipeGestureRecognizer){
		if gameState == GameState.play {
			checkMovementLogic("down")

		}
	}
	
	func playerPositionBounceBack(_ oldPosition: CGPoint){
		if gameState == GameState.play {
			print("The Previous position is...\(playerPositionBeforeMove)")
			player.run(SKAction.move(to: oldPosition, duration: 0.1))
			
			print("Player Bounced Back.  new position is \(player.position)")
		}
	}
	
	func mirrorPositionBounceBack(_ oldPosition: CGPoint){
		if gameState == GameState.play {
			mirrorPlayer.run(SKAction.move(to: oldPosition, duration: 0.1))
			
		}
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
		if let touch = touches.first {
			sceneTouched(touch.location(in: self))
		}
		//				super.touchesBegan(touches, withEvent:event)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let touch = touches.first
		let touchLocation = touch!.location(in: self)
		let targetNodes = self.nodes(at: touchLocation)

		for targetNode in targetNodes {
				if targetNode.name == "PlayerBody"
				|| targetNode.name == "MirrorPlayerBody"
				|| targetNode.name == "VerticalWall"
				|| targetNode.name == "HorizontalWall"
				|| targetNode.name == "VerticalWallDeivation"
				|| targetNode.name == "HorizontalWallDeivation"
				|| targetNode.name == "VerticalSpikedWall"
				|| targetNode.name == "HorizontalSpikedWall"
				|| targetNode.name == "Oppositer"
				|| targetNode.name == "DoubleMover"
				|| targetNode.name == "Holder"

					{
						currentHeldSpriteNode? = targetNode.parent!
						break
					}

		}
		
		for targetNode in targetNodes {
			if targetNode.name == "Goal" || targetNode.name == "MirrorGoal" || targetNode.name == "EnemyBody"

			{
				currentHeldSpriteNode? = targetNode
				break
			}
			
		}
		
		
//		if currentHeldDesignObject == .Player {
//			player.position = touchLocation
//		} else if currentHeldDesignObject == .MirrorPlayer {
//			mirrorPlayer.position = touchLocation
//		} else
		if currentHeldDesignObject == .player
			|| currentHeldDesignObject == .mirrorPlayer
			|| currentHeldDesignObject == .verticalWall
			|| currentHeldDesignObject == .horizontalWall
			|| currentHeldDesignObject == .verticalWallDeivation
			|| currentHeldDesignObject == .horizontalWallDeivation
			|| currentHeldDesignObject == .verticalSpikedWall
			|| currentHeldDesignObject == .horizontalSpikedWall
			|| currentHeldDesignObject == .goal
			|| currentHeldDesignObject == .mirrorGoal
			|| currentHeldDesignObject == .enemy

		{
			currentHeldSpriteNode!.position = touchLocation
			
		} else if currentHeldDesignObject == .oppositer
			|| currentHeldDesignObject == .doubleMover
			|| currentHeldDesignObject == .holder

		{
			currentHeldSpriteNode!.position = touchLocation
		}
	}
	
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if gameState == GameState.levelDesign {
			
			print("current Held Design Object = \(currentHeldDesignObject)")
			
			if currentHeldDesignObject == .player
				|| currentHeldDesignObject == .mirrorPlayer {
					currentHeldSpriteNode!.position = designReleasePosition
					gameObjectArray[currentHeldSpriteNodeReferenceNumber!] = currentHeldSpriteNode!
			}
			
			if currentHeldDesignObject == .goal || currentHeldDesignObject == .mirrorGoal {
				if isTouchingTrash {
					print(gameObjectArray.count)
					gameObjectArray.remove(at: currentHeldSpriteNodeReferenceNumber!)
					currentHeldSpriteNode!.removeFromParent()
					isTouchingTrash = false
					print(gameObjectArray.count)
				} else {
					currentHeldSpriteNode?.position = designReleasePosition
				}
			}
			
			if currentHeldDesignObject == .enemy
			{
				if !isTouchingTrash {
					
					currentHeldSpriteNode?.position = designReleasePosition
					gameObjectArray[currentHeldSpriteNodeReferenceNumber!] = currentHeldSpriteNode!.parent!

				} else {
					gameObjectArray.remove(at: currentHeldSpriteNodeReferenceNumber!)
					currentHeldSpriteNode!.removeFromParent()
					isTouchingTrash = false
				}
				playingBoardNode.removeChildren(in: [tileGroupSelectedBorder])

			}


			
			if currentHeldDesignObject == .verticalWall
				|| currentHeldDesignObject == .horizontalWall
				|| currentHeldDesignObject == .verticalWallDeivation
				|| currentHeldDesignObject == .horizontalWallDeivation
				|| currentHeldDesignObject == .verticalSpikedWall
				|| currentHeldDesignObject == .horizontalSpikedWall
					{
						if !isTouchingTrash {

							currentHeldSpriteNode?.position = designReleasePosition
						} else {
							gameObjectArray.remove(at: currentHeldSpriteNodeReferenceNumber!)
							currentHeldSpriteNode!.removeFromParent()
							isTouchingTrash = false
						}
					}
			
			if currentHeldDesignObject == .oppositer || currentHeldDesignObject == .doubleMover || currentHeldDesignObject == .holder {
				
				if !isTouchingTrash {
					currentHeldSpriteNode?.position = designReleasePosition
					gameObjectArray[currentHeldSpriteNodeReferenceNumber!] = currentHeldSpriteNode!
				} else {
					gameObjectArray.remove(at: currentHeldSpriteNodeReferenceNumber!)
					currentHeldSpriteNode?.removeFromParent()
					isTouchingTrash = false
				}
			}
			
			currentHeldDesignObject = .none
			currentHeldSpriteNode = nil
			heldDesignNode = nil
			cancelDesignObjectButton.alpha = 0
			if (!gameObjectArray.isEmpty) {
				NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
			}

		}
		
		designMenuToolboxBox.alpha = 0.75
		


	}
	
	func checkGameObjectArray(_ targetNode: SKNode) -> SKNode? {
//		var theSKNode: SKNode?
		
		if (!gameObjectArray.isEmpty) {
			for obj in 0..<gameObjectArray.count {
				if targetNode == gameObjectArray[obj] {
					return gameObjectArray[obj]
				}
			}
		}
		return nil
	}
	
	func checkGameObjectArrayForInt(_ targetNode: SKNode) -> Int? {
		
		if (!gameObjectArray.isEmpty) {

			for obj in 0..<gameObjectArray.count {
				if targetNode == gameObjectArray[obj] {
					return obj
				}
			}
		}
		return nil
	}
	
	func sceneTouched(_ location: CGPoint) {
		//1
		let targetNodes = self.nodes(at: location)
		if tutorialBoxes.count != 0 {
			if tutorialBoxes.count == 5 {
				switch currentTutorialBox {
				case 0: presentNextTutorialBox(1)
					gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox1"), object: nil)
				case 1: presentNextTutorialBox(2)
					gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox2"), object: nil)
				case 2: presentNextTutorialBox(3)
					gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox3"), object: nil)
				case 3: presentNextTutorialBox(4)
					gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox4"), object: nil)
				default: presentNextTutorialBox(-1)
				}
			} else if tutorialBoxes.count == 4 {
				switch currentTutorialBox {
				case 0: presentNextTutorialBox(1)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox1"), object: nil)
				case 1: presentNextTutorialBox(2)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox2"), object: nil)
				case 2: presentNextTutorialBox(3)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox3"), object: nil)
				default: presentNextTutorialBox(-1)
				}
			} else if tutorialBoxes.count == 3 {
				switch currentTutorialBox {
				case 0: presentNextTutorialBox(1)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox1"), object: nil)
				case 1: presentNextTutorialBox(2)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox2"), object: nil)
				default: presentNextTutorialBox(-1)
				}
			} else if tutorialBoxes.count == 2 {
				switch currentTutorialBox {
				case 0: presentNextTutorialBox(1)
				gameLevelNotifier.post(name: Notification.Name(rawValue: "withTutorialBox1"), object: nil)
				default: presentNextTutorialBox(-1)
				}
			} else if tutorialBoxes.count == 1 {
				switch currentTutorialBox {
				default: presentNextTutorialBox(-1)
				}
			}
		}
	
		for targetNode in targetNodes {
			
			if gameState == GameState.levelPreStart {
//				uiPlayNode.removeChildren(in: [readyText, goText])
//				switchToPlay()
			}
			
			if gameState == .play {
				
				
				
			if targetNode.name == "Pause" {
				print("Touched Pause")
				switchToPause()
			}

			
			} else if gameState == .pause {
				
				if targetNode.name == "UnPause" {
					switchToPlay()
					
				}
					
				else if targetNode.name == "Restart" {
					didRestartLevel(currentLevelNumber!)
					
				}
					
				else if targetNode.name == "Levels" {
					didGoToLevelsScreen()
				}
					
				else if targetNode.name == "Quit" {
					didQuitToMainMenu()
				} else if targetNode.name == "Design" {
					switchToDesignMode()
				} else if targetNode.name == "Reset" {
					if !gameObjectArray.isEmpty {
						playingBoardNode.removeChildren(in: gameObjectArray)
						gameObjectArray.removeAll()
						NSKeyedArchiver.archiveRootObject(gameObjectArray, toFile: theFilePath!)
					}
					didRestartLevel(currentLevelNumber!)

				}

			
			} else if gameState == .levelDesign {

				

				// THE GAME OJBECT TOUCHED
				if targetNode.name == "Pause" {
					print("Touched Pause")
					switchToPause()
				}
				
				if targetNode.name == "PlayerBody" {
					run(popSound)
					currentHeldDesignObject = .player
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)
				}
				if targetNode.name == "MirrorPlayerBody" {
					run(popSound)
					currentHeldDesignObject = .mirrorPlayer
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)

				}
				if targetNode.name == "Goal" {
					run(popSound)
					currentHeldDesignObject = .goal
					currentHeldSpriteNode = checkGameObjectArray(targetNode)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode)
					cancelDesignObjectButton.alpha = 1
				}
				if targetNode.name == "MirrorGoal" {
					run(popSound)
					currentHeldDesignObject = .mirrorGoal
					currentHeldSpriteNode = checkGameObjectArray(targetNode)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode)
					cancelDesignObjectButton.alpha = 1
				}
				if targetNode.name == "VerticalWall" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .verticalWall
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)
					print("Wall Touched")
				}
				
				if targetNode.name == "HorizontalWall" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .horizontalWall
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)
					print("Wall Touched")

				}
				
				if targetNode.name == "VerticalWallDeivation" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .verticalWallDeivation
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)
					print("Wall Touched")
					
				}
				
				if targetNode.name == "HorizontalWallDeivation" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .horizontalWallDeivation
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)

					print("Wall Touched")
					
				}
				
				if targetNode.name == "VerticalSpiked" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .verticalSpikedWall
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)
					print("Wall Touched")
					
				}
				
				if targetNode.name == "HorizontalSpiked" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .horizontalSpikedWall
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)

					print("Wall Touched")
					
				}
				
				
				
				
				if targetNode.name == "Oppositer" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .oppositer
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)

				}
				
				if targetNode.name == "DoubleMover" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .doubleMover
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)


				}
				
				if targetNode.name == "Holder" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .holder
					currentHeldSpriteNode = checkGameObjectArray(targetNode.parent!)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode.parent!)

				}
				
				if targetNode.name == "Enemy" {
					run(popSound)
					designMenuToolboxBox.alpha = hideDesignBoxWhileHoldingValue
					cancelDesignObjectButton.alpha = 1
					currentHeldDesignObject = .enemy
					currentHeldSpriteNode = checkGameObjectArray(targetNode)
					currentHeldSpriteNodeReferenceNumber = checkGameObjectArrayForInt(targetNode)
				}
				
				
				
				
				
				// THE DESIGN BUTTONS
				if targetNode.name == "PlayerDesignButton" {
					run(popSound)
					setupPlayer("H1")
				}
				
				if targetNode.name == "MirrorPlayerDesignButton" {
					run(popSound)
					setupMirrorPlayer("H1")
				}
				
				if targetNode.name == "EnemyDesignButton" {
					run(popSound)
					setupEnemy(atPosition: CGPoint(x: targetNode.position.x, y: targetNode.position.y + 400), startLeft: false, grid: .player)
				}
				
				if targetNode.name == "EnemyLeftRightDesignButton" {
					run(popSound)
					setupEnemy(atPosition: matrixGridLeft["H1"]!, onGrid: .player, withStartDelay: 0, inDirection: .right)
				}
				
				if targetNode.name == "EnemyUpDownDesignButton" {
					run(popSound)
					setupEnemy(atPosition: matrixGridLeft["H1"]!, onGrid: .player, withStartDelay: 0, inDirection: .down)
				}
				
				if targetNode.name == "VerticalWallDesignButton" {
					run(popSound)
					createWall(CGPoint(x: targetNode.position.x, y: targetNode.position.y + 400), wallAxisType: WallAxisType.vertical, wallBounceType: .verticalWall)
				}
				if targetNode.name == "HorizontalWallDesignButton" {
					run(popSound)
					createWall(CGPoint(x: targetNode.position.x, y: targetNode.position.y + 400), wallAxisType: WallAxisType.horizontal, wallBounceType: .horizontalWall)
					numberofHorizontalWalls += 1
				}
				if targetNode.name == "VerticalDeivationWallDesignButton" {
					run(popSound)
					createWall(CGPoint(x: targetNode.position.x, y: targetNode.position.y + 400), wallAxisType: WallAxisType.vertical, wallBounceType: .verticalWallDeivation)
					numberOfVerticalWallDeivations += 1
				}
				if targetNode.name == "HorizontalDeivationWallDesignButton" {
					run(popSound)
					createWall(CGPoint(x: targetNode.position.x, y: targetNode.position.y + 400), wallAxisType: WallAxisType.horizontal, wallBounceType: .horizontalWallDeivation)
					numberofHorizontalWallDeivations += 1
				}
				if targetNode.name == "OppositerDesignButton" {
					run(popSound)
					setupObstacle(.oppositer, atPosition: matrixGridLeft["I1"]!)
				}
				if targetNode.name == "DoubleMoverDesignButton" {
					run(popSound)
					setupObstacle(.doubleMover, atPosition: matrixGridLeft["I1"]!)

				}
				if targetNode.name == "HolderDesignButton" {
					run(popSound)
					setupObstacle(.holder, atPosition: matrixGridLeft["I1"]!)
				}
				
				if targetNode.name == "GoalDesignButton" {
					run(popSound)
					setupGoal(matrixGridLeft["I1"]!)
		
				}
				
				
				if targetNode.name == "MirrorGoalDesignButton" {
					run(popSound)
					setupMirrorGoal(matrixGridRight["I1"]!)
				}

			}
			//3
		}
	}
	
	
	// MARK: MOVEMENT LOGIC
	
	func checkMovementLogic(_ swipeDirection: String) {
		
		if gameState == .play {
			swipesMade += 1
			checkHitModifier()
			
			if swipeDirection == "right" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.run(SKAction.sequence([
					movePlayerRight,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.run({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			if swipeDirection == "left" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.run(SKAction.sequence([
					movePlayerLeft,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.run({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			if swipeDirection == "up" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.run(SKAction.sequence([
					movePlayerUp,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.run({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})
					]))
			}
			
			if swipeDirection == "down" {
				playerPositionBeforeMove = player.position
				mirrorPositionBeforeMove = mirrorPlayer.position
				player.run(SKAction.sequence([
					movePlayerDown,
					playerMoveSound,
					mirrorWaitMove,
					SKAction.run({self.checkMirrorMovementLogic(swipeDirection, mirrorPositionBeforeMove: self.mirrorPositionBeforeMove, shouldLoop: false)})					]))
			}
			
		}
		
	}
	
	
	func checkMirrorOffGrid(_ swipeDirection: String, mirrorPositionBeforeMove position: CGPoint) {
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
	

	
	func checkMirrorMovementLogic(_ swipeDirection: String, mirrorPositionBeforeMove position: CGPoint, shouldLoop: Bool) {
		
		if doubleMoverOn {
			
			if swipeDirection == "right" {
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
		} else if oppositerOn {
			
			if swipeDirection == "right" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
			}
			
		} else if holderOn {
			
			if swipeDirection == "right" {
				
				
				switchToEndTurn()
					holderOn = false
				
			}
			
			
			if swipeDirection == "left" {
				
				
				switchToEndTurn()
					holderOn = false
				
				
			}
			
			
			if swipeDirection == "up" {
				
				
				switchToEndTurn()
					holderOn = false
				
				
			}
			
			
			if swipeDirection == "down" {
				
				
				switchToEndTurn()
					holderOn = false
				
				
			}
			
		} else {
			if swipeDirection == "right" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorRight,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
			}
			
			
			if swipeDirection == "left" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorLeft,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "up" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorUp,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
				}
				
			}
			
			
			if swipeDirection == "down" {
				
				
				if hitWall {
//					hitWall = false
				} else if hitDeivationWall {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
						]))
					hitDeivationWall = false
				} else {
					mirrorPlayer.run(SKAction.sequence([
						moveMirrorDown,
						mirrorMoveSound,
						SKAction.run(switchToEndTurn)
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
				if hitWall {
					
				} else {
				doubleMoverOn = false
				}
			}
			hitDoubleMover = false
		}
		hitWall = false
	}
	
	
	
	
	// MARK: PHYSICS
	
	func createGoalSpark(at position: CGPoint) {
		let goalEmitter = SKEmitterNode(fileNamed: "GoalSpark.sks")
		
		goalEmitter!.position = position
		goalEmitter!.name = "goalEmitter"
		goalEmitter!.zPosition = GameLayer.goal.rawValue
		playingBoardNode.addChild(goalEmitter!)
		
	}
	
	func createDoublerSpark(at position: CGPoint, withNode node: SKSpriteNode) {
		let emitter = SKEmitterNode(fileNamed: "ModifierParticles.sks")
		
		emitter!.position = position
		emitter!.name = "modifierEmitter"
		node.addChild(emitter!)
		emitter!.zPosition = GameLayer.modifierParticles.rawValue
		
	}
	
	func createModifierSpark(withNode node: SKSpriteNode) {
		
		if node == player {
			player.emitter.particleBirthRate = 1000
		}
		
		
	}
	
	func modifierColorCycler(_ node: SKNode) {
		
		let thePlayerObject = node as! PlayerObject
		
		let colorizeAction = SKAction.repeat(
			SKAction.sequence([
				SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.5, duration: 0.1),
				SKAction.colorize(with: SKColor.green, colorBlendFactor: 0.5, duration: 0.1),
				SKAction.colorize(with: SKColor.blue, colorBlendFactor: 0.5, duration: 0.1),
				
				]), count: 4
		)
		//				SKAction.colorizeWithColorBlendFactor(0.0, duration: 1.0),
		
		thePlayerObject.body!.run(SKAction.sequence([
			colorizeAction,
			SKAction.colorize(with: SKColor.clear, colorBlendFactor: 0, duration: 0)
			]),
		withKey: "colorizeAction")
		
	}
	
	func centerPlayerOnTile() {
	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if gameState == GameState.play {
			
			if collision == PhysicsCategory.Player | PhysicsCategory.Goal {
				playerHitGoal = false
				print("player off of goal")
			}
			
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Goal {
				mirrorPlayerHitGoal = false
				print("player off of goal")
			}
		}
		
		if gameState == GameState.levelDesign {
			
			
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Modifier {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalWall {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalWall {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalWallDeivation {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalWallDeivation {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalSpikedWall {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalSpikedWall {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Goal {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.MirrorGoal {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Enemy {
				isTouchingTrash = false
				print ("is touching trash is ... \(isTouchingTrash)")
			}
		}
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		let collision: UInt32 = contact.bodyA.categoryBitMask |
			contact.bodyB.categoryBitMask
		
		if gameState == GameState.play {
			
			if collision == PhysicsCategory.Player | PhysicsCategory.VerticalWall {
				hitWall = true
				print("Player Position Before move = \(playerPositionBeforeMove)")
				playerPositionBounceBack(playerPositionBeforeMove)
				print("Player Position Before move = \(playerPositionBeforeMove)")

			}
			
			if collision == PhysicsCategory.Player | PhysicsCategory.HorizontalWall {
				hitWall = true
				playerPositionBounceBack(playerPositionBeforeMove)
			}
			
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.VerticalWall {
				hitWall = true
				playerPositionBounceBack(playerPositionBeforeMove)
				mirrorPositionBounceBack(mirrorPositionBeforeMove)
			}
			
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.HorizontalWall {
				hitWall = true
				playerPositionBounceBack(playerPositionBeforeMove)
				mirrorPositionBounceBack(mirrorPositionBeforeMove)
			}
			
			if collision == PhysicsCategory.Player | PhysicsCategory.VerticalWallDeivation {
				hitDeivationWall = true
				
				playerPositionBounceBack(playerPositionBeforeMove)
				
				if contact.bodyB.node?.name == "VerticalWallDeivation" {
					print("Hit Wall is \(contact.bodyB.node?.parent)")
					
					let hitWall = contact.bodyB.node?.parent as! Wall
					hitWall.changeWallType(.verticalWall)
					
				} else if contact.bodyA.node?.name == "VerticalWallDeivation" {
					print("Hit Wall is \(contact.bodyA.node?.parent)")
					let hitWall = contact.bodyA.node?.parent as! Wall
					hitWall.changeWallType(.verticalWall)
				}
			} else if collision == PhysicsCategory.Player | PhysicsCategory.HorizontalWallDeivation {
				hitDeivationWall = true
				
				playerPositionBounceBack(playerPositionBeforeMove)
				
				if contact.bodyA.node?.name == "HorizontalWallDeivation" {
					let hitWall = contact.bodyA.node?.parent as! Wall
					hitWall.changeWallType(.horizontalWall)
					
				} else if contact.bodyB.node?.name == "HorizontalWallDeivation" {
					let hitWall = contact.bodyB.node?.parent as! Wall
					hitWall.changeWallType(.horizontalWall)
				}
			}

			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.VerticalSpikedWall {
				switchToPlayerDeadShowContact(mirrorPlayer.position)
			} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.HorizontalSpikedWall {
				switchToPlayerDeadShowContact(mirrorPlayer.position)

			}

			
			if collision == PhysicsCategory.Player | PhysicsCategory.Modifier {
				
				modifierColorCycler(player)
				modifierColorCycler(mirrorPlayer)
				playingBoardNode.run(powerUpSound)
				
				if contact.bodyA.node?.name == "Holder" || contact.bodyB.node?.name == "Holder" {
					hitHolder = true
					if contact.bodyA.node?.name == "Holder" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "Holder" {
						contact.bodyB.node?.removeFromParent()
					}
				}
				
				if contact.bodyA.node?.name == "DoubleMover" || contact.bodyB.node?.name == "DoubleMover" {
					hitDoubleMover = true
					if contact.bodyA.node?.name == "DoubleMover" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "DoubleMover" {
						contact.bodyB.node?.removeFromParent()
					}
				}
				
				if contact.bodyA.node?.name == "Oppositer" || contact.bodyB.node?.name == "Oppositer" {
					hitOppositer = true
					if contact.bodyA.node?.name == "Oppositer" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "Oppositer" {
						contact.bodyB.node?.removeFromParent()
					}
					
				}
			}
			
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Modifier {
				
				modifierColorCycler(player)
				modifierColorCycler(mirrorPlayer)
				playingBoardNode.run(powerUpSound)
				
				if contact.bodyA.node?.name == "Holder" || contact.bodyB.node?.name == "Holder" {
					hitHolder = true
					if contact.bodyA.node?.name == "Holder" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "Holder" {
						contact.bodyB.node?.removeFromParent()
					}
				}
				
				if contact.bodyA.node?.name == "DoubleMover" || contact.bodyB.node?.name == "DoubleMover" {
					hitDoubleMover = true
					if contact.bodyA.node?.name == "DoubleMover" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "DoubleMover" {
						contact.bodyB.node?.removeFromParent()
					}
				}
				
				if contact.bodyA.node?.name == "Oppositer" || contact.bodyB.node?.name == "Oppositer" {
					hitOppositer = true
					if contact.bodyA.node?.name == "Oppositer" {
						contact.bodyA.node?.removeFromParent()
					} else if contact.bodyB.node?.name == "Oppositer" {
						contact.bodyB.node?.removeFromParent()
					}
					
				}
			}
			
			if collision == PhysicsCategory.Player | PhysicsCategory.Obstacle {
				switchToPlayerDeadShowContact(player.position)
				
			} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Obstacle {
				switchToPlayerDeadShowContact(mirrorPlayer.position)
			}
			
			if collision == PhysicsCategory.Player | PhysicsCategory.Enemy {
				switchToPlayerDeadShowContact(player.position)
				
			} else if collision == PhysicsCategory.Player | PhysicsCategory.EnemyUpDown {
				switchToPlayerDeadShowContact(player.position)
				
			} else if collision == PhysicsCategory.Player | PhysicsCategory.EnemyLeftRight {
				switchToPlayerDeadShowContact(player.position)
			
			} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Enemy {
				switchToPlayerDeadShowContact(mirrorPlayer.position)
			
			} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.EnemyUpDown {
				switchToPlayerDeadShowContact(mirrorPlayer.position)
				
			} else if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.EnemyLeftRight {
				switchToPlayerDeadShowContact(mirrorPlayer.position)
			}
			
			
			//TODO: FIGURE OUT HOW TO NOT PASS LEVEL WHEN MIRROR IS ON GOAL, BUT ABOUT TO MOVE
			
			if collision == PhysicsCategory.Player | PhysicsCategory.Goal {
				if currentLevelNumber == firstLevelNumber {
					winLevel()
				}
				playerHitGoal = true
				
//				if mirrorPlayerHitGoal == true  {
//					winLevel()
//				}
			}

			
			
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.Goal {
				mirrorPlayerHitGoal = true
				
//				if playerHitGoal == true {
//					winLevel()
//				}
			}
		}
		
		if gameState == GameState.levelDesign {
		
//			if collision == PhysicsCategory
			
			
			//PLAYER DESIGN CONTACT TEST
			if collision == PhysicsCategory.Player | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					print(designReleasePosition)
				}
			}
			//MIRROR PLAYER DESIGN CONTACT TEST
			if collision == PhysicsCategory.MirrorPlayer | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					print(designReleasePosition)
					
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.Goal | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.MirrorGoal | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.VerticalWall | PhysicsCategory.VerticalReferencePoint {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.VerticalReferencePoint {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.VerticalReferencePoint {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.VerticalWallDeivation | PhysicsCategory.VerticalReferencePoint {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.VerticalReferencePoint {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.VerticalReferencePoint {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.HorizontalWall | PhysicsCategory.HorizontalReferencePoint {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.HorizontalReferencePoint {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.HorizontalReferencePoint {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.HorizontalWallDeivation | PhysicsCategory.HorizontalReferencePoint {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.HorizontalReferencePoint {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.HorizontalReferencePoint {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.Modifier | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.Enemy | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.EnemyLeftRight | PhysicsCategory.BackGroundTile {
				if contact.bodyA.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyA.node!.position
					
					if playingBoardNode.children.contains(tileGroupSelectedBorder) {
						playingBoardNode.removeChildren(in: [tileGroupSelectedBorder])
					}
					setupTileGroupHighlightLine(CGPoint(x: matrixGridLeftVertReferencePoints["A1"]!.x, y: contact.bodyA.node!.position.y), endPosition: CGPoint(x: matrixGridLeftVertReferencePoints["E1"]!.x, y: contact.bodyA.node!.position.y))
					
					
					
					print("Hit Reference Point")
					print(designReleasePosition)
				}
				if contact.bodyB.node!.physicsBody!.categoryBitMask == PhysicsCategory.BackGroundTile {
					designReleasePosition = contact.bodyB.node!.position
					
					if playingBoardNode.children.contains(tileGroupSelectedBorder) {
						playingBoardNode.removeChildren(in: [tileGroupSelectedBorder])
					}
					setupTileGroupHighlightLine(CGPoint(x: matrixGridLeftVertReferencePoints["A1"]!.x, y: contact.bodyA.node!.position.y), endPosition: CGPoint(x: matrixGridLeftVertReferencePoints["E1"]!.x, y: contact.bodyA.node!.position.y))
					
					print("Hit Reference Point")
					print(designReleasePosition)
				}
			}
			
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Modifier {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalWall {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalWall {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalWallDeivation {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalWallDeivation {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.VerticalSpikedWall {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.HorizontalSpikedWall {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Goal {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.MirrorGoal {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}
			if collision == PhysicsCategory.CancelButton | PhysicsCategory.Enemy {
				isTouchingTrash = true
				print ("is touching trash is ... \(isTouchingTrash)")
			}

			
		}
	}
	
	func mainLevelNodeReset() {
		pauseMenuBackgroundBox.removeAllChildren()
		designMenuToolboxBox.removeAllChildren()
		
		readyText.removeFromParent()
		goText.removeFromParent()
	
		playingBoardNode.removeAllChildren()
		levelDescriptionNode.removeAllChildren()
		uiNode.removeAllChildren()
		uiGameOverNode.removeAllChildren()
		uiPlayNode.removeAllChildren()
		uiTutorialNode.removeAllChildren()
		uiDesignNode.removeAllChildren()
		backgroundNode.removeAllChildren()
		mainLevelNode.removeAllChildren()
		removeAllActions()
		removeAllChildren()
		
		gameObjectArray.removeAll()
		heldDesignNode = nil
		designReleasePosition = CGPoint.zero
		
		tutorialBoxes.removeAll()
		currentTutorialBox = 0
		
		scoreTimer.stop()
		scoreTimer.timerCount = 20000
		scoreTimer.updateLabel()
		
		playerDead = false
		hitDeivationWall = false
		hitWall = false
		playerHitGoal = false
		mirrorPlayerHitGoal = false
		
		doubleMoverOn = false
		holderOn = false
		oppositerOn = false
		
		hitHolder = false
		hitDoubleMover = false
		hitOppositer = false
		
		isHoldingPlayer = false
		isHoldingMirrorPlayer = false
		isHoldingGoal = false
		isHoldingMirrorGoal = false
		isTouchingTrash = false

	}
	
	func setupNextLevel() {
		setupLeftGrid()
		setupRightGrid()
		setupLeftGridReferencePoints()
		setupRightGridReferencePoints()
		setupLevel()

	}
	
	
	func loadLevel(theLevel: Int?) {
		swipesMade = 1
		
		if theLevel == firstLevelNumber {
			
			gameObjectArrayName = "W1L1-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Filo:  On The Move...\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H2"
			mirrorPlayerGridStartPosition = "H2"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
//				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupGoal(matrixGridLeft["K4"]!)
//				setupMirrorGoal(matrixGridRight["J3"]!)
				print("Game Objects loaded from code")
			}
			
			gameState = .tutorial
			setupTutorialBox(withText: "Welcome to the world of Unison!")
			setupTutorialBox(withText: "Meet Filo!")
			setupTutorialBox(withText: "You can move him around his game board by swiping in any direction.")
			setupTutorialBox(withText: "Try moving Filo to the blue \"Goal Tile\"")
			presentNextTutorialBox(0)
		}
		
		if theLevel == 2 {
			
			gameObjectArrayName = "W1L2-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Follow The Leader...\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H2"
			mirrorPlayerGridStartPosition = "H2"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupGoal(matrixGridLeft["J3"]!)
				setupMirrorGoal(matrixGridRight["J3"]!)
				print("Game Objects loaded from code")
			}
			gameState = .tutorial
			setupTutorialBox(withText: "On the right, meet Boomsha!  Filo's buddy.")
			setupTutorialBox(withText: "Boomsha will mirror Filo's movements.")
			setupTutorialBox(withText: "Try to get Boomsha and Filo to their respective Goals.")
			presentNextTutorialBox(0)
		}
		
		if theLevel == 3 {
			gameObjectArrayName = "W1L3-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Take The Long Way\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "I1"
			mirrorPlayerGridStartPosition = "I1"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftHorzReferencePoints["C2"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				createWall(matrixGridLeftHorzReferencePoints["D3"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				createWall(matrixGridLeftHorzReferencePoints["C4"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				
				createWall(matrixGridLeftVertReferencePoints["B1"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["B2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["B3"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D1"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D3"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D4"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				
				
				setupGoal(matrixGridLeft["H1"]!)
				setupMirrorGoal(matrixGridRight["H1"]!)
				print("Game Objects loaded from code")
			}
			switchToLevelPreStart()

		}
		
		if theLevel == 4 {
			gameObjectArrayName = "W1L4-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"The Great Wall\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H3"
			mirrorPlayerGridStartPosition = "H3"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftVertReferencePoints["D1"]!, wallAxisType: .vertical, wallBounceType: .verticalWallDeivation)
				
				setupGoal(matrixGridLeft["I3"]!)
				setupMirrorGoal(matrixGridRight["J3"]!)
				print("Game Objects loaded from code")
				
			}
			gameState = .tutorial
			setupTutorialBox(withText: "Sometimes, Boomsha's Goal will be in a different location then Filo's Goal.")
			setupTutorialBox(withText: "Use Yellow \"Deivation Walls\" to move Boomsha without moving Filo...")
			setupTutorialBox(withText: "And get them to their Goals together.")

			presentNextTutorialBox(0)
			
		}

		if theLevel == 5 {
			gameObjectArrayName = "W1L5-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Don't Mind Me\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupEnemy(atPosition: matrixGridLeft["I2"]!, startLeft: false, grid: .player)
				setupEnemy(atPosition: matrixGridLeft["J3"]!, startLeft: true, grid: .player)
				
				setupEnemy(atPosition: matrixGridRight["H2"]!, startLeft: true, grid: .mirror)
				setupEnemy(atPosition: matrixGridRight["J2"]!, startLeft: false, grid: .mirror)
				
				setupGoal(matrixGridLeft["I3"]!)
				setupMirrorGoal(matrixGridRight["I3"]!)
			}
			switchToLevelPreStart()
		}

		if theLevel == 6 {
			gameObjectArrayName = "W1L6-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"To and Fro\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupEnemy(atPosition: matrixGridRight["I1"]!, onGrid: .mirror, withStartDelay: 0, inDirection: .down)
				setupEnemy(atPosition: matrixGridRight["J4"]!, onGrid: .mirror, withStartDelay: 0, inDirection: .up)
				
				
				
				setupGoal(matrixGridLeft["K4"]!)
				setupMirrorGoal(matrixGridRight["K4"]!)
			}
			switchToLevelPreStart()
		}

		if theLevel == 7 {
			gameObjectArrayName = "W1L7-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"One For Me, Two For You\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupObstacle(.doubleMover, atPosition: matrixGridLeft["J2"]!)
				
				
				setupGoal(matrixGridLeft["I3"]!)
				setupMirrorGoal(matrixGridRight["H4"]!)
			}
			
			gameState = .tutorial
			setupTutorialBox(withText: "Movement Modifiers like this \"2X\" will change the way Boomsha moves  in relation to Filo.")
			presentNextTutorialBox(0)

		}

		if theLevel == 8 {
			gameObjectArrayName = "W1L8-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Hold Please:\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupObstacle(.holder, atPosition: matrixGridLeft["I2"]!)
				
				
				setupGoal(matrixGridLeft["J3"]!)
				setupMirrorGoal(matrixGridRight["J2"]!)
			}
			gameState = .tutorial
			setupTutorialBox(withText: "This \"Holder\" Modifier will stop Boomsha for one swipe.")
			setupTutorialBox(withText: "Use it wisely to position Filo!")
			presentNextTutorialBox(0)
		}

		if theLevel == 9 {
			gameObjectArrayName = "W1L9-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Opposites Attract?\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "J4"
			mirrorPlayerGridStartPosition = "H1"
			
			
			//SETUP LEVEL
			
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupObstacle(.oppositer, atPosition: matrixGridLeft["K4"]!)
				
				
				setupGoal(matrixGridLeft["I2"]!)
				setupMirrorGoal(matrixGridRight["K3"]!)
			}
			gameState = .tutorial
			setupTutorialBox(withText: "This is an \"Oppositer\" Modifier.")
			setupTutorialBox(withText: "It will make Boomsha move in the opposite direction of Filo.")
			presentNextTutorialBox(0)
		}

		if theLevel == 12 {
			gameObjectArrayName = "W2L2-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Wait...Wait....Go!\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "I1"
			mirrorPlayerGridStartPosition = "I1"
			backgroundImage = "skyBackground"

			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftHorzReferencePoints["C3"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				createWall(matrixGridLeftHorzReferencePoints["D4"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				createWall(matrixGridLeftHorzReferencePoints["E4"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				
				createWall(matrixGridLeftVertReferencePoints["C3"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["E3"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				
				setupObstacle(.holder, atPosition: matrixGridLeft["K3"]!)
				
				setupEnemy(atPosition: matrixGridLeft["H1"]!, onGrid: .player, withStartDelay: 0, inDirection: .down)
				setupEnemy(atPosition: matrixGridRight["H3"]!, onGrid: .mirror, withStartDelay: 0, inDirection: .right)
				
				
				setupGoal(matrixGridLeft["J4"]!)
				setupMirrorGoal(matrixGridRight["K4"]!)
			}
			switchToLevelPreStart()
		}

		if theLevel == 11 {
			gameObjectArrayName = "W2L11-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Not Not Complicated.\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "I1"
			backgroundImage = "skyBackground"

			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupObstacle(.doubleMover, atPosition: matrixGridLeft["J1"]!)
				setupObstacle(.holder, atPosition: matrixGridLeft["J4"]!)
				setupObstacle(.oppositer, atPosition: matrixGridLeft["I1"]!)
				
				setupEnemy(atPosition: matrixGridRight["H2"]!, onGrid: .mirror, withStartDelay: 0, inDirection: .right)
				setupEnemy(atPosition: matrixGridRight["H3"]!, onGrid: .mirror, withStartDelay: 0.5, inDirection: .right)
				
				createWall(matrixGridLeftVertReferencePoints["B1"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["B2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["B3"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				
				
				setupGoal(matrixGridLeft["J2"]!)
				setupMirrorGoal(matrixGridRight["J3"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 10 {
			gameObjectArrayName = "W1L10-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Let Sleeping Monstors Lie\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H2"
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				createWall(matrixGridLeftVertReferencePoints["D3"]!, wallAxisType: .vertical, wallBounceType: .verticalWallDeivation)
				setupEnemy(atPosition: matrixGridLeft["K1"]!, startLeft: false, grid: .player)
				setupEnemy(atPosition: matrixGridRight["H4"]!, startLeft: true, grid: .mirror)
				setupEnemy(atPosition: matrixGridLeft["H3"]!, startLeft: false, grid: .player)
				
				setupGoal(matrixGridLeft["H2"]!)
				setupMirrorGoal(matrixGridRight["I3"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 13 {
			gameObjectArrayName = "W2L3-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Order Of Operations\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			backgroundImage = "skyBackground"
			
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				createWall(matrixGridLeftVertReferencePoints["B2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D3"]!, wallAxisType: .vertical, wallBounceType: .verticalWallDeivation)
				createWall(matrixGridLeftHorzReferencePoints["E3"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWallDeivation)
				
				setupGoal(matrixGridLeft["I3"]!)
				setupMirrorGoal(matrixGridRight["J2"]!)
			}
			switchToLevelPreStart()
		}

		if theLevel == 14 {
			gameObjectArrayName = "W2L4-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Monster Rush Hour\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			backgroundImage = "skyBackground"
			
			
			gameState = GameState.levelPreStart
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupEnemy(atPosition: matrixGridRight["K2"]!, onGrid: .mirror, withStartDelay: 0, inDirection: .left)
				setupEnemy(atPosition: matrixGridRight["K3"]!, onGrid: .mirror, withStartDelay: 0.5, inDirection: .left)
				setupEnemy(atPosition: matrixGridRight["K4"]!, onGrid: .mirror, withStartDelay: 0.75, inDirection: .left)
				
				setupEnemy(atPosition: matrixGridLeft["H2"]!, onGrid: .player, withStartDelay: 0, inDirection: .right)
				setupEnemy(atPosition: matrixGridLeft["H3"]!, onGrid: .player, withStartDelay: 0.75, inDirection: .right)
				setupEnemy(atPosition: matrixGridLeft["H4"]!, onGrid: .player, withStartDelay: 0, inDirection: .right)
				
				setupGoal(matrixGridLeft["J4"]!)
				setupMirrorGoal(matrixGridRight["J4"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 15 {
			gameObjectArrayName = "W2L5-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Remote Control\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "I2"
			mirrorPlayerGridStartPosition = "K2"
			backgroundImage = "skyBackground"
			
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftVertReferencePoints["B2"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWallDeivation)
				createWall(matrixGridLeftHorzReferencePoints["C2"]!, wallAxisType: WallAxisType.horizontal, wallBounceType: WallBounceType.horizontalWallDeivation)
				createWall(matrixGridLeftHorzReferencePoints["C3"]!, wallAxisType: WallAxisType.horizontal, wallBounceType: WallBounceType.horizontalWallDeivation)
				
				setupEnemy(atPosition: matrixGridLeft["H4"]!, onGrid: Grid.player, withStartDelay: 0, inDirection: MovementDirection.up)
				setupEnemy(atPosition: matrixGridRight["J1"]!, onGrid: Grid.mirror, withStartDelay: 0, inDirection: MovementDirection.down)
				
				setupGoal(matrixGridLeft["J3"]!)
				setupMirrorGoal(matrixGridRight["K4"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 16 {
			gameObjectArrayName = "W2L6-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"This, Then That\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H2"
			backgroundImage = "skyBackground"
			
			//		gameState = .Tutorial
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftVertReferencePoints["C2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				setupObstacle(.oppositer, atPosition: matrixGridLeft["J2"]!)
				setupObstacle(.doubleMover, atPosition: matrixGridLeft["I2"]!)
				setupObstacle(.holder, atPosition: matrixGridLeft["H3"]!)
				
				setupGoal(matrixGridLeft["K3"]!)
				setupMirrorGoal(matrixGridRight["J1"]!)
			}
			switchToLevelPreStart()
		}

		if theLevel == 17 {
			gameObjectArrayName = "W2L7-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Man In The Mirror\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "J4"
			backgroundImage = "skyBackground"
			
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupObstacle(.oppositer, atPosition: matrixGridLeft["I1"]!)
				createWall(matrixGridLeftHorzReferencePoints["E3"]!, wallAxisType: WallAxisType.horizontal, wallBounceType: WallBounceType.horizontalWallDeivation)
				
				setupGoal(matrixGridLeft["I4"]!)
				setupMirrorGoal(matrixGridRight["K2"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 18 {
			gameObjectArrayName = "W2L8-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Around The World\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "K4"
			mirrorPlayerGridStartPosition = "K4"
			backgroundImage = "skyBackground"
			
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftVertReferencePoints["C1"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				createWall(matrixGridLeftVertReferencePoints["C2"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				createWall(matrixGridLeftVertReferencePoints["C3"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				
				createWall(matrixGridLeftVertReferencePoints["D2"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D3"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				createWall(matrixGridLeftVertReferencePoints["D4"]!, wallAxisType: WallAxisType.vertical, wallBounceType: WallBounceType.verticalWall)
				setupObstacle(.oppositer, atPosition: matrixGridLeft["I3"]!)
				setupObstacle(.doubleMover, atPosition: matrixGridRight["I2"]!)
				
				setupGoal(matrixGridLeft["H3"]!)
				setupMirrorGoal(matrixGridRight["J4"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 19 {
			gameObjectArrayName = "W2L9-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Look Before You Leap\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "H1"
			mirrorPlayerGridStartPosition = "H1"
			backgroundImage = "skyBackground"
			
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				createWall(matrixGridLeftHorzReferencePoints["B3"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWall)
				createWall(matrixGridLeftHorzReferencePoints["C3"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWallDeivation)
				createWall(matrixGridLeftVertReferencePoints["C2"]!, wallAxisType: .vertical, wallBounceType: .verticalWall)
				createWall(matrixGridLeftHorzReferencePoints["E1"]!, wallAxisType: .horizontal, wallBounceType: .horizontalWallDeivation)
				
				createWall(matrixGridRightHorzReferencePoints["B3"]!, wallAxisType: .horizontal, wallBounceType: WallBounceType.horizontalSpikedWall)
				createWall(matrixGridRightHorzReferencePoints["C2"]!, wallAxisType: .horizontal, wallBounceType: WallBounceType.horizontalSpikedWall)
				createWall(matrixGridRightVertReferencePoints["B1"]!, wallAxisType: .vertical, wallBounceType: WallBounceType.verticalSpikedWall)
				
				setupObstacle(.oppositer, atPosition: matrixGridLeft["K1"]!)
				setupObstacle(.oppositer, atPosition: matrixGridRight["K2"]!)
				setupObstacle(.doubleMover, atPosition: matrixGridLeft["J3"]!)
				
				
				setupGoal(matrixGridLeft["I4"]!)
				setupMirrorGoal(matrixGridRight["H4"]!)
			}
			switchToLevelPreStart()

		}

		if theLevel == 20 {
			gameObjectArrayName = "W2L10-ObjectData"
			setupLevelDataArchive()
			currentLevelTitle = "\"Monster Right Of Way\""
			numberOfRowsInGrid = 4
			numberOfTilesPerRow = 4
			playerGridStartNumber = "K1"
			mirrorPlayerGridStartPosition = "K1"
			backgroundImage = "skyBackground"
			
			nextSceneIsWinScene = true
			
			
			//SETUP LEVEL
			if gameObjectArray.isEmpty {
				
				setupPlayer(playerGridStartNumber)
				setupMirrorPlayer(mirrorPlayerGridStartPosition)
				
				setupEnemy(atPosition: matrixGridLeft["I1"]!, onGrid: .player, withStartDelay: 0.25, inDirection: .down)
				setupEnemy(atPosition: matrixGridLeft["I1"]!, onGrid: .player, withStartDelay: 0.75, inDirection: .down)
				setupEnemy(atPosition: matrixGridLeft["I1"]!, onGrid: .player, withStartDelay: 1.25, inDirection: .down)
				
				setupEnemy(atPosition: matrixGridLeft["J1"]!, onGrid: .player, withStartDelay: 0, inDirection: .down)
				setupEnemy(atPosition: matrixGridLeft["J1"]!, onGrid: .player, withStartDelay: 0.5, inDirection: .down)
				setupEnemy(atPosition: matrixGridLeft["J1"]!, onGrid: .player, withStartDelay: 1.0, inDirection: .down)
				
				//		setupObstacle(ModifierType.Holder, onGrid: .Player, atPosition: "H1")
				setupObstacle(ModifierType.holder, atPosition: matrixGridLeft["I1"]!)
				setupObstacle(ModifierType.holder, atPosition: matrixGridLeft["J1"]!)
				setupObstacle(ModifierType.oppositer, atPosition: matrixGridLeft["I3"]!)
				
				setupObstacle(ModifierType.holder, atPosition: matrixGridLeft["I4"]!)
				
				setupGoal(matrixGridLeft["H4"]!)
				setupMirrorGoal(matrixGridRight["K2"]!)
			}
			switchToLevelPreStart()
		}


	}
	
}
