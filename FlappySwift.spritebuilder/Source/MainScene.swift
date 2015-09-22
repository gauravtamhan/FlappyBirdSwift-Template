//
//  MainScene.swift
//  FlappySwift
//
//  Created by Gaurav Tamhan on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class MainScene: GamePlayScene {

    let firstObstaclePosition: CGFloat = 200
    let distanceBetweenObstacles: CGFloat = 160
    
    weak var _obstaclesLayer: CCNode!
    weak var _restartButton: CCNode!
    weak var _scoreLabel: CCLabelTTF!
    var points = 0
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        
        userInteractionEnabled = true
        _gamePhysicsNode.collisionDelegate = self
        
        hero = CCBReader.load("Character") as? Character
        _gamePhysicsNode.addChild(hero)
        
        for var i = 1; i < 4; ++i {
            spawnNewObstacle()
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (!isGameOver) {
            hero?.flap()
            sinceTouch = 0
        }
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
    
    override func update(delta: CCTime) {
        super.update(delta)
        
        for obstacle in obstacles.reverse() {
            let obstacleWorldPosition = _gamePhysicsNode.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = convertToNodeSpace(obstacleWorldPosition)
            
            if obstacleScreenPosition.x < (-obstacle.contentSize.width) {
                obstacle.removeFromParent()
                if let index = obstacles.indexOf(obstacle) {
                    obstacles.removeAtIndex(index)
                }
                // obstacles.find(indexOf(obstacles, obstacle)!)
                
                spawnNewObstacle()
            }
        }
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func gameOver() {
        if (isGameOver == false) {
            //prevents update() in gamePlayScene from being called
            isGameOver = true
            
            //make the button show up
            _restartButton.visible = true
            
            //stop scrolling
            scrollSpeed = 0
            
            //stop all hero action
            hero?.rotation = 90
            hero?.physicsBody.allowsRotation = false
            hero?.stopAllActions()
            
            //shake the screen
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.1, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!,level: CCNode!) -> Bool {
        gameOver()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!,hero: CCNode!,goal: CCNode!) -> Bool {
        goal.removeFromParent()
        points++
        _scoreLabel.string = String(points)
        return true
    }
}
