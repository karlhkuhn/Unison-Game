//
//  Player.swift
//  Unison
//
//  Created by Karl H Kuhn on 1/27/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import SpriteKit

class TinyEnemy: GameObject {
	
	
	var theStartDelay: TimeInterval = 0
	var currentMoveDirection: MovementDirection = .none
	var doesStartLeft = false
	var isIdle = true
	
	
	let wallMoveSpeedByDuration: TimeInterval = 2
	
	let moveObstacleUpLM: SKAction
	let moveObstacleDownLM: SKAction
	let moveObstacleLeftLM: SKAction
	let moveObstacleRightLM: SKAction
	let moveObstacleUpRM: SKAction
	let moveObstacleDownRM: SKAction
	let moveObstacleLeftRM: SKAction
	let moveObstacleRightRM: SKAction
	
	
	let moveDownForever: SKAction
	let moveUpForever: SKAction
	let moveRightForever: SKAction
	let moveLeftForever: SKAction
	

	
	override init() {
		
		moveDownForever = SKAction.move(by: CGVector(dx: 0, dy: -1400), duration: wallMoveSpeedByDuration)
		moveUpForever = SKAction.move(by: CGVector(dx: 0, dy: 1400), duration: wallMoveSpeedByDuration)
		moveRightForever = SKAction.move(by: CGVector(dx: 2700, dy: 0), duration: 3.5)
		moveLeftForever = SKAction.move(by: CGVector(dx: -2700, dy: 0), duration: wallMoveSpeedByDuration)
		
		moveObstacleUpLM = SKAction.moveTo(y: matrixGridLeft["H1"]!.y, duration: wallMoveSpeedByDuration)
		moveObstacleDownLM = SKAction.moveTo(y: matrixGridLeft["H4"]!.y, duration: wallMoveSpeedByDuration)
		moveObstacleLeftLM = SKAction.moveTo(x: matrixGridLeft["H1"]!.x, duration: wallMoveSpeedByDuration)
		moveObstacleRightLM = SKAction.moveTo(x: matrixGridLeft["K1"]!.x, duration: wallMoveSpeedByDuration)
		moveObstacleUpLM.timingMode = .easeInEaseOut
		moveObstacleDownLM.timingMode = .easeInEaseOut
		moveObstacleLeftLM.timingMode = .easeInEaseOut
		moveObstacleRightLM.timingMode = .easeInEaseOut
		moveObstacleUpRM = SKAction.moveTo(y: matrixGridRight["H1"]!.y, duration: wallMoveSpeedByDuration)
		moveObstacleDownRM = SKAction.moveTo(y: matrixGridRight["H4"]!.y, duration: wallMoveSpeedByDuration)
		moveObstacleLeftRM = SKAction.moveTo(x: matrixGridRight["H1"]!.x, duration: wallMoveSpeedByDuration)
		moveObstacleRightRM = SKAction.moveTo(x: matrixGridRight["K1"]!.x, duration: wallMoveSpeedByDuration)
		moveObstacleUpRM.timingMode = .easeInEaseOut
		moveObstacleDownRM.timingMode = .easeInEaseOut
		moveObstacleLeftRM.timingMode = .easeInEaseOut
		moveObstacleRightRM.timingMode = .easeInEaseOut

		super.init()
		
		body = SKSpriteNode(imageNamed: "monster02_idle")
		addChild(body!)
	}
	
	
	convenience init(bodySize: CGSize, onGrid grid: Grid, withStartDelay startDelay: TimeInterval, inDirection direction: MovementDirection) {
		self.init()
		self.bodySize = bodySize
		currentMoveDirection = direction
		createEnemy(bodySize)
		theStartDelay = startDelay
		name = "EnemyMoving"
		self.grid = grid

		if currentMoveDirection == MovementDirection.left || direction == MovementDirection.right {
			body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyLeftRight

		} else if currentMoveDirection == MovementDirection.up || direction == MovementDirection.down {
			body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyUpDown
		}
		
		startMovement(grid)
	}
	
