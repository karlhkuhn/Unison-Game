//
//  Audio.swift
//  Unison
//
//  Created by Karl H Kuhn on 2/1/16.
//  Copyright © 2016 Karl Kuhn. All rights reserved.
//

import AVFoundation
import SpriteKit

var backgroundMusicPlayer = AVAudioPlayer()

func playBackgroundMusic(_ filename: String) {
	let url = Bundle.main.url(forResource: filename, withExtension: nil)
	guard let newURL = url else {
		print("Could not find file: \(filename)")
		return
	}
	do {
		backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
		backgroundMusicPlayer.numberOfLoops = -1
		backgroundMusicPlayer.prepareToPlay()
		backgroundMusicPlayer.volume = 0.6
		backgroundMusicPlayer.play()
	} catch let error as NSError {
		print(error.description)
	}
}

let playButtonPressSound = SKAction.playSoundFileNamed("ButtonPressBellHighSound.mp3", waitForCompletion: false)
let creditButtonPressSound = SKAction.playSoundFileNamed("ButtonPressBellMidSound.mp3", waitForCompletion: false)
let playerAtGoalSound = SKAction.playSoundFileNamed("BellsGoalSound.mp3", waitForCompletion: false)
let playerHitObstacle = SKAction.playSoundFileNamed("HitObjectSound.mp3", waitForCompletion: false)
let playerDeathSound = SKAction.playSoundFileNamed("MainPlayerDeathSound.mp3", waitForCompletion: false)
let playerMoveSound = SKAction.playSoundFileNamed("MainPlayerMoveSound.mp3", waitForCompletion: false)
let mirrorMoveSound = SKAction.playSoundFileNamed("MirrorMoveSound.mp3", waitForCompletion: false)
let chiorTransitionSound = SKAction.playSoundFileNamed("ChiorTransitionSound.mp3", waitForCompletion: false)
let playDeniedSound = SKAction.playSoundFileNamed("DeniedSound.mp3", waitForCompletion: false)
let successSong = SKAction.playSoundFileNamed("successSoundEffect.mp3", waitForCompletion: false)
let popSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
let powerUpSound = SKAction.playSoundFileNamed("powerUp1.mp3", waitForCompletion: false)



