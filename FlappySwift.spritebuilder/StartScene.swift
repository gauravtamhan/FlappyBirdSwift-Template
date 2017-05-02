//
//  StartScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 10/19/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class StartScene: GamePlayScene {
    
    weak var _playButton: CCNode!
    weak var _optionsButton: CCNode!
    weak var _bakedGoods: CCNode!
    weak var _chef: CCNode!
    
    weak var _backButton: CCNode!
    weak var _resetButton: CCNode!
    
    weak var _sureLabel: CCNode!
    weak var _yesButton: CCNode!
    weak var _noButton: CCNode!
    weak var _conformationLabel: CCNode!
    
    var audioPlayer = AVAudioPlayer()
    
    
    override func didLoadFromCCB() {
        playAudio()
    }
    
    override func update(_ delta: CCTime) {
        
    }
    
    func play() {
        
        let scene = CCBReader.load(asScene: "MainScene")
        CCDirector.shared().replace(scene)
    }
    
    func options() {
        _playButton.visible = false
        _optionsButton.visible = false
        _bakedGoods.visible = false
        _chef.visible = false
        
        _backButton.visible = true
        _resetButton.visible = true
    }
    
    func back() {
        _playButton.visible = true
        _optionsButton.visible = true
        _bakedGoods.visible = true
        _chef.visible = true
        
        _backButton.visible = false
        _resetButton.visible = false
    }
    
    func reset() {
        _sureLabel.visible = true
        _yesButton.visible = true
        _noButton.visible = true
        
        _backButton.visible = false
        _resetButton.visible = false
    }
    
    func yes() {
        defaults.set(0, forKey: "highscore")
        
        _sureLabel.visible = false
        _yesButton.visible = false
        _noButton.visible = false
        
        _backButton.visible = true
        _resetButton.visible = true
        
        _conformationLabel.visible = true
        self.animationManager.runAnimations(forSequenceNamed: "Other Timeline")
    }
    
    func no() {
        _sureLabel.visible = false
        _yesButton.visible = false
        _noButton.visible = false
        
        _backButton.visible = true
        _resetButton.visible = true
    }
    
    func playAudio() {
        do {
            if let bundle = Bundle.main.path(forResource: "menuMusic", ofType: "mp3") {
                let alertSound = URL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOf: alertSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        } catch {
            print(error)
        }
    }
      

}
