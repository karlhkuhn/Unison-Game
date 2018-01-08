//
//  GameValues.swift
//  Unison
//
//  Created by Karl H Kuhn on 5/24/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import SpriteKit


public let allLevelsUnlocked = false

public var firstLevelNumber: Int = 1

public let mirrorMoveWaitTime: TimeInterval = 0.09
public let playerMoveSpeedByDuration: TimeInterval = 0.1
public let mirrorMoveSpeedByDuration: TimeInterval = 0.2
public let mirrorBounceWaitTime: TimeInterval = 0.5
public let gameObjectsScaleUpToSize: CGFloat = 1.04
public let gameObjectsScaleDownToSize: CGFloat = 0.96
public let gameObjectsScaleDuration: TimeInterval = 0.6

public let successScreenAppearDuration: TimeInterval = 0.5
public let pauseScreenFadeInOutDuration: TimeInterval = 0.5

public let levelDescriptionFadeInDuration: TimeInterval = 0.5
public let levelDescriptionFadeOutDuration: TimeInterval = 0.5
public let levelDescriptionDisplayedDuration: TimeInterval = 6

public let pauseButtonWaitToAppear: TimeInterval = 3
public let pauseButtonFromStartFadeInDuration: TimeInterval = 1
public let pauseButtonFadeInOutDuration: TimeInterval = 0.5

public let borderMargin: CGFloat = 50

public let highlightsOnWaitTIme: TimeInterval = 0.7

public let gameTextLineBreakSpacer: CGFloat = 45
public let waitTimeToLoadNextLevel: TimeInterval = 4.25

public let bottomUIYPosition: CGFloat = 220
public let bottomUIOffScreenYPosition: CGFloat = -220

public let SetAlphaTo0 = SKAction.fadeAlpha(to: 0, duration: 0)

public let designButtonToolboxBuffer: CGFloat = 150
public let designButtonToolboxVerticalBuffer: CGFloat = 50
public let hideDesignBoxWhileHoldingValue: CGFloat = 0.15

public let enemyTurnAroundWaitTime: TimeInterval = 0.25





