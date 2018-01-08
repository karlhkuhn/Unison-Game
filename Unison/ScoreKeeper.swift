//
//  ScoreKeeper.swift
//  Unison
//
//  Created by Karl H Kuhn on 6/9/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ScoreKeeper: SKNode {
	
	
	
	let currentWineEntityName = "TastedWine"
	var timerCount:Int = 20000
	var timerRunning = false
	var timer = Timer()
	var numberFormatter = NumberFormatter()
	var secondsCount = 0
	var minutesCount = 0
	var hourCount = 0
	
	var label = SKLabelNode()
	
	override init() {
		super.init()
		
		
		
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		let currentTimerCount = timerCount as NSNumber
		label.text = "SCORE: \(numberFormatter.string(from: currentTimerCount)!)"
		label.fontName = "RifficFree-Bold"
		label.fontColor = UIColor.white
		label.colorBlendFactor = 1
		label.fontSize = 84

		addChild(label)

	}

	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func start() {
		if timerRunning == false {
			timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ScoreKeeper.counting), userInfo: nil, repeats: true)
			RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
			timerRunning = true
		}
	}
	
	func stop() {
		if timerRunning == true {
			timer.invalidate()
			timerRunning = false
		}
	}
	
	func counting() {
		let currentTimerCount = timerCount as NSNumber
		if timerCount > 0 {
			timerCount -= 50
			label.text = "SCORE: \(numberFormatter.string(from: currentTimerCount)!)"
		}
	}
	
	func updateLabel() {
		let currentTimerCount = timerCount as NSNumber
		label.text = "SCORE: \(numberFormatter.string(from: currentTimerCount)!)"

	}
	

	

}
