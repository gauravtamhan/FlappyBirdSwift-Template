//
//  MainScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit
import AVFoundation

var highscoreCount = 0

class MainScene: GamePlayScene {

    let firstObstaclePosition: CGFloat = 300
    let distanceBetweenObstacles: CGFloat = 180
    
    weak var _obstaclesLayer: CCNode!
    
    weak var _restartButton: CCNode!
    weak var _quitButton: CCNode!
    weak var _darkScreen: CCNode!
    weak var _line: CCLabelTTF!
    weak var _scoreLabel: CCLabelTTF!
    weak var _scoreLabelEnd: CCLabelTTF!
    weak var _scoreEnd: CCLabelTTF!
    weak var _highScoreLabel: CCLabelTTF!
    weak var highScoreLabel: CCLabelTTF!
    
    var points = 0
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    
    //var defaults = NSUserDefaults()
    
    func playAudio() {
        do {
            if let bundle = Bundle.main.path(forResource: "FrenchMusic", ofType: "mp3") {
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
    
    func playAudio2() {
        do {
            if let bundle = Bundle.main.path(forResource: "laugh", ofType: "mp3") {
                let alertSound = URL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer2 = AVAudioPlayer(contentsOf: alertSound)
                audioPlayer2.prepareToPlay()
                audioPlayer2.play()
            }
        } catch {
            print(error)
        }
    }
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        
        highScoreLabel.string = String(defaults.integer(forKey: "highscore"))
     
        playAudio()
        
        isUserInteractionEnabled = true
        _gamePhysicsNode.collisionDelegate = self
        
        hero = CCBReader.load("Character") as? Character
        _gamePhysicsNode.addChild(hero)
        
        // makes the bun fall at the start of the gameplay scene
        _gamePhysicsNode.gravity = CGPoint(x: 0.0, y: -800)
        
        
        for i in 1 ..< 4 {
            spawnNewObstacle()
        }
    }
    
    override func touchBegan(_ touch: CCTouch!, with event: CCTouchEvent!) {
        if (!isGameOver) {
            hero?.flap()
            sinceTouch = 0
        }
        _gamePhysicsNode.gravity = CGPoint(x: 0.0, y: -850.0)
    }
    
    func spawnNewObstacle() {
        var prevObstaclePos = firstObstaclePosition
        if obstacles.count > 0 {
            prevObstaclePos = obstacles.last!.position.x
        }
        
        let obstacle = CCBReader.load("Obstacle") as! Obstacle
        obstacle.position = ccp(prevObstaclePos + distanceBetweenObstacles, 0)
        obstacle.setupRandomPosition()
        obstacles.append(obstacle)
        
        _obstaclesLayer.addChild(obstacle)
    }
    
    override func update(_ delta: CCTime) {
        super.update(delta)
        
        for obstacle in obstacles.reversed() {
            let obstacleWorldPosition = _gamePhysicsNode.convert(toWorldSpace: obstacle.position)
            let obstacleScreenPosition = convert(toNodeSpace: obstacleWorldPosition)
            
            if obstacleScreenPosition.x < (-obstacle.contentSize.width) {
                obstacle.removeFromParent()
                if let index = obstacles.index(of: obstacle) {
                    obstacles.remove(at: index)
                }
                
                spawnNewObstacle()
            }
        }
    }
    
    func restart() {
        let scene = CCBReader.load(asScene: "MainScene")
        CCDirector.shared().replace(scene)
    }
    
    func quit() {
        let scene2 = CCBReader.load(asScene: "StartScene")
        CCDirector.shared().replace(scene2)
    }
    
    func gameOver() {
        if (isGameOver == false) {
            //prevents update() in gamePlayScene from being called
            isGameOver = true
            
            
            
            audioPlayer.stop()
            playAudio2()
            
            
            //make the button show up
            _darkScreen.visible = true
            _restartButton.visible = true
            _quitButton.visible = true
            _line.visible = true
            
            _scoreLabelEnd.visible = true
            _scoreEnd.visible = true
            _highScoreLabel.visible = true
            highScoreLabel.visible = true
            
            self.animationManager.runAnimations(forSequenceNamed: "game over")
            
            
            
            //stop scrolling
            scrollSpeed = 0
            
            //stop all hero action
            hero?.rotation = 90
            hero?.physicsBody.allowsRotation = false
            hero?.stopAllActions()
            
            //shake the screen
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.1, position: ccp(0, 3)))
            let moveBack = CCActionEaseBounceOut(action: move?.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            run(shakeSequence)
        }
    }
    
    func ccPhysicsCollisionBegin(_ pair: CCPhysicsCollisionPair!, hero: CCNode!,level: CCNode!) -> Bool {
        gameOver()
        return true
    }
    
    func ccPhysicsCollisionBegin(_ pair: CCPhysicsCollisionPair!,hero: CCNode!,goal: CCNode!) -> Bool {
        goal.removeFromParent()
        points += 1
        _scoreLabel.string = String(points)
        _scoreLabelEnd.string = String(points)
        
        let highscore = defaults.integer(forKey: "highscore")
        
        if points > highscore {
            
            defaults.set(points, forKey: "highscore")
            
        }
        
        let highscoreShow = defaults.integer(forKey: "highscore")
        highScoreLabel.string = String(highscoreShow)
        highscoreCount = highscoreShow
        
       
        
        
        return true
    }
}
