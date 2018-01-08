//
//  Categories.swift
//  Unison
//
//  Created by Karl H Kuhn on 2/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import SpriteKit

public let gameSize = CGSize(width: 2048, height: 1536)  


enum LevelType {
	case standard
	case tutorial
}

enum GameLayer: CGFloat {
	case background
	case playingBoard
	case goal
	case wall
	case dodgeBall
	case foreground
	case modifierOppositer
	case modifierDoubleMover
	case modifierHolder
	case modifierParticles
	case obstacle
	case fadedBackground
	case mirrorPlayer
	case player
	case ui
	case uiText
	case debug
}


enum GameState {
	case levelDesign
	case levelPreStart
	case pause
	case tutorial
	case play
	case completedLevel
	case playerDeadShowContact
	case gameOver
}

enum DesignObject {
	case none
	case player
	case mirrorPlayer
	case goal
	case mirrorGoal
	case verticalWall
	case horizontalWall
	case verticalWallDeivation
	case horizontalWallDeivation
	case verticalSpikedWall
	case horizontalSpikedWall
	case oppositer
	case doubleMover
	case holder
	case enemy
}

enum ModifierType: Int {
	case doubleMover
	case holder
	case oppositer
	case none
}

enum ModifierActive {
	case doubleMover
	case holder
	case oppositer
}

enum Grid: Int {
	case player
	case mirror
	case none
}

enum MovementDirection: Int {
	case right
	case left
	case up
	case down
	case none
}

enum MovementAxis {
	case horizontal
	case vertical
}

enum WallAxisType: Int {
	case vertical
	case horizontal
}

enum WallBounceType: Int {
	case verticalWall
	case horizontalWall
	case verticalWallDeivation
	case horizontalWallDeivation
	case verticalSpikedWall
	case horizontalSpikedWall
}

enum MovingWallStartSide {
	case left
	case right
	case top
	case bottom
}


struct PhysicsCategory {
	static let None: UInt32 =				0
	static let Player: UInt32 =				0b1
	static let Obstacle: UInt32 =				0b10
	static let Goal: UInt32 =				0b100
	static let MirrorGoal: UInt32 =			0b1000
	static let MirrorPlayer: UInt32 =			0b10000
	static let VerticalWall: UInt32 =			0b100000
	static let HorizontalWall: UInt32 =			0b1000000
	static let VerticalWallDeivation: UInt32 =	0b10000000
	static let HorizontalWallDeivation: UInt32 =	0b1000000000
	static let VerticalSpikedWall: UInt32 =		0b10000000000
	static let HorizontalSpikedWall: UInt32 =		0b100000000000
	static let Modifier: UInt32 =				0b1000000000000
	static let BackGroundTile: UInt32 =			0b10000000000000
	static let VerticalReferencePoint: UInt32 =	0b100000000000000
	static let HorizontalReferencePoint: UInt32 =	0b1000000000000000
	static let CornerReferencePoint: UInt32 =		0b10000000000000000
	static let DodgeBall: UInt32 =			0b100000000000000000
	static let CancelButton: UInt32 =			0b1000000000000000000
	static let Enemy: UInt32 =				0b10000000000000000000
	static let EnemyUpDown: UInt32 =			0b100000000000000000000
	static let EnemyLeftRight: UInt32 =			0b1000000000000000000000
}
