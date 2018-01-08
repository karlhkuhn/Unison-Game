//
//  TheMatrix.swift
//  Unison
//
//  Created by Karl H Kuhn on 2/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import SpriteKit

public var matrixGrid = [String: CGPoint]()
public var matrixGridLeft = [String: CGPoint]()
public var matrixGridRight = [String: CGPoint]()
public var matrixGridLeftReferencePoints = [String: CGPoint]()
public var matrixGridRightReferencePoints = [String: CGPoint]()
public var matrixGridLeftHorzReferencePoints = [String: CGPoint]()
public var matrixGridLeftVertReferencePoints = [String: CGPoint]()
public var matrixGridRightHorzReferencePoints = [String: CGPoint]()
public var matrixGridRightVertReferencePoints = [String: CGPoint]()

public var matrixGridWorldLevels1 = [String: Int]()
public var matrixGridWorldLevels2 = [String: Int]()


public var levelStars = [Int]()
public var levelUnlockedBools = [Bool]()

public var scoreForKeyDictionary = [String: Int]()

public var swipesMade: Int = 0
public var levelStarCount = [Int: Int]()


public var levelsLockedFilePath:String {
	let manager = FileManager.default
	let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
	return url.appendingPathComponent("levelsLocked").path
}

public var levelStarsFilePath:String {
	let manager = FileManager.default
	let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
	return url.appendingPathComponent("levelStars").path
}

//func reloadLevelUnlockedBools() {
//	if let array = NSKeyedUnarchiver.unarchiveObject(withFile: levelsLockedFilePath) as? [AnyObject] {
//		levelUnlockedBools = array as! [Bool]
//		print(levelUnlockedBools)
//	}
//}

func unArchiveStars() {
	if let array = NSKeyedUnarchiver.unarchiveObject(withFile: levelStarsFilePath) as? [AnyObject] {
		levelStars = array as! [Int]
		print(levelStars)
	} else {
		print("Did Not UnArchive LevelStars")
	}
}

public func archiveStars() {
	NSKeyedArchiver.archiveRootObject(levelStars, toFile: levelStarsFilePath)
}


public func unArchiveLockedLevels() {
	if let array = NSKeyedUnarchiver.unarchiveObject(withFile: levelsLockedFilePath) as? [AnyObject] {
		levelUnlockedBools = array as! [Bool]
	}
}

public func archiveLockedLevels() {
	NSKeyedArchiver.archiveRootObject(levelUnlockedBools, toFile: levelsLockedFilePath)
}




public func resetLockedLevels() {
	for level in 1...20 {
		if level == 1{
			levelUnlockedBools.append(true)
		} else {
			levelUnlockedBools.append(false)
		}
	}
	print(levelUnlockedBools)
	
}

public func unlockAllLevels() {
	for _ in 1...20 {
		levelUnlockedBools.append(true)
		
	}
	print(levelUnlockedBools)
	
}

public func resetToZeroStars() {
	
	var i:Int = 0
	while i < 20 {
		levelStars.append(0)
		i += 1
	}
	print("The leve stars\(levelStars)")

}






public func starCalculator(_ currentLevel: Int, score: Int, minScoreFor2Stars: Int, minScoreFor3Stars: Int) -> Int {
	if score >= minScoreFor3Stars {
		levelStarCount[currentLevel] = 3
		print("This level earned \(levelStarCount[currentLevel]) Stars")
		return 3
	}
	else if score >= minScoreFor2Stars && score < minScoreFor3Stars {
		levelStarCount[currentLevel] = 2
		print("This level earned \(levelStarCount[currentLevel]) Stars")
		return 2
	}
	else {
		levelStarCount[currentLevel] = 1
		print("This level earned \(levelStarCount[currentLevel]) Stars")
		return 1
	}
}




extension String {
	
	subscript (i: Int) -> Character {
		return self[self.characters.index(self.startIndex, offsetBy: i)]
	}
	
	subscript (i: Int) -> String {
		return String(self[i] as Character)
	}
	
 	subscript (r: Range<Int>) -> String {
		let start = characters.index(startIndex, offsetBy: r.lowerBound)
		let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
		return self[Range(start ..< end)]
		
		
	}
	
}

extension String {
	
	subscript (r: CountableClosedRange<Int>) -> String {
		get {
			let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
			let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
			return self[startIndex...endIndex]
		}
	}
}

// GridMatrix Syntax:	[Column,Row] : [1,1] - [4,4]
// Allys			[Column,Row] : [1,1] - [3,3]