	convenience init(bodySize: CGSize, idle: Bool, startLeft: Bool, grid: Grid) {
		self.init()
		self.bodySize = bodySize
		self.grid = grid
		isIdle = idle
		doesStartLeft = startLeft
		createEnemy(bodySize)
		name = "Enemy"
		body!.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
		lookAround(startLeft)

	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let positionDecoded = aDecoder.decodeCGPoint(forKey: "position")
		let sizeDecoded = aDecoder.decodeCGSize(forKey: "size")
		let doesStartLeftDecoded = aDecoder.decodeBool(forKey: "doesStartLeft")
		let movedirectionDecoded = aDecoder.decodeInteger(forKey: "movementDirection")
		let theStartDelayDecoded = aDecoder.decodeDouble(forKey: "theStartDelay")
		let gridDecoded = aDecoder.decodeInteger(forKey: "grid")
		
		
		self.init()
		
		bodySize = sizeDecoded
		self.body!.position = positionDecoded
		currentMoveDirection = MovementDirection(rawValue: Int(movedirectionDecoded))!
		theStartDelay = theStartDelayDecoded
		self.grid = Grid(rawValue: Int(gridDecoded))
		createEnemy(bodySize!)
		
		if currentMoveDirection != .none {
			name = "EnemyMoving"
			startMovement(grid!)
		} else {
			name = "Enemy"
			body!.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
			lookAround(doesStartLeftDecoded)
		}
	}
	
	override func encode(with coder: NSCoder) {
		coder.encode(self.body!.position, forKey: "position")
		coder.encode(self.bodySize!, forKey: "size")
		coder.encode(doesStartLeft, forKey: "doesStartLeft")
		coder.encode(isIdle, forKey: "isIdle")
		coder.encode(self.currentMoveDirection.rawValue, forKey: "movementDirection")
		coder.encode(self.theStartDelay, forKey: "theStartDelay")
		coder.encode(self.grid!.rawValue, forKey: "grid")
	}
	
	func createEnemy(_ bodySize: CGSize) {
		
		body!.name = "EnemyBody"
		body!.size = bodySize
		zPosition = GameLayer.obstacle.rawValue
		let physicsBodySizeOffset: CGFloat = 0.8
		let physicsBodySize = CGSize(width: bodySize.width * physicsBodySizeOffset, height: bodySize.height * physicsBodySizeOffset)
		body!.physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize, center: CGPoint(x: 0, y: 0))
		body!.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.MirrorPlayer | PhysicsCategory.BackGroundTile
		body!.physicsBody?.isDynamic = false
		body!.physicsBody?.collisionBitMask = PhysicsCategory.None
	}
	
	func startMovement(_ grid: Grid) {
		
		if grid == .player {
			if currentMoveDirection == MovementDirection.right {
				moveRightAndLeftLM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyLeftRight
			} else if currentMoveDirection == MovementDirection.left {
				moveLeftAndRightLM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyLeftRight
			} else if currentMoveDirection == MovementDirection.up {
				moveUpAndDownLM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyUpDown
			} else if currentMoveDirection == MovementDirection.down {
				moveDownAndUpLM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyUpDown
			}
		}
		else if grid == .mirror {
			if currentMoveDirection == MovementDirection.right {
				moveRightAndLeftRM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyLeftRight
			} else if currentMoveDirection == MovementDirection.left {
				moveLeftAndRightRM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyLeftRight
			} else if currentMoveDirection == MovementDirection.up {
				moveUpAndDownRM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyUpDown
			} else if currentMoveDirection == MovementDirection.down {
				moveDownAndUpRM()
				body!.physicsBody?.categoryBitMask = PhysicsCategory.EnemyUpDown
			}
		}
	}
	
	
	
	func stopMovement() {
		
	}
	
	func lookAround(_ startLeft: Bool){
		
		let loadBlinkImage = SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_blink"))
		let loadIdleLeftImage = SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left"))
		let loadIdleRightImage = SKAction.setTexture(SKTexture(imageNamed: "monster02_idle"))
		let eyesOpenWaitTime = SKAction.wait(forDuration: 1.5, withRange: 0.75)
		let blinkWaitTime = SKAction.wait(forDuration: 0.25)
		if startLeft {
			let idelSequence = SKAction.sequence([loadIdleLeftImage, eyesOpenWaitTime, loadBlinkImage, blinkWaitTime, loadIdleRightImage, eyesOpenWaitTime, loadBlinkImage, blinkWaitTime])
			let repeatIdelActionForever = SKAction.repeatForever(idelSequence)
			body!.run(repeatIdelActionForever)
			
		} else {
			let idelSequence = SKAction.sequence([loadIdleRightImage, eyesOpenWaitTime, loadBlinkImage, blinkWaitTime, loadIdleLeftImage, eyesOpenWaitTime, loadBlinkImage, blinkWaitTime])
			let repeatIdelActionForever = SKAction.repeatForever(idelSequence)
			body!.run(repeatIdelActionForever)
			
		}
	}
	

	
	func moveRightAndLeftLM() {
		
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleRightLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleLeftLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
			])
			])))
			]), withKey: "moving")
	}
	
	func moveLeftAndRightLM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleLeftLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleRightLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
			])
		])))]))
	}
	
	func moveRightAndLeftRM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleRightRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleLeftRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
			])
		])))]))
	}
	
	func moveLeftAndRightRM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleLeftRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleRightRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				])
			])))]))
	}
	
	
	func moveUpAndDownLM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleUpLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleDownLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				])
			])))]))
	}
	
	func moveDownAndUpLM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleDownLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleUpLM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				])
			])))]))
	}
	
	func moveUpAndDownRM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleUpRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleDownRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				])
			])))]))
	}
	
	func moveDownAndUpRM() {
		body!.run(SKAction.sequence([SKAction.wait(forDuration: theStartDelay), SKAction.repeatForever((SKAction.sequence([
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle_left")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleDownRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01_left"))
				]),
			SKAction.setTexture(SKTexture(imageNamed: "monster02_idle")),
			SKAction.wait(forDuration: enemyTurnAroundWaitTime),
			SKAction.group([
				moveObstacleUpRM,
				SKAction.setTexture(SKTexture(imageNamed: "monster02_walk_01"))
				])
			])))]))
	}

	
	
	
	
	func moveWallForever(_ startSide: MovingWallStartSide) {
		if startSide == .top {
			run(SKAction.sequence([
				moveDownForever,
				//				SKAction.moveByX(0, y: 1350, duration: 0),
				SKAction.run(removeFromParent)]))
		}
		if startSide == .bottom {
			run(SKAction.sequence([
				moveUpForever,
				//				SKAction.moveByX(0, y: -1350, duration: 0),
				SKAction.run(removeFromParent)]))
		}
		if startSide == .left {
			run(SKAction.sequence([
				moveRightForever,
				//				SKAction.moveByX(-2700, y: 0, duration: 0),
				SKAction.run(removeFromParent)]))
		}
		if startSide == .right {
			run(SKAction.sequence([
				moveLeftForever,
				//				SKAction.moveByX(2700, y: 0, duration: 0),
				SKAction.run(removeFromParent)]))
		}
	}
	
	
	func moveUpAndDown(onGrid grid: Grid, fromPosition startPosition: String, toPosition endPosition: String) {
		
		if grid == .player {
			run(SKAction.repeatForever(SKAction.sequence([
				SKAction.moveTo(y: matrixGridLeft[endPosition]!.y, duration: wallMoveSpeedByDuration),
				SKAction.moveTo(y: matrixGridLeft[startPosition]!.y, duration: wallMoveSpeedByDuration)
				])))
		} else {
			run(SKAction.repeatForever(SKAction.sequence([
				SKAction.moveTo(y: matrixGridRight[endPosition]!.y, duration: wallMoveSpeedByDuration),
				SKAction.moveTo(y: matrixGridRight[startPosition]!.y, duration: wallMoveSpeedByDuration)
				])))
		}
	}
	
	
	func moveLeftAndRight(onGrid grid: Grid, fromPosition startPosition: String, toPosition endPosition: String) {
		if grid == .player {
			run(SKAction.repeatForever(SKAction.sequence([
				SKAction.moveTo(x: matrixGridLeft[endPosition]!.y, duration: wallMoveSpeedByDuration),
				SKAction.moveTo(x: matrixGridLeft[startPosition]!.y, duration: wallMoveSpeedByDuration)
				])))
		} else {
			run(SKAction.repeatForever(SKAction.sequence([
				SKAction.moveTo(x: matrixGridRight[endPosition]!.y, duration: wallMoveSpeedByDuration),
				SKAction.moveTo(x: matrixGridRight[startPosition]!.y, duration: wallMoveSpeedByDuration)
				])))
		}
	}
	
	
	
	
	
	func moveWall(_ wallAxisType: WallAxisType, withWaitTime waitTime: TimeInterval) {
		if wallAxisType == .vertical {
			run(SKAction.sequence([
				SKAction.wait(forDuration: waitTime),
				SKAction.repeatForever(SKAction.sequence([
					moveObstacleDownLM, moveObstacleUpLM
					]))
				]))
		} else if wallAxisType == .horizontal {
			run(SKAction.sequence([
				SKAction.wait(forDuration: waitTime),
				SKAction.repeatForever(SKAction.sequence([
					moveObstacleRightLM, moveObstacleLeftLM
					]))
				]))
		}
	}
	
	
	
	//	func moveOnGrid(fromPosition startPosition: CGPoint, toPosition endPosition: CGPoint) {
	//
	//		var tinyEnemyMoveFirstTexture: SKTexture?
	//		var tinyEnemyIdleFirstTexture: SKTexture?
	//		var tinyEnemyMoveSecondTexture: SKTexture?
	//		var tinyEnemyIdleSecondTexture: SKTexture?
	//
	//		let theDifferenceInX = endPosition.x - startPosition.x
	//		let theDifferenceInY = endPosition.y - startPosition.y
	//
	//		let firstMoveAction = SKAction.moveTo(endPosition, duration: wallMoveSpeedByDuration)
	//		let secondMoveAction = SKAction.moveTo(startPosition, duration: wallMoveSpeedByDuration)
	//		firstMoveAction.timingMode = .EaseInEaseOut
	//		secondMoveAction.timingMode = .EaseInEaseOut
	//
	//
	//		if theDifferenceInY == 0 {
	//			if theDifferenceInX > 0 {
	//				tinyEnemyMoveFirstTexture = SKTexture(imageNamed: "monster02_walk_01")
	//				tinyEnemyIdleFirstTexture = SKTexture(imageNamed: "monster02_idle")
	//				tinyEnemyMoveSecondTexture = SKTexture(imageNamed: "monster02_walk_01_left")
	//				tinyEnemyIdleSecondTexture = SKTexture(imageNamed: "monster02_idle_left")
	//			} else if theDifferenceInX < 0 {
	//				tinyEnemyMoveFirstTexture = SKTexture(imageNamed: "monster02_walk_01_left")
	//				tinyEnemyIdleFirstTexture = SKTexture(imageNamed: "monster02_idle_left")
	//				tinyEnemyMoveSecondTexture = SKTexture(imageNamed: "monster02_walk_01")
	//				tinyEnemyIdleSecondTexture = SKTexture(imageNamed: "monster02_idle")
	//			}
	//		}
	//
	//		if theDifferenceInX == 0 {
	//			if theDifferenceInY > 0 {
	//				tinyEnemyMoveFirstTexture = SKTexture(imageNamed: "monster02_idle_up")
	//				tinyEnemyIdleFirstTexture = SKTexture(imageNamed: "monster02_idle_up")
	//				tinyEnemyMoveSecondTexture = SKTexture(imageNamed: "monster02_idle_down")
	//				tinyEnemyIdleSecondTexture = SKTexture(imageNamed: "monster02_idle_down")
	//			} else if theDifferenceInY < 0 {
	//				tinyEnemyMoveFirstTexture = SKTexture(imageNamed: "monster02_idle_down")
	//				tinyEnemyIdleFirstTexture = SKTexture(imageNamed: "monster02_idle_down")
	//				tinyEnemyMoveSecondTexture = SKTexture(imageNamed: "monster02_idle_up")
	//				tinyEnemyIdleSecondTexture = SKTexture(imageNamed: "monster02_idle_up")
	//			}
	//		}
	//
	//		body!.runAction(SKAction.sequence([SKAction.waitForDuration(theStartDelay), SKAction.repeatActionForever((SKAction.sequence([
	//			SKAction.setTexture(tinyEnemyIdleFirstTexture!),
	//			SKAction.waitForDuration(enemyTurnAroundWaitTime),
	//			SKAction.group([
	//				firstMoveAction,
	//				SKAction.setTexture(tinyEnemyMoveFirstTexture!)
	//				]),
	//			SKAction.setTexture(tinyEnemyIdleSecondTexture!),
	//			SKAction.waitForDuration(enemyTurnAroundWaitTime),
	//			SKAction.group([
	//				secondMoveAction,
	//				SKAction.setTexture(tinyEnemyMoveSecondTexture!)
	//				])
	//			])))]))
	//	}

	


}
